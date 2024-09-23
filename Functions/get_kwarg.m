function value = get_kwarg(key, default_value, args)
%GET_KWARG Apply this to varagin to find a name-value pair, or a default value
% if not specified.
% Params:
%   key: the name of name-value pair
%   default_value: what should be returned if the name-value pair is not found
%   args: typically, varargin. The cell array in which to search for name-value pairs
idx = find(cellfun(@(x) strcmp(key,x), args), 1, "last");
if ~isempty(idx) && idx <= length(args)
    value = args{idx+1};
else
    value = default_value;
end

end