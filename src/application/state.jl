@observable mutable struct ApplicationState
  active_tab::String
  characters::Vector{CharacterInfo}
end

ApplicationState() = ApplicationState("Characters", CharacterInfo[])
