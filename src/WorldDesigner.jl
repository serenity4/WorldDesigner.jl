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

function define_theme()
  theme_file = joinpath(@__DIR__, "theme.jl")
  Main = Base.active_module()
  if isdefined(Main, :Revise)
    Main.Revise.includet(@__MODULE__(), theme_file)
  else
    include("theme.jl")
  end
end

function __init__()
  @eval Anvil begin
    APPLICATION_DIRECTORY = joinpath(dirname(@__DIR__))
    ASSET_DIRECTORY = joinpath(dirname(@__DIR__), "assets")
  end
  define_theme()
end

export
        main,
        Anvil,

        CharacterInfo,
        ApplicationState

end
