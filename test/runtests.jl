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
  @execute state.active_tab = "Characters"
  sleep(0.1)
  @execute state.active_tab = "Places"
  sleep(0.1)
  @execute state.active_tab = "Events"
  sleep(0.1)

  # Updating character info.
  @execute state.active_tab = "Characters"
  sleep(0.1)
  character = characters[2]
  token = @execute generate_character_tab(character)
  sleep(0.1)
  @execute update_character_info(character; description = "No description yet!")
  character = characters[2]
  @test character.description == "No description yet!"
  @execute regenerate_characters_tab(token)
  token = @execute generate_character_tab(character)

  # Updating place info.
  @execute state.active_tab = "Places"
  sleep(0.1)
  place = places[2]
  token = @execute generate_place_tab(place)
  sleep(0.1)
  @execute update_place_info(place; description = "No description yet!")
  place = places[2]
  @test place.description == "No description yet!"
  @execute regenerate_places_tab(token)
  token = @execute generate_place_tab(place)

  # Updating event info.
  @execute state.active_tab = "Events"
  sleep(0.1)
  event = events[1]
  token = @execute generate_event_tab(event)
  sleep(0.1)
  @execute update_event_info(event; description = "No description yet!")
  event = events[1]
  @test event.description == "No description yet!"
  @execute regenerate_events_tab(token)
  token = @execute generate_event_tab(event)

  Anvil.exit()
end;
