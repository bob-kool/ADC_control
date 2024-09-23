function [IF_LA] = getIF_LA(shot,varargin)
%time   = time  [s]
%ne     = line averaged density [m3]

%% Extract IF
[IF] = getIF(shot);

%% Extract efit data
rin = get_data('/epm/output/separatrixGeometry/rmidplaneIn',shot);
[rout] = get_data('/epm/output/separatrixGeometry/rmidplaneOut',shot);
[time]  = get_data('/epm/time',shot);

%% Calculate density
pathint = 4 * (rout - rin);
pathlength=interp1(time,pathint,IF.time,'linear','extrap');
IF_LA.ne=IF.ne./pathlength;
IF_LA.time=IF.time;
%% remove NaN values
idx_NaN= isnan(pathlength);
IF_LA.ne(idx_NaN)=[];
IF_LA.time(idx_NaN)=[];
%% Add label
IF_LA.label{1} = 'Line averaged density [$\mathrm{m}^{-3}$]';
IF_LA.label{2} = 'Time [s]';
end
