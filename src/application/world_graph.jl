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
  for character in graph.characters
    @set_name namespace icon = character_icon(character.info.illustration)
    set_geometry(icon, (size, size))
    coordinates = Ref(character.coordinates)
    place(icon, central_panel |> at(coordinates))
    let origin = Ref(P2(0, 0)), last_displacement = Ref(P2(0, 0))
      add_callback(icon, DRAG, BUTTON_PRESSED; drag_threshold = 0.1) do input
        displace_when_dragging!(coordinates, origin, last_displacement, icon, input)
        input.type === DRAG || return
        i = findfirst(node -> node.info == character.info, graph.characters)
        isnothing(i) && return
        node = graph.characters[i]
        graph.characters[i] = @set node.coordinates = coordinates[]
      end
      add_callback(icon, POINTER_ENTERED) do input
        reuse_interaction_set(:summary_on_hover) do
          # TODO: Add background image.
          @set_name namespace frame = Rectangle((5, 3), RGB(1, 0, 0))
          place(at(frame, :bottom_left), at(icon, :top_right))
          set_z(frame, Inf)
        end
      end
      add_callback(icon, POINTER_EXITED) do input
        reuse_interaction_set(() -> nothing, :summary_on_hover)
      end
    end
  end
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
