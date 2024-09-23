function [result] = apply_filter(time, data, varargin)
%APPLY_FILTER Apply a filter to a signal, such as ELM filtering
% Parameters:
%   time: time vector
%   data: data vector
%   varargin: options that specify the filter
%
% Return values:
%   result: time/data vector with filtering applied. Only one at the time is
%           returned, to avoid applying the filter multiple times.
%
% NB: varargin should include a keyword argument that specifies whether the
% result is time or data:
%   apply_filter(__, to="time") applies filters to the time vector
%   apply_filter(__, to="data") applies filters to the data vector
%
% NB: This function has no knowledge about the type of data is it working with.
% As such, everything that is signal / diagnostic specific should be specified
% in varargin as kwarg.

result_type = get_kwarg("to","not_specified",varargin);

%% Time correction
if result_type == "time" & get_kwarg("correct_time", false, varargin)
    scaling = get_kwarg("time_scaling", 1, varargin);
    shift = get_kwarg("time_shift", 0, varargin);
    time = time * scaling + shift;
end

%% ELM filtering
if result_type == "data" & get_kwarg("filter_elms",false, varargin)
    elm_dt_start = get_kwarg("elm_dt_start",0, varargin);
    elm_dt_end = get_kwarg("elm_dt_end",0, varargin);
    shot_params = get_kwarg("shot_params",struct,varargin);

    if ~isfield(shot_params, 'elm_times')
        warning("ELM filtering applied to shot without ELM data available - no filtering took place")
    else
        data = remove_elms(time, data, shot_params.elm_times, elm_dt_start, elm_dt_end);
    end
end

switch result_type
case "time"
    result = time;
case "data"
    result = data;
otherwise
    error('You must specify either to="data" or to="time" for apply_filter');
end