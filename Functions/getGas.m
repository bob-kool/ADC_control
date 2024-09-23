function [GV] = getGas(shot,valves,varargin)
% output
% u = reference voltage [V]
% time = time  [s]
% inputs:
%   shot
%   valves = string or char
% varargin =  "name", value
%       'valve_spec'='requested'(default)
%                    'measured',
%                    'targeted'
%                    'drive'
%                    'sysid'
%                    'flowrate'
%                    'flowrate_norm'
%      'calculate_flowrate'
%           0 = (default) try to load requested flowrate 
%           1 = calulcate requested flowrate using 
%      'take_requested_from_measured'
%           0 = (default) directly takes measured voltage 
%           1 = requested from measured
%           2 = requested from sysid
% example:
% getGas(shot,values,'valve_spec','requested','pressure',1500)

% Author: B. Kool and G. Derks, 2023, Eindhoven

%make struct with default parameter which are overwritten lateron
D=struct;
D.valve_spec = 'requested';
D.valve_pressure = 750;
D.take_requested_from_measured = 0;
D.calculate_flowrate = 0;
P = struct();
% Overwriting parameters
for k = 1:2:length(varargin), P.(varargin{k}) = varargin{k+1}; end
for k = fieldnames(D)'
    if ~isfield(P,k{1}), P.(k{1}) = D.(k{1}); end
end
%% correct types
valves=string(valves);
%% Extract data for each valve if list is specified
if length(valves)>=1 % this makes it double everywhere, only do it if you
% want multiple outcomes. 
for ii=1:length(valves)
    valve=valves{ii}; 
    disp(char(strcat({'Loading data for valve'},{' '},{num2str(valve)})))
    if strcmp(P.valve_spec,'requested')
         if P.take_requested_from_measured ==1 %take from measured
            disp('Taking requested voltage from measured voltage')
            gascalibration=get_gascalibration(shot,valve,P.valve_pressure);%load valve callibration
            %recall the function to load measured trace
            [GV_temp] = getGas(shot,valve,'valve_spec','measured');
            signal=GV_temp.(valve).u;
            time=GV_temp.(valve).time;
            signal=measuredvoltage_to_requestedvoltage(signal,gascalibration);
        elseif P.take_requested_from_measured ==2 %take from systemidtrace
            disp('Taking requested voltage from saved systemID trace')
            %recall the function to load systemid datatrace
            [GV_temp] = getGas(shot,valve,'valve_spec','sysid');
            signal=GV_temp.(valve).u;
            time=GV_temp.(valve).time;
         else
             disp('Loading requested voltage')
             [signal,time] = get_data(strcat('xdc/gas/f/',valve),shot);
         end
         GV.label{1} = 'Requested valve voltage [V]';
    elseif strcmp(P.valve_spec,'measured')
        disp('Loading measured voltage')
         GV.label{1} = 'Measured valve voltage [V]';
        [signal,time] = get_data(strcat('/xpc/gas/vout/',valve),shot);
    elseif strcmp(P.valve_spec,'targeted')
        disp('Loading targeted voltage')
        GV.label{1} = 'Targeted valve voltage [V]';
        [signal,time] = get_data(strcat('/xdc/gas/t/',valve),shot);
    elseif strcmp(P.valve_spec,'drive')
        disp('Loading drive voltage')
        GV.label{1} = 'Drive valve voltage [V]';
        [signal,time] =get_data(['/xdc/ao/',valve,'_drive'],shot);
    elseif strcmp(P.valve_spec, 'sysid') % for some case we store raw sysid files
        disp('Loading requested sysID voltage')
        GV.label{1} = 'Requested sysID valve voltage [V]';
        try
        [signal,time] = get_data(strcat('/SystemIDtrace/',valve),shot);
        timeitp=(time(1):1e-4:time(end));%resample to uniform datarate
        signal=interp1(time,signal,timeitp);
        time=timeitp;
        catch
            warning('Requested systemID trace not available')
            signal=NaN;
            time=NaN;
        end
    elseif strcmp(P.valve_spec, 'flowrate_norm') || strcmp(P.valve_spec, 'flowrate') %
        gascalibration=get_gascalibration(shot,valve,P.valve_pressure);%load valve callibration
        if P.calculate_flowrate
            disp('Calultating flowrate, not loading directly!')
            %first get requested voltage
            [GV_temp] = getGas(shot,valve,'valve_spec','requested','take_requested_from_measured',P.take_requested_from_measured);
            signal=GV_temp.(valve).u;
            time=GV_temp.(valve).time;
            %then calculate the flowrate
            disp(char(strcat({'Using plenum pressure of'},{' '},{num2str(P.valve_pressure)})))
            signal = requestedvoltage_to_flowrate(signal,gascalibration);
        else
            %just load flowrate directly
             disp('Loading flowrate directly')
            [signal,time] = get_data(strcat('xdc/gas/f/',valve),shot);
        end
        GV.label{1} = 'Requested flowrate [$\mathrm{s^{-1}}$]';
        if strcmp(P.valve_spec, 'flowrate_norm')
            signal = signal / 1e21;
            GV.label{1} = 'Requested flowrate [$\mathrm{10^{21}s^{-1}}$]';
        end
    end
    GV.(valve).u=signal;
    GV.(valve).time=time;
end
%% Give error if datatype is not correct
else
     error('Valve should be char or string for single valve, or cell for multiple valves')
end

%% Add time label
GV.label{2} = 'Time [s]';
end
