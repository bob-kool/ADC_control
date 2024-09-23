function [IF] = getIF(shot,varargin)
%time   = time  [s]
%ne     = line integrated density [V]

%% Extract data 
% [signal,time] = get_data('/ane/density',shot);
% IF.ne=signal;
[signal,time] = get_data('/xdc/ai/cpu1/density',shot);
IF.ne=signal*1e21; %callibration factor taken from https://users.mastu.ukaea.uk/sites/default/files/uploads/20221104_mastu_science_meeting_intro.pdf
IF.time=time;

%% Add label
IF.label{1} = 'Line integrated density [$\mathrm{m}^{-2}$]';
IF.label{2} = 'Time [s]';
end
