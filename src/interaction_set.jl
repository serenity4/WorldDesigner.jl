struct InteractionSet
  widgets::Set{Widget}
end

InteractionSet() = InteractionSet(Set{Widget}())

@forward_interface InteractionSet field = :widgets interface = iteration
@forward_methods InteractionSet field = :widgets begin
  Base.push!(_, widget::Widget)
  Base.delete!(_, widget::Widget)
  Base.empty!(_)
end

function wipe!(set::InteractionSet)
  for widget in set
    delete_widget(widget)
  end
  empty!(set)
end

function delete_widget(widget::Widget)
  disable!(widget)
  unset_widget(widget)
end
