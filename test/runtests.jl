using WorldDesigner
using WorldDesigner: app, execute
using Logging
using Test

Logging.disable_logging(Logging.Info)
# Logging.disable_logging(Logging.BelowMinLevel)
ENV["JULIA_DEBUG"] = "WorldDesigner,Anvil"
# ENV["JULIA_DEBUG"] = "Anvil,CooperativeTasks"
# ENV["ANVIL_LOG_FRAMECOUNT"] = false
# ENV["ANVIL_LOG_KEY_PRESS"] = true
# ENV["ANVIL_RELEASE"] = true # may circumvent issues with validation layers


default_tab = "Characters"
characters = [
  CharacterInfo("Unknown"),
  CharacterInfo("Kaven"; portrait = "characters/Kaven.jpg"),
]
places = [
  PlaceInfo("Academy of Magic"; illustration = "places/Academy of Magic.jpg"),
  PlaceInfo("Ouros"; illustration = "places/Magic city - residential street.jpg"),
  PlaceInfo("Training grounds"; illustration = "places/Training grounds - 1.jpg"),
]
events = [
  EventInfo("Corruption of the volcano"; illustration = "events/Fel volcano.jpg"),
]
state = ApplicationState(default_tab; characters, places, events)

main(state)

@testset "WorldDesigner.jl" begin
  main(state; async = true)
  fetch(execute(() -> state.active_tab = "Characters", app.task))
  sleep(0.1)
  fetch(execute(() -> state.active_tab = "Places", app.task))
  sleep(0.1)
  fetch(execute(() -> state.active_tab = "Events", app.task))
  sleep(0.1)
  fetch(execute(() -> state.active_tab = "Characters", app.task))
  sleep(0.1)
  Anvil.exit()
end;
