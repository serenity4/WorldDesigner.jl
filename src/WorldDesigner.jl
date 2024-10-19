module WorldDesigner

using Anvil
using Anvil: Text

include("application.jl")

function __init__()
  ASSET_DIRECTORY[] = joinpath(dirname(@__DIR__), "assets")
end

export main, Anvil

end
