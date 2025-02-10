function generate_characters_tab!(state::ApplicationState)
  reuse_interaction_set(:central_panel)
  @get_widget central_panel
  isempty(state.characters) && return
  list = map(character_list_entry, state.characters)
  place(list[1] |> at(:top_left), central_panel |> at(:top_left) |> at((2, -2)))
  for item in list
    align(item |> at(:left), list[1] |> at(:left), :vertical)
  end
  distribute(list, :vertical; spacing = 1, mode = :geometry)
end

function character_list_entry(info::CharacterInfo)
  namespace = "characters/$(info.name)"
  @get_widget central_panel
  @set_name namespace name = Text(styled"{black:$(info.name)}"; font = "MedievalSharp", size = 0.7)
  @set_name namespace icon = character_icon(info.illustration)
  @set_name namespace background = Rectangle((1, 1), RGB(0.7, 0.4, 0.1))
  add_callback(background, BUTTON_PRESSED) do input
    is_left_click(input) || return
    generate_character_tab(info)
  end
  place_after(name, icon; spacing = 1.0)
  put_in_front(background, central_panel)
  put_behind(background, icon)
  put_behind(background, name)
  pin(background, :top_left, at(icon, :top_left))
  pin(background, :bottom_left, at(icon, :bottom_left))
  pin(background, :right, at(central_panel, :right); offset = -2)
  Group(name, icon, background)
end

character_icon(illustration::Illustration) = Rectangle((3, 3), texture_file(illustration.asset), ImageParameters(is_opaque = true, mode = ImageModeCropped(; illustration.focus, illustration.zoom)))
character_icon(::Nothing) = character_icon_placeholder()
character_icon_placeholder() = character_icon(Illustration("characters/character-icon-placeholder.png"))

character_portrait(illustration::Illustration) = Rectangle((3, 3), texture_file(illustration.asset), ImageParameters(is_opaque = true, mode = ImageModeCropped(; illustration.focus)))
character_portrait(::Nothing) = character_portrait_placeholder()
character_portrait_placeholder() = character_portrait(Illustration("characters/character-icon-placeholder.png"))

function regenerate_characters_tab(token = nothing)
  generate_characters_tab!(app.state)
  isnothing(token) && return
  token[] === nothing && return
  unbind(token[])
  token[] = nothing
end

function generate_character_tab(info::CharacterInfo)
  reuse_interaction_set(:central_panel)
  namespace = "character/$(info.name)"
  panel = @get_widget central_panel

  @set_name namespace go_back_arrow = Rectangle((2, 2), texture_file("go-back-arrow.jpg"), ImageParameters(is_opaque = true))
  place(at(go_back_arrow, :top_left), at(panel, :top_left) |> at((1, -1)))
  token = Ref{Optional{KeyBindingsToken}}(nothing)
  token[] = bind([key"backspace", key"escape"] .=> () -> regenerate_characters_tab(token))
  add_callback(input -> regenerate_characters_tab(token), go_back_arrow, BUTTON_PRESSED)

  @set_name namespace illustration = character_portrait(info.illustration)
  pin(illustration, :left, at(panel, :left) |> 0.1width())
  pin(illustration, :top, at(panel, :top) |> -0.2height())
  pin(illustration, :bottom, at(panel, :bottom) |> 0.3height())
  pin(illustration, :right, at(panel, :right) |> -0.6width())

  @set_name namespace name = Text(styled"{black:$(info.name)}"; font = "MedievalSharp", size = 2.0, editable = true, on_edit = name -> update_character_info(info; name))
  place(at(name, :left), at(panel, :center) |> 0.1width())
  align(at(name, :top), at(illustration, :top), :horizontal)

  @set_name namespace race = Text(styled"{black:$(@something(info.race, \"Race\"))}"; font = "MedievalSharp", size = 1.0, editable = true, on_edit = race -> update_character_info(info; race))
  place(at(race, :left), at(name, :left) |> at(0, -3))

  @set_name namespace gender = Text(styled"{black:$(@something(info.gender, \"Gender\"))}"; font = "MedievalSharp", size = 1.0, editable = true, on_edit = gender -> update_character_info(info; gender))
  place(at(gender, :left), at(race, :left) |> at(0, -1.5))

  @set_name namespace social_function = Text(styled"{black:$(@something(info.social_function, \"Social function\"))}"; font = "MedievalSharp", size = 1.0, editable = true, on_edit = social_function -> update_character_info(info; social_function))
  place(at(social_function, :left), at(gender, :left) |> at(0, -1.5))

  @set_name namespace description = Text(styled"{black:$(@something(info.description, \"Description\"))}"; font = "MedievalSharp", size = 1.0, editable = true, on_edit = description -> update_character_info(info; description))
  place(at(description, :left), at(illustration, :right) |> at(1.5, 0))
  align(at(description, :top), at(social_function, :top) |> at(0, -3), :horizontal)

  token
end

function update_character_info(info::CharacterInfo; kwargs...)
  state = get_state()
  i = findfirst(==(info), state.characters)
  isnothing(i) && return false
  state.characters[i] = setproperties(info, NamedTuple(kwargs))
  true
end
