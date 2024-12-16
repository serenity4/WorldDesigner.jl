struct CharacterNodeOptions
  size::Float64
end

CharacterNodeOptions(; size = DEFAULT_CHARACTER_NODE_SIZE) = CharacterNodeOptions(size)

struct CharacterNode
  coordinates::P2
  info::CharacterInfo
end

struct PlaceNodeOptions
  size::Float64
end

PlaceNodeOptions(; size = DEFAULT_PLACE_NODE_SIZE) = PlaceNodeOptions(size)


struct PlaceNode
  coordinates::P2
  info::PlaceInfo
end

struct EventNodeOptions
  size::Float64
end

EventNodeOptions(; size = DEFAULT_EVENT_NODE_SIZE) = EventNodeOptions(size)

struct EventNode
  coordinates::P2
  info::EventInfo
end

struct WorldGraph
  character_options::CharacterNodeOptions
  place_options::PlaceNodeOptions
  event_options::EventNodeOptions
  characters::Vector{CharacterNode}
  places::Vector{PlaceNode}
  events::Vector{EventNode}
end

function WorldGraph(; character_options = CharacterNodeOptions(),
                      place_options = PlaceNodeOptions(),
                      event_options = EventNodeOptions(),
                      characters = [],
                      places = [],
                      events = [],
                    )
  WorldGraph(character_options, place_options, event_options, characters, places, events)
end
