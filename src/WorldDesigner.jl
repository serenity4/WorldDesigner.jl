module WorldDesigner

using Anvil
using Anvil: Text, bind
using MLStyle: @when, @match, @switch
using ForwardMethods: @forward_methods, @forward_interface
using Reexport

using Base.ScopedValues: ScopedValue, @with
@reexport using Dates

const Optional{T} = Union{T, Nothing}
const FilePath = String

include("illustration.jl")
include("characters.jl")
include("places.jl")
include("events.jl")
include("world_graph.jl")

include("application/state.jl")
include("application/navigation_menu.jl")
include("application/main.jl")
include("application/characters.jl")
include("application/places.jl")
include("application/events.jl")
include("application/world_graph.jl")

include("show.jl")
include("theme.jl")

function __init__()
  @eval Anvil begin
    APPLICATION_DIRECTORY = joinpath(dirname(@__DIR__))
    ASSET_DIRECTORY = joinpath(dirname(@__DIR__), "assets")
  end
  update_theme()
end

export
        Anvil,
        main,
        execute,
        @execute,

        Illustration,

        CharacterInfo,
        generate_character_tab,
        regenerate_characters_tab,
        update_character_info,

        PlaceInfo,
        generate_place_tab,
        regenerate_places_tab,
        update_place_info,

        EventInfo,
        generate_event_tab,
        regenerate_events_tab,
        update_event_info,

        ApplicationState

end
