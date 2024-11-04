main(state = ApplicationState(); async = false) = Anvil.main(() -> start_app(state); async)

function start_app(state::ApplicationState)
  characters_tab = add_left_tab(state, "Characters")
  places_tab = add_left_tab(state, "Places")
  events_tab = add_left_tab(state, "Events")
  left_tabs = EntityID[characters_tab, places_tab, events_tab]

  window = app.windows[app.window]
  (; width, height) = get_geometry(window)
  left_margin = 6
  @set_name central_panel = Image((width - left_margin, height), get_texture("parchment-background-1.jpg"); parameters = ImageParameters(; tiled = true, scale = 0.03))
  place(central_panel |> at(:edge, :left), window |> at(:edge, :left) |> at((left_margin, 0)))
  for left_tab in left_tabs
    place(left_tab |> at(:edge, :right), central_panel |> at(:edge, :left))
  end
  align(characters_tab |> at(:edge, :top), :horizontal, central_panel |> at(:edge, :top) |> at(-2))
  distribute(left_tabs, :vertical, 1, :geometry)
  generate_active_tab(state)

  # File menu.
  file_menu_head = Button(() -> collapse!(file_menu), (3, 1); text = Text("File"))
  file_menu_item_1 = MenuItem(Text("New file"), (3, 1)) do; end
  file_menu_item_2 = MenuItem(Text("Open..."), (3, 1)) do; end
  file_menu_item_3 = MenuItem(Anvil.exit, Text("Exit"), (3, 1), 'x')
  @set_name file_menu = Menu(file_menu_head, [file_menu_item_1, file_menu_item_2, file_menu_item_3], 'F')
  place(file_menu |> at(:corner, :top_left), app.windows[app.window] |> at(:corner, :top_left))

  # Edit menu.
  edit_menu_head = Button(() -> collapse!(edit_menu), (3, 1); text = Text("Edit"))
  edit_menu_item_1 = MenuItem(Text("Regenerate"), (3, 1)) do; end
  @set_name edit_menu = Menu(edit_menu_head, [edit_menu_item_1], 'E')
  place(edit_menu |> at(:corner, :top_left), file_menu |> at(:corner, :top_right))
end

function add_left_tab(state, name)
  @set_name tab = Image(get_texture("tab-left.png"), 6)
  color = state.active_tab == name ? :red : :black
  @set_name text = Text(styled"{$color:$name}"; font = "MedievalSharp", size = 0.7)
  put_behind(tab, text)
  observe!(state, :active_tab) do previous_tab, active_tab
    previous_tab == name && (text.text = styled"{black:$name}")
    active_tab == name && (text.text = styled"{red:$name}")
  end
  set_input_handler(tab, InputComponent(input -> is_left_click(input) && (state.active_tab = name), BUTTON_PRESSED, NO_ACTION))
  place(text, tab |> at(0.2, 0))
  tab
end

function generate_active_tab(state::ApplicationState)
  state.active_tab == "Characters" && return generate_characters_tab(state)
end

# XXX: Make that a widget?
struct CharacterListEntry
  name::Text 
  icon::Image
end
Anvil.to_object(engine::LayoutEngine, entry::CharacterListEntry) = Group(engine, entry.name, entry.icon)

function CharacterListEntry(info::CharacterInfo)
  name = Text(styled"{black:$(info.name)}"; font = "MedievalSharp", size = 0.7)
  icon = character_icon(info.portrait)
  place_after(name, icon; spacing = 1.0)
  CharacterListEntry(name, icon)
end

character_icon(asset::String) = Image((3, 3), texture_file(asset); parameters = ImageParameters(is_opaque = true))
character_icon(::Nothing) = character_icon_placeholder()
function character_icon_placeholder()
  character_icon("character-icon-placeholder.png")
end

function generate_characters_tab(state::ApplicationState)
  @get_widget central_panel
  isempty(state.characters) && return
  list = map(CharacterListEntry, state.characters)
  place(list[1] |> at(:edge, :top), central_panel |> at(:edge, :top) |> at(-5))
  for item in list
    align(item |> at(:edge, :left), :vertical, list[1] |> at(:edge, :left))
  end
  distribute(list, :vertical, 1, :geometry)
end
