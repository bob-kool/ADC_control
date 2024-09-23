function [fs]=get_fs(signal,valvespec,varargin)
%determine if requested from measured paramter is specified for valve

% new usage: get_fs(signal, settings)
% old usage: get_fs(signal, valvespec, [take_requested_from_measured], [lpspec])
% The old usage is still supported

if nargin == 2 & isa(valvespec, 'struct')
    settings = valvespec;
    take_requested_from_measured = settings.take_requested_from_measured;
    lpspec = settings.LPspec;
else
    if nargin>2
        take_requested_from_measured=varargin{1};
    end
    if nargin>3
        lpspec=varargin{2};
    end
end

try
    shot = parse_shot_specification(settings.shot);
catch
end

%Get sampling frequency for selected signal
switch signal
    case 'DA'
        fs=1e5;
    case 'valve'
        if strcmp(valvespec,'requested')
            fs=1e4;
        elseif strcmp(valvespec,'measured')
            fs=1e5;
        elseif  strcmp(valvespec,'flowrate') || strcmp(valvespec,'flowrate_norm')
            if take_requested_from_measured==1
                fs=1e5;
            elseif take_requested_from_measured==2
                 fs=1e4;
            else
                fs=1e4;
            end
        elseif strcmp(valvespec,'targeted')
            fs=2e3; % 1/2e-5
        elseif strcmp(valvespec,'sysid')
            fs=1e4;
        end
    case 'IF_LA'
        fs=5e4;
    case 'IF'
        fs=5e4;
    case 'IF_norm'
        fs=5e4;
    case 'BOLO'
        fs=1e4;
    case 'FIG'
        fs=5e5;
    case 'RDIintensity'
        fs=400;
    case {'fd','fd_INV'}
        fs=400;
    case 'DMSintensity'
        fs=74.9350;
    case 'fdDMS'
        fs=74.9350;
    case 'UFDS'
        fs=1e5;
    case 'Z'
        fs= 1e6;
    case 'Zref'
        fs = 2e3;
    case 'drsep'
        try
            switch settings.drsep_mode
                case {"VC", "VC_CORRECTED"}
                    fs = 1e6; % same as Z
                case "EFIT"
                    fs = 1e3; % high res efit ran at 1 ms resolution
            end
        catch
            fs = 1e6; % same as Z
        end
    case {"brunner_il","brunner_iu","brunner_ol","brunner_ou"}
        fs=1e6; % same as dRsep (VC_CORRECTED)
    case 'rit'
        fs=443.6557;
        try
            if shot >= 48900
                fs = 1.2771e3; % for 1.1 kHz
            end
        catch
        end
    case 'riv'
        fs=444.2470;
        try
            if shot >= 48900
                fs = 1.2771e3; % for 1.1 kHz
            end
        catch
        end
    case {'ris','ris_lower','ris_upper'}
        fs=165.0710;
    case {'rba_lower','rba_upper'}
        fs = 1e3;
    case {'ait', 'aiv'}
        fs = 400;
        try
            if shot >= 49058
                fs = 1250;
            end
        catch
        end
    case 'LP'
        try
            if contains(lpspec, "vf")
                fs=1/(1e-6);
            else
                fs=1/(1.4e-3);
            end
        catch
            % if lpspec not defined, assume its jsat
            fs=1/(1.4e-3);
        end
        % this is wrong, it seems the step is either 0.0013 or 0.0017, both may
        % be used within the same shot...
    otherwise
        error('Sampling frequency not specified!')
end
end