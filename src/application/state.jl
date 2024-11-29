@observable mutable struct ApplicationState
  active_tab::String
  characters::Vector{CharacterInfo}
  interaction_sets::Dict{Symbol, InteractionSet}
end

ApplicationState(active_tab, characters) = ApplicationState(active_tab, characters, Dict())
ApplicationState() = ApplicationState("Characters", [])

get_state() = app.state::ApplicationState

const INTERACTION_SET = ScopedValue{Symbol}()

add_widget!(state, widget) = push!(get!(InteractionSet, state.interaction_sets, INTERACTION_SET[]), widget)
add_widgets!(state, widget, widgets...) = for widget in (widget, widgets...) add_widget!(state, widget) end
add_widget(widget, widgets...) = add_widget!(app.state, widget, widgets...)
add_widgets(widget, widgets...) = add_widgets!(app.state, widget, widgets...)

remove_widget!(state, widget) = delete!(state.interaction_sets[INTERACTION_SET[]], widget)
remove_widgets!(state, widget, widgets...) = for widget in (widget, widgets...) remove_widget!(state, widget) end
remove_widget(widget, widgets...) = remove_widget!(app.state, widget, widgets...)
remove_widgets(widget, widgets...) = remove_widgets!(app.state, widget, widgets...)

function wipe_central_panel()
  set = get_state().interaction_sets[:central_panel]
  wipe!(set)
end
