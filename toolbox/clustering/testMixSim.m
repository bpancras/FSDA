options= mixsimOptions;
options.Rseed = 0;
% options.BarOmega = "";
% options.MaxOmega = "";
% options.StdOmega = "";
% options.restrfactor="";
options.ecc      = 0.9;
options.PiLow    = 0;
options.int      = [0 1];
options.resN     = 100;
options.tol      = [1e-06; 1e-06];
options.lim      = 1e06;
options.Display  = 'notify';
options.hom      = false;
options.sph      = false;

out  = MixSim(3,4,options);