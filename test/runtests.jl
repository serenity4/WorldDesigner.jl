using WorldDesigner
using WorldDesigner: app, execute, CharacterNode
using Logging
using Test

Logging.disable_logging(Logging.Info)
# Logging.disable_logging(Logging.BelowMinLevel)
remove_validation_message_filters()
# filter_validation_message("VUID-VkImageViewCreateInfo-usage-02275")
filter_validation_message("VUID-VkSwapchainCreateInfoKHR-presentMode-02839")
ENV["JULIA_DEBUG"] = "WorldDesigner,Anvil"
# ENV["JULIA_DEBUG"] = "Anvil,CooperativeTasks"
ENV["ANVIL_LOG_FRAMECOUNT"] = false
# ENV["ANVIL_LOG_KEY_PRESS"] = true
# ENV["ANVIL_RELEASE"] = true # may circumvent issues with validation layers

default_tab = "Characters"
characters = [
  CharacterInfo("Unknown"),
  CharacterInfo("Kaven"; illustration = Illustration("characters/Kaven.jpg", (0.45, 0.5), 1.5)),
  CharacterInfo("Keena"; illustration = Illustration("characters/Keena.jpg", (0.5, 0.73), 2)),
  CharacterInfo("Lyv"; illustration = Illustration("characters/Lyv.jpg", (0.5, 0.6), 1.4)),
  CharacterInfo("Nyra"; illustration = Illustration("characters/Nyra.jpg", (0.45, 0.63), 3)),
  CharacterInfo("Ramoz"; illustration = Illustration("characters/Ramoz.jpg", (0.57, 0.75), 2.5)),
  CharacterInfo("Velia"; illustration = Illustration("characters/Velia.jpg")),
  CharacterInfo("Zhevyr"; illustration = Illustration("characters/Zhevyr.jpg")),
]
places = [
  PlaceInfo("Academy of Magic"; illustration = "places/Academy of Magic.jpg"),
  PlaceInfo("Ouros"; illustration = "places/Magic city - residential street.jpg"),
  PlaceInfo("Training grounds"; illustration = "places/Training grounds - 1.jpg"),
  # TODO: Change name & illustration.
  PlaceInfo("Simitar"; illustration = "events/Fel volcano.jpg"),
]
events = [
  EventInfo("Corruption of the volcano"; illustration = "events/Fel volcano.jpg", elements = [places[4]], date = Date(246, 6, 17)),
  EventInfo("Welcoming ceremony"; illustration = "places/Academy of Magic.jpg", elements = [places[1]; characters[[2, 4, 5, 7, 8]]], date = Date(246, 5, 12)),
]
state = ApplicationState(default_tab; characters, places, events)
append!(state.graph.characters, CharacterNode.([
  (1, 1),
  (-3, 0),
  (5, 1),
  (10, -4),
  (7, 4),
  (-4, -3),
  (-4, 5),
], characters[2:end]))

main(state)

@testset "WorldDesigner.jl" begin
  main(state; async = true)
  @execute state.active_tab = "Characters"
  sleep(0.1)
  @execute state.active_tab = "Places"
  sleep(0.1)
  @execute state.active_tab = "Events"
  sleep(0.1)
  @execute state.active_tab = "World graph"
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
