struct PlaceInfo
  name::String
  illustration::Optional{Illustration}
  description::Optional{String}
end

function PlaceInfo(name; illustration = nothing, description = nothing)
  PlaceInfo(name, illustration, description)
end
