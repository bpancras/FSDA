classdef mixsimOptions %#codegen
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here

    properties
        BarOmega(1,:) char
        MaxOmega(1,:) char
        StdOmega(1,:) char
        Display(1,:) char
        restrfactor(1,1) char
        Rseed(1,1) int64
        ecc(1,1) double
        PiLow(1,1) double
        int(1,2) double
        resN(1,1) double
        tol(2,1) double
        lim(1,1) double
        sph(1,1) logical
        hom(1,1) logical
    end
end