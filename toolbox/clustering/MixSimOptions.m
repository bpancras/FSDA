classdef MixSimOptions
properties
    R_seed (1,1) double =0
    BarOmega (1,1) double =0
    MaxOmega (:,:) double =[]
    StdOmega (:,:) double =[]
    Display (1,:) char ='notify'
    sph (1,1) logical =false
    hom (1,1) logical =false
    ecc (1,1) double =0.9;
    PiLow (1,1) double =false
    int (1,2) double =[0 1]
    resN (1,1) double =100
    tol (1,2) double =[1e-06; 1e-06]
    lim (1,1) double =1e06
    restrfactor (1,1) double =0
end
end