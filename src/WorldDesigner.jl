module WorldDesigner

using Anvil
using Anvil: Text
using Dates

const Optional{T} = Union{T, Nothing}
const FilePath = String

include("characters.jl")

include("application/state.jl")
include("application/main.jl")
include("application/characters.jl")

function __init__()
  APPLICATION_DIRECTORY[] = joinpath(dirname(@__DIR__))
  ASSET_DIRECTORY[] = joinpath(dirname(@__DIR__), "assets")
end

export
        main,
        Anvil,

        CharacterInfo,
        ApplicationState

end
