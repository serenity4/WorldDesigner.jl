function Base.show(io::IO, state::ApplicationState)
  show(io, ApplicationState)
  print(io, '(', state.active_tab)
  print(io, ", ", state.characters)
  print(io, ", ", state.places)
  print(io, ", ", state.events)
  print(io, ')')
end
