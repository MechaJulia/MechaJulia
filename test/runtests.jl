using Base.Test
import JSON

include("../src/MechaJulia.jl")

#######################################################################
pr_file_json_str = """[{"sha":"e69de29bb2d1d6434b8b29ae775ad8c2e48c5391","filename":"GLPK/versions/0.0.0/sha1","status":"added","additions":0,"deletions":0,"changes":0,"blob_url":"https://github.com/IainNZ/METADATA.jl/blob/e4489b9c90d0860c8d76e54030f1876c38284d51/GLPK/versions/0.0.0/sha1","raw_url":"https://github.com/IainNZ/METADATA.jl/raw/e4489b9c90d0860c8d76e54030f1876c38284d51/GLPK/versions/0.0.0/sha1","contents_url":"https://api.github.com/repos/IainNZ/METADATA.jl/contents/GLPK/versions/0.0.0/sha1?ref=e4489b9c90d0860c8d76e54030f1876c38284d51"}]"""
@test MechaJulia.is_there_ver000(JSON.parse(pr_file_json_str))