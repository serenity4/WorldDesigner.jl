@observable mutable struct ApplicationState
  active_tab::String
  characters::Vector{CharacterInfo}
  places::Vector{PlaceInfo}
  events::Vector{EventInfo}
  graph::WorldGraph
  interaction_sets::Dict{Symbol, InteractionSet}
end

function ApplicationState(active_tab = "Characters"; characters = [], places = [], events = [])
  ApplicationState(active_tab, characters, places, events, WorldGraph(), Dict())
end

get_state() = app.state::ApplicationState

get_interaction_set(set::Symbol) = get!(InteractionSet, get_state().interaction_sets, set)

use_interaction_set(set::Symbol) = Anvil.use_interaction_set(get_interaction_set(set))
use_interaction_set(f, set::Symbol) = Anvil.use_interaction_set(f, get_interaction_set(set))

function reuse_interaction_set(set::Symbol)
  use_interaction_set(set)
  wipe!(current_interaction_set())
end

function reuse_interaction_set(f, set::Symbol)
  use_interaction_set(set) do
    f()
    wipe!(current_interaction_set())
  end
end
