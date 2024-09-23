function params = get_shot_params(shot)
%GET_SHOT_PARAMS Retrieves parameters for shot from shot_index.yaml
    shot_index = yaml.loadFile("shot_index.yaml","ConvertToArray", true);
    index_fieldname = strcat("s",string(shot));

    % start with defaults
    params = shot_index.default;

    %edge case: if no defaults available, make params an empty struct
    if isa(params, 'yaml.Null')
        params = struct;
    end

    % check if a spot specification is available at all
    if ~isfield(shot_index, index_fieldname)
        % emit a warning if it isn't, might by a type
        warning(strcat("#",num2str(shot), " has no specification in shot_index.yaml, falling back to defaults."))
    else
        % replace default values with specified values, if available
        for fieldname = each_field(shot_index.(index_fieldname))
            params.(fieldname) = shot_index.(index_fieldname).(fieldname);
        end
    end

end

