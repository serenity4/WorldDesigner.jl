function Base.show(io::IO, state::ApplicationState)
  show(io, ApplicationState)
  print(io, ')', state.active_tab, ", ", state.characters, ')')
end
