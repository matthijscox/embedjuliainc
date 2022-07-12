import PackageCompiler, TOML

if length(ARGS) < 1
    target_dir = realpath(joinpath(@__DIR__, "../../BasicTypesCompiled"))
else
    target_dir = ARGS[1]
end
println("Creating library in $target_dir")

const build_dir = @__DIR__
const project_toml = realpath(joinpath(build_dir, "..", "Project.toml"))
const version = VersionNumber(TOML.parsefile(project_toml)["version"])

PackageCompiler.create_library(
    ".", target_dir;
    lib_name="basic",
    precompile_execution_file=[joinpath(build_dir, "generate_precompile.jl")],
    #precompile_statements_file=[joinpath(build_dir, "additional_precompile.jl")],
    incremental=false,
    filter_stdlibs=true,
    header_files = [joinpath(build_dir, "basic.h")],
    force=true,
    version=version,
)
