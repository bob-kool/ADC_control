function kwargs = get_filter_kwargs(shot, varargin)
%GET_FILTER_KWARGS Get a cell array that can be passed to apply_filter().

shot_params = get_shot_params(shot);
kwargs = [varargin, {"shot_params", shot_params}];

if get_kwarg("correct_time", false, varargin)
    correction_key = get_kwarg("time_correction_key", "", varargin);
    if correction_key ~= ""
        shift = shot_params.(correction_key).shift;
        scaling = shot_params.(correction_key).scaling;
        kwargs = [kwargs, {"time_shift", shift, "time_scaling", scaling}];
    end
end

end