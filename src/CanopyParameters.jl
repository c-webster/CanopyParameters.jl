module CanopyParameters

using SpatialFileIO, DelimitedFiles, Statistics

using Conda, PyCall

function __init__()
    @eval global netcdf    = pyimport("netCDF4")
    @eval global np        = pyimport("numpy")
end


include("calc_CP.jl")
include("fileIO.jl")

export
    calc_CanopyCover,
    calc_CP_forFSM,
    calc_CP_forOSHD,
    createfiles_calcCP

end
