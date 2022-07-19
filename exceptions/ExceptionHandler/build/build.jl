import PackageCompiler, TOML, Pkg

if length(ARGS) < 1
    target_dir = abspath(joinpath(@__DIR__, "../../compiled"))
else
    target_dir = ARGS[1]
end
println("Creating library in $target_dir")

const build_dir = @__DIR__
const package_dir = joinpath(build_dir, "..")
const project_toml = realpath(joinpath(package_dir, "Project.toml"))
const version = VersionNumber(TOML.parsefile(project_toml)["version"])

PackageCompiler.create_library(
    package_dir, target_dir;
    lib_name="exceptions_from_julia",
    precompile_execution_file=[joinpath(build_dir, "generate_precompile.jl")],
    #precompile_statements_file=[joinpath(build_dir, "additional_precompile.jl")],
    incremental=false,
    filter_stdlibs=true,
    header_files = [joinpath(build_dir, "exceptions_from_julia.h")],
    force=true,
    version=version,
)
