module WorldDesigner

using Anvil
using Anvil: Text, bind
using MLStyle: @when, @match, @switch
using ForwardMethods: @forward_methods, @forward_interface

using Base.ScopedValues: ScopedValue, @with
using Dates

const Optional{T} = Union{T, Nothing}
const FilePath = String

include("characters.jl")
include("interaction_set.jl")

include("application/state.jl")
include("application/main.jl")
include("application/characters.jl")

function __init__()
  Anvil.APPLICATION_DIRECTORY = joinpath(dirname(@__DIR__))
  Anvil.ASSET_DIRECTORY = joinpath(dirname(@__DIR__), "assets")
end

export
        main,
        Anvil,

        CharacterInfo,
        ApplicationState

end
