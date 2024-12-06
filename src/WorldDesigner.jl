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

include("application/state.jl")
include("application/navigation_menu.jl")
include("application/main.jl")
include("application/characters.jl")

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
        main,
        Anvil,

        CharacterInfo,
        ApplicationState

end
