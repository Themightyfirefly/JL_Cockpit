# The following lines are copied from the Makie Docs Build script
# https://github.com/MakieOrg/Makie.jl/blob/master/docs/makedocs.jl
# They are necessary, so that the script can be executed via X11 on the headless server
using Pkg
cd(@__DIR__)
Pkg.activate(".")
Pkg.instantiate()
Pkg.precompile()

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
        "Getting Started" => "getting_started.md",
        "Training and Visualisation" => "training.md",
        "Plot Functions" => "plot_functions.md",
        "Utils" => "utils.md"
    ],
)

deploydocs(;
    repo="github.com/Themightyfirefly/jl_cockpit.jl",
    devbranch="main",
)
