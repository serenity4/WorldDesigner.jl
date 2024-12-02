struct CharacterInfo
  name::String
  race::Optional{String}
  gender::Optional{String}
  social_function::Optional{String}
  date_of_birth::Optional{DateTime}
  place_of_birth::Optional{String}
  description::Optional{String}
  portrait::Optional{FilePath}
end

function CharacterInfo(name::String; race = nothing, gender = nothing, social_function = nothing,
  date_of_birth = nothing, place_of_birth = nothing, description = nothing, portrait = nothing)
  CharacterInfo(name, race, gender, social_function, date_of_birth, place_of_birth, description, portrait)
end
