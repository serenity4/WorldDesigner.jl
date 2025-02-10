function generate_world_graph_tab!(state::ApplicationState)
  reuse_interaction_set(:central_panel)
  @get_widget central_panel

  (; graph) = state
  add_character_nodes(graph)
  add_place_nodes(graph)
  add_event_nodes(graph)
end

function add_character_nodes(graph::WorldGraph)
  @get_widget central_panel
  namespace = "world_graph/character_nodes"
  (; size) = graph.character_options
  (; root) = app.systems.event.ui
  for character in graph.characters
    @set_name namespace icon = character_icon(character.info.illustration)
    set_geometry(icon, FilledCircle(size/2))
    coordinates = Ref(character.coordinates)
    place(icon, central_panel |> at(coordinates))
    let origin = Ref(P2(0, 0)), last_displacement = Ref(P2(0, 0))
      add_callback(icon, DRAG, BUTTON_PRESSED; drag_threshold = 0.1) do input
        displace_when_dragging!(coordinates, origin, last_displacement, icon, input)
        input.type === DRAG || return
        i, node = find_node(graph, character)
        graph.characters[i] = @set node.coordinates = coordinates[]
      end
      show_summary_callback = Ref{Optional{InputCallback}}(nothing)
      hide_summary_callback = Ref{InputCallback}()
      add_callback(icon, POINTER_ENTERED) do input
        show_summary_callback[] = add_callback(root, KEY_PRESSED) do input
          in(input.event.key_event.key_name, (:LCTL, :RCTL)) || return
          add_character_info_frame!(hide_summary_callback, graph, character, icon, namespace)
        end
        in(CTRL_MODIFIER, input.event.pointer_state.modifiers) && add_character_info_frame!(hide_summary_callback, graph, character, icon, namespace)
      end
      add_callback(icon, POINTER_EXITED) do input
        remove_callback(root, show_summary_callback[])
        show_summary_callback[] = nothing
      end
    end
  end
end

function add_character_info_frame!(hide_summary_callback, graph, character, icon, namespace)
  (; root) = app.systems.event.ui
  reuse_interaction_set(:summary_on_hover) do
    _, node = find_node(graph, character)
    isnothing(node) && return
    (; info) = node
    parameters = ImageParameters(is_opaque = true, mode = ImageModeCropped())
    @set_name namespace background = Rectangle((10, 3), texture_file("parchment-background-3"), parameters)
    @set_name namespace name = Text(styled"{black:$(info.name)}"; font = "MedievalSharp", size = 1.0)

    place(at(background, :bottom_left), at(icon, :top_right))
    Layout.record!(app.systems.layout.engine, background) do outputs, inputs
      clip_to_region!(outputs, inputs, get_geometry(@get_widget central_panel).rectangle, 0.3)
    end
    # XXX: Putting the background or name in front or behind of one another
    # wrongly leads to one or none of them being rendered!
    place(at(name, :top), at(background, :top) |> at(-0.5))
  end
  hide_summary_callback[] = add_callback(root, KEY_RELEASED) do input
    in(input.event.key_event.key_name, (:LCTL, :RCTL)) || return
    reuse_interaction_set(() -> nothing, :summary_on_hover)
    remove_callback(root, hide_summary_callback[])
  end
end

function clip_to_region!(outputs, inputs, region, padding)
  outputs .= clip_to_region.(inputs, Ref(region), padding)
end

function clip_to_region(object, region, padding)
  (; position, geometry) = object
  min = region.bottom_left .- geometry.bottom_left .+ padding
  max = region.top_right .- geometry.top_right .- padding
  clipped = clamp.(position, min, max)
  Layout.set_position(object, clipped)
end

function find_node(graph, character)
  i = findfirst(node -> node.info == character.info, graph.characters)
  isnothing(i) && return 0, nothing
  i, graph.characters[i]
end

function displace_when_dragging!(location::Ref, origin::Ref, last_displacement::Ref, object, input::Input)
  if is_left_click(input)
    origin[] = location[]
    last_displacement[] = origin[]
  elseif input.type === DRAG
    target, event = input.drag
    displacement = event.location .- input.source.event.location
    segment = displacement .- last_displacement[]
    last_displacement[] = SVector(displacement)
    location[] = origin[] .+ displacement
  end
end

function add_place_nodes(graph::WorldGraph)
  for place in graph.places
    # TODO
  end
end

function add_event_nodes(graph::WorldGraph)
  for event in graph.events
    # TODO
  end
end
