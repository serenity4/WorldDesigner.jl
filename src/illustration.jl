struct Illustration
  asset::FilePath
  focus::Optional{P2}
  zoom::Optional{Float64}
  Illustration(asset, focus = nothing, zoom = nothing) = new(asset, focus, zoom)
end

Base.convert(::Type{Illustration}, asset::AbstractString) = Illustration(asset)
