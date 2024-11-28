function generate_characters_tab!(state::ApplicationState)
  @get_widget central_panel
  isempty(state.characters) && return
  list = map(character_list_entry, state.characters)
  place(list[1] |> at(:top_left), central_panel |> at(:top_left) |> at((2, -5)))
  for item in list
    align(item |> at(:left), :vertical, list[1] |> at(:left))
  end
  distribute(list, :vertical, 1, :geometry)
end

function character_list_entry(info::CharacterInfo)
  namespace = "characters/$(info.name)"
  @get_widget central_panel
  @set_name namespace name = Text(styled"{black:$(info.name)}"; font = "MedievalSharp", size = 0.7)
  @set_name namespace icon = character_icon(info.portrait)
  @set_name namespace background = Rectangle((1, 1), RGB(0.7, 0.4, 0.1))
  add_callback(background, BUTTON_PRESSED) do input
    wipe_central_panel()
    @with INTERACTION_SET => INTERACTION_SET_CENTRAL_PANEL generate_character_tab(info)
  end
  place_after(name, icon; spacing = 1.0)
  put_behind(background, icon)
  put_behind(background, name)
  pin(background, :top_left, at(icon, :top_right))
  pin(background, :bottom_left, at(icon, :bottom_right))
  pin(background, :right, at(central_panel, :right); offset = -2)
  add_widgets(name, icon, background)
  Group(name, icon, background)
end

character_icon(asset::String) = Rectangle((3, 3), texture_file(asset), ImageParameters(is_opaque = true))
character_icon(::Nothing) = character_icon_placeholder()
function character_icon_placeholder()
  character_icon("character-icon-placeholder.png")
end

function generate_character_tab(info::CharacterInfo)
  @get_widget central_panel
  image = Rectangle((1, 1), RGB(0.9, 0.3, 0.8))
  pin(image, :bottom_left, at(central_panel, :bottom_left))
  pin(image, :bottom_right, at(central_panel, :bottom_right))
  pin(image, :top_left, at(central_panel, :top_left))
  pin(image, :top_right, at(central_panel, :top_right))
  add_widget(image)
end
