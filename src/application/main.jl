main(state = ApplicationState(); async = false) = Anvil.main(() -> start_app!(state); async)

function start_app!(state::ApplicationState)
  app.state = state
  empty!(state.interaction_sets)
  observe!(state, :active_tab) do previous_tab, active_tab
    previous_tab == active_tab && return
    generate_active_tab!(state)
  end
  finalizer(app) do _
    unobserve!(state)
  end
  characters_tab = add_left_tab!(state, "Characters")
  places_tab = add_left_tab!(state, "Places")
  events_tab = add_left_tab!(state, "Events")
  world_graph_tab = add_left_tab!(state, "World graph")
  left_tabs = EntityID[characters_tab, places_tab, events_tab, world_graph_tab]

  window = app.windows[app.window]
  @set_name central_panel = Rectangle((1, 1), "parchment-background-1.jpg", ImageParameters(mode = ImageModeTiled(scale = 0.03), is_opaque = true))
  pin(central_panel, :left, at(window, :left); offset = 6)
  pin(central_panel, :right, at(window, :right))
  pin(central_panel, :bottom, at(window, :bottom))
  pin(central_panel, :top, at(window, :top))
  for left_tab in left_tabs
    place(left_tab |> at(:right), central_panel |> at(:left))
  end
  align(characters_tab |> at(:top), :horizontal, central_panel |> at(:top) |> at(-2))
  distribute(left_tabs, :vertical, 1, :geometry)
  generate_active_tab!(state)

  # Navigation menu.
  use_interaction_set(:navigation) do
    file_menu = add_file_menu!(state)
    edit_menu = add_edit_menu!(state)
    place(edit_menu.head |> at(:top_left), file_menu.head |> at(:top_right))
  end
end

function add_left_tab!(state, name)
  namespace = "tabs"
  scale = 6
  @set_name namespace tab = Rectangle("tab-left.png", scale = 6)
  color = ifelse(state.active_tab == name, ACTIVE_TAB_COLOR, INACTIVE_TAB_COLOR)
  @set_name namespace text = Text(styled"{color=$color:$name}"; font = "MedievalSharp", size = 0.7)
  put_behind(tab, text)
  observe!(state, :active_tab) do previous_tab, active_tab
    previous_tab == active_tab && return
    previous_tab == name && (text.value = styled"{color=$INACTIVE_TAB_COLOR:$name}")
    active_tab == name && (text.value = styled"{color=$ACTIVE_TAB_COLOR:$name}")
  end
  add_callback(input -> is_left_click(input) && (state.active_tab = name), tab, BUTTON_PRESSED)
  place(text |> at(:center), tab |> at(0.2, 0))
  tab
end

function generate_active_tab!(state::ApplicationState)
  @switch state.active_tab begin
    @case "Characters"
    generate_characters_tab!(state)

    @case "Places"
    generate_places_tab!(state)

    @case "Events"
    generate_events_tab!(state)

    @case "World graph"
    generate_world_graph_tab!(state)
  end
end

function switch_tab!(state::ApplicationState, tab)
  previous_tab = state.active_tab
  previous_tab == tab && return
  previous_tab == name && (text.value = styled"{color=$INACTIVE_TAB_COLOR:$name}")
  tab == name && (text.value = styled"{color=$ACTIVE_TAB_COLOR:$name}")
  generate_active_tab!(state)
end
