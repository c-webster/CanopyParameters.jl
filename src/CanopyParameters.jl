module CanopyParameters

using SpatialFileIO, DelimitedFiles, Statistics

include("calc_CP.jl")

export
    calc_CP_forFSM,
    calc_CanopyCover

end
