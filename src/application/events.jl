function generate_events_tab!(state::ApplicationState)
  reuse_interaction_set(:central_panel)
  @get_widget central_panel
  isempty(state.events) && return
  list = map(event_list_entry, state.events)
  place(list[1] |> at(:top_left), central_panel |> at(:top_left) |> at((2, -5)))
  for item in list
    align(item |> at(:left), :vertical, list[1] |> at(:left))
  end
  distribute(list, :vertical, 1, :geometry)
end

function event_list_entry(info::EventInfo)
  namespace = "events/$(info.name)"
  @get_widget central_panel
  @set_name namespace name = Text(styled"{black:$(info.name)}"; font = "MedievalSharp", size = 0.7)
  @set_name namespace icon = event_icon(info.illustration)
  @set_name namespace background = Rectangle((1, 1), RGB(0.7, 0.4, 0.1))
  add_callback(background, BUTTON_PRESSED) do input
    generate_event_tab(info)
  end
  place_after(name, icon; spacing = 1.0)
  put_behind(background, icon)
  put_behind(background, name)
  pin(background, :top_left, at(icon, :top_right))
  pin(background, :bottom_left, at(icon, :bottom_right))
  pin(background, :right, at(central_panel, :right); offset = -2)
  Group(name, icon, background)
end

event_icon(asset::String) = Rectangle((3, 3), texture_file(asset), ImageParameters(is_opaque = true))
event_icon(::Nothing) = event_icon_placeholder()
event_icon_placeholder() = event_icon("events/event-illustration-placeholder.png")

event_illustration(asset::String) = Rectangle((3, 3), texture_file(asset), ImageParameters(is_opaque = true, mode = ImageModeCropped()))
event_illustration(::Nothing) = event_illustration_placeholder()
event_illustration_placeholder() = event_illustration("events/event-illustration-placeholder.png")

function regenerate_events_tab(token = nothing)
  generate_events_tab!(app.state)
  isnothing(token) && return
  token[] === nothing && return
  unbind(token[])
  token[] = nothing
end

function generate_event_tab(info::EventInfo)
  reuse_interaction_set(:central_panel)
  namespace = "event/$(info.name)"
  panel = @get_widget central_panel

  @set_name namespace go_back_arrow = Rectangle((2, 2), texture_file("go-back-arrow.jpg"), ImageParameters(is_opaque = true))
  place(at(go_back_arrow, :top_left), at(panel, :top_left) |> at((1, -1)))
  token = Ref{Optional{KeyBindingsToken}}(nothing)
  token[] = bind([key"backspace", key"escape"] .=> () -> regenerate_events_tab(token))
  add_callback(input -> regenerate_events_tab(token), go_back_arrow, BUTTON_PRESSED)

  @set_name namespace illustration = event_illustration(info.illustration)
  pin(illustration, :left, at(panel, :left) |> 0.1width())
  pin(illustration, :top, at(panel, :top) |> -0.2height())
  pin(illustration, :bottom, at(panel, :bottom) |> 0.3height())
  pin(illustration, :right, at(panel, :right) |> -0.6width())

  @set_name namespace name = Text(styled"{black:$(info.name)}"; font = "MedievalSharp", size = 2.0, editable = true, on_edit = name -> update_event_info(info; name))
  place(at(name, :left), at(panel, :center) |> at(5, 0))
  align(at(name, :top), :horizontal, at(go_back_arrow, :top) |> at(0, -4))

  @set_name namespace description = Text(styled"{black:$(@something(info.description, \"Description\"))}"; font = "MedievalSharp", size = 1.0, editable = true, on_edit = description -> update_event_info(info; description))
  place(at(description, :left), at(illustration, :right) |> at(1.5, 0))
  align(at(description, :top), :horizontal, at(name, :top) |> at(0, -3))
end

function update_event_info(info::EventInfo; kwargs...)
  state = get_state()
  i = findfirst(==(info), state.events)
  isnothing(i) && return false
  state.events[i] = setproperties(info, NamedTuple(kwargs))
  true
end
