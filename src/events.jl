struct EventInfo
  name::String
  illustration::Optional{Illustration}
  description::Optional{String}
end

function EventInfo(name; illustration = nothing, description = nothing)
  EventInfo(name, illustration, description)
end
