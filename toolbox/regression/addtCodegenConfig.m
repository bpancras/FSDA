cfg = coder.config('dll','ecoder',false);
cfg.CodeFormattingTool = "Clang-format";
cfg.EnableDynamicMemoryAllocation = true;
cfg.GenCodeOnly = true;

codegen -report -config cfg addtCore.m correctData.m

% load("codegen/dll/MixSimCodeGen/buildInfo.mat");
% packNGo(buildInfo,'packType', 'flat', 'fileName', 'MixSimdll')