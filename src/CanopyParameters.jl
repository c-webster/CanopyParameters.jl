module CanopyParameters

using SpatialFileIO, DelimitedFiles, Statistics, NCDatasets

include("calc_CP.jl")
include("fileIO.jl")

export
    calc_CanopyCover,
    calc_CP_forFSM,
    calc_CP_forOSHD,
    createfiles_calcCP

end
