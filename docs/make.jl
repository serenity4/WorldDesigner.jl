using WorldDesigner
using Documenter

DocMeta.setdocmeta!(WorldDesigner, :DocTestSetup, :(using WorldDesigner); recursive=true)

makedocs(;
    modules=[WorldDesigner],
    authors="Cédric BELMANT",
    sitename="WorldDesigner.jl",
    format=Documenter.HTML(;
        canonical="https://serenity4.github.io/WorldDesigner.jl",
        edit_link="main",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
    ],
)

deploydocs(;
    repo="github.com/serenity4/WorldDesigner.jl",
    devbranch="main",
)
