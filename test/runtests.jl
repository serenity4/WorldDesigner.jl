using WorldDesigner
using Logging
using Test

Logging.disable_logging(Logging.Info)
# Logging.disable_logging(Logging.BelowMinLevel)
ENV["JULIA_DEBUG"] = "Anvil"
# ENV["JULIA_DEBUG"] = "Anvil,CooperativeTasks"
# ENV["ANVIL_LOG_FRAMECOUNT"] = false
# ENV["ANVIL_LOG_KEY_PRESS"] = true
# ENV["ANVIL_RELEASE"] = true # may circumvent issues with validation layers

@testset "WorldDesigner.jl" begin
  default_tab = "Characters"
  characters = [
    CharacterInfo("Unknown"),
    CharacterInfo("Kaven"; portrait = "kaven.jpg"),
  ]
  state = ApplicationState(default_tab, characters)
  main(state)
end
