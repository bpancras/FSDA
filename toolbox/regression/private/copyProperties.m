% function options =  createOptions(type, optName)
% options = eval(optName);
% options = copyProperties(args, options);
% end

function obj = copyProperties(argStruct, obj)
mFields = fields(argStruct);
if ~isempty(mFields)

    for idx = 1:numel(mFields)
        obj.(mFields{idx}) = argStruct.(mFields{idx}); 
    end
end
end