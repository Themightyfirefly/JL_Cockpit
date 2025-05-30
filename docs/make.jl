using jl_cockpit
using Documenter

DocMeta.setdocmeta!(jl_cockpit, :DocTestSetup, :(using jl_cockpit); recursive=true)

makedocs(;
    modules=[jl_cockpit],
    authors="Niklas Schlüter niklas.schlueter@tu-berlin.de",
    sitename="jl_cockpit.jl",
    format=Documenter.HTML(;
        canonical="https://Themightyfirefly.github.io/jl_cockpit.jl",
        edit_link="main",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
    ],
)

deploydocs(;
    repo="github.com/Themightyfirefly/jl_cockpit.jl",
    devbranch="main",
)
