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
    place(icon, central_panel |> at(character.coordinates))
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
