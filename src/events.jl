@enum ElementType begin
  ELEMENT_TYPE_CHARACTER
  ELEMENT_TYPE_PLACE
  ELEMENT_TYPE_EVENT
end

struct ElementInfo
  type::ElementType
  name::String # identifier
end

struct EventInfo
  name::String
  illustration::Optional{Illustration}
  description::Optional{String}
  elements::Vector{ElementInfo}
  date::Optional{Date}
  period::Optional{Tuple{Date, Optional{Date}}}
  category::Optional{String}
end

function EventInfo(name; illustration = nothing, description = nothing, date = nothing, period = nothing, category = nothing, elements = ElementInfo[])
  !isnothing(date) && !isnothing(period) && throw(ArgumentError("A date and a period cannot be provided at the same time"))
  EventInfo(name, illustration, description, elements, date, period, category)
end

Base.convert(::Type{ElementInfo}, character::CharacterInfo) = ElementInfo(ELEMENT_TYPE_CHARACTER, character.name)
Base.convert(::Type{ElementInfo}, place::PlaceInfo) = ElementInfo(ELEMENT_TYPE_PLACE, place.name)
Base.convert(::Type{ElementInfo}, event::EventInfo) = ElementInfo(ELEMENT_TYPE_EVENT, event.name)
