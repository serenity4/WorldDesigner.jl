main(state = ApplicationState(); async = false) = Anvil.main(() -> start_app!(state); async)

function start_app!(state::ApplicationState)
  app.state = state
  characters_tab = add_left_tab!(state, "Characters")
  places_tab = add_left_tab!(state, "Places")
  events_tab = add_left_tab!(state, "Events")
  left_tabs = EntityID[characters_tab, places_tab, events_tab]

  window = app.windows[app.window]
  @set_name central_panel = Rectangle((1, 1), "parchment-background-1.jpg", ImageParameters(tiled = true, scale = 0.03, is_opaque = true))
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

  # File menu.
  file_menu_head = Button(() -> collapse!(file_menu), (3, 1); text = Text("File"))
  file_menu_item_1 = MenuItem(Text("New file"), (3, 1)) do; end
  file_menu_item_2 = MenuItem(Text("Open..."), (3, 1)) do; end
  file_menu_item_3 = MenuItem(Anvil.exit, Text("Exit"), (3, 1), 'x')
  @set_name file_menu = Menu(file_menu_head, [file_menu_item_1, file_menu_item_2, file_menu_item_3], 'F')
  place(file_menu |> at(:top_left), app.windows[app.window] |> at(:top_left))

  # Edit menu.
  edit_menu_head = Button(() -> collapse!(edit_menu), (3, 1); text = Text("Edit"))
  edit_menu_item_1 = MenuItem(Text("Regenerate"), (3, 1)) do; end
  @set_name edit_menu = Menu(edit_menu_head, [edit_menu_item_1], 'E')
  place(edit_menu |> at(:top_left), file_menu |> at(:top_right))
end

function add_left_tab!(state, name)
  namespace = "tabs"
  @set_name namespace tab = Rectangle("tab-left.png", ImageParameters(scale = 6))
  color = state.active_tab == name ? :red : :black
  @set_name namespace text = Text(styled"{$color:$name}"; font = "MedievalSharp", size = 0.7)
  put_behind(tab, text)
  observe!(state, :active_tab) do previous_tab, active_tab
    previous_tab == active_tab && return
    previous_tab == name && (text.value = styled"{black:$name}")
    active_tab == name && (text.value = styled"{red:$name}")
    switch_tab!(state, active_tab)
  end
  add_callback(input -> is_left_click(input) && (state.active_tab = name), tab, BUTTON_PRESSED)
  place(text |> at(:center), tab |> at(0.2, 0))
  tab
end

function generate_active_tab!(state::ApplicationState)
  @switch state.active_tab begin
    @case "Characters"
    @with INTERACTION_SET => :central_panel generate_characters_tab!(state)

    @case "Places"
    # TODO
    @case "Events"
    # TODO
  end
end

function switch_tab!(state::ApplicationState, tab::String)
  wipe_central_panel()
  generate_active_tab!(state)
end
