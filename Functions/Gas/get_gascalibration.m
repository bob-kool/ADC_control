function [gascallibration] = get_gascalibration(shot,valve,pressure)
%GET_GASCALLIBRATION give gas callibration as function of shot and valve

%F = a*V +b calibrations of the flow rates
%measured_to_requested is the conversion factor determined by comparin
%signals

%NOTE
%The callibrations rescaled to a ficticous 1000mbar plenum pressure and
%then put into PCS. When the SL puts in the actual plenum pressure in the
%interface, the callibration is rescaled to the values given below. So
%there can be only one callibration in PCS at any given time for each
%valve, in some cases we supplied traces for 750 and 1500mbar, it is
%unclear which one was rescaled sometimes
switch valve
    case 'LFSV_BOT_L09'
        if shot >47000 %rough guess
            measured_to_requested=25.6241;
            switch pressure
                case 750
                    % plenum pressure 750 courtesy of B. Kool 2022
                    %                     a = 0.069113;
                    %                     b = -3.058;
                    %as implemented in PCS
                    a=0.0819;
                    b=-2.949;
                case 1510
                    % plenum pressure 1510 courtesy of B. Kool 2022
                    a = 0.11664;
                    b = -3.4838;
            end
        elseif shot >46536
            measured_to_requested=25.6241;
            switch pressure
                case 750
                    % plenum pressure 750 courtesy of B. Kool 2022
                    %                     a = 0.069113;
                    %                     b = -3.058;
                    %as implemented in PCS
                    a=0.0609;
                    b=-2.132;
                case 1510
                    % plenum pressure 1510 courtesy of B. Kool 2022
                    a = 0.11664;
                    b = -3.4838;
            end
        end
    case 'HFS_MID_U02'
        if shot > 47800
            measured_to_requested=25.6241; %??
            switch pressure
                case 750 % MU03
                    a = 0.04909;
                    b = -2.4802;
                case 1500 % MU03
                    a = 0.099939;
                    b = -4.9536;
            end
        end
    case 'LFSD_BOT_L0506'
       measured_to_requested=25.6241; %not sure!
        if shot >= 48865 && shot <48937
            switch pressure
                case 500
                    %as actually implemented in PCS during  48865-48936 to
                    %get around cutoff while running in flowrate mode
                    a = 0.0608;
                    b = -3.0375;
            end
        elseif shot > 47800
            switch pressure
                case Inf
                    warning('using hacked 500mbar callibration without piezo offset')
                    a=0.027;
                    b=0;
                case 500  % MU03
                    %still uncertain!!
                    warning('using 500mbar callibration based on rescaling!')
                    a = 0.04322;
                    b = -2.4297;
                case 750  % MU03
                    a = 0.064831;
                    b = -3.6442;
                case 1500 % MU03
                    a = 0.14156;
                    b = -8.3153;
            end
        end

    case 'LFSD_TOP_U0102'
       measured_to_requested=25.6241; %not sure!
        if shot > 47800
            switch pressure
                case 500  % MU03
                    %still uncertain!!
                    warning('using 500mbar callibration based on rescaling!')
                    a = 0.042401;
                    b = -1.5914;
                case 750  % MU03
                    a = 0.06363;
                    b = -2.3885;
                case 1500 % MU03
                    a = 0.14134;
                    b = -6.8855;
            end
        end
    case 'LFSD_BOT_L0102'
        if shot > 47800
            measured_to_requested=25.6241; %not sure!
            switch pressure
                case 750  % MU03
                    %as given by us to MAST-U
                    % a = 0.07872;
                    % b = -3.1796;
                    %as actually implemented in PCS to get around cutoff
                    a = 0.0757;
                    b = -2.7237;
            end
        end
end
gascallibration.measured_to_requested= measured_to_requested;
gascallibration.a=a;
gascallibration.b=b;
end

