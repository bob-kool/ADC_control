function [DA] = getDalpha(shot, scopes, varargin)
%u      = Dalpha filterscope voltage [V]
%time   = time  [s]

%Available scopes
% 'PX'      radial lower SXD
% 'HE051R'  radial lower inner strike point
% 'HU10BT'  tangential upper SXD
% 'HL02BT'  tangential lower SXD
% 'HU10BR'  radial upper outer strike point
% 'HL02BR'  radial lower outer strike point
% 'HM10ER'  radial wide-angle midplane
% 'HM10ET'  tangential edge midplane

% for ELM filtering
filter_kwargs = get_filter_kwargs(shot, varargin{:}, elm_dt_start=-0.0007, elm_dt_end=0.003);

%% correct type
scopes=string(scopes);
%% conversion from scope name to UDA adress
    function [adress]=convert_Dalpha_channels(scope)
        if strcmp("HL01SXDR",scope)
            adress="/XIM/DA/HL01/SXD/R";
        elseif strcmp("HL02SXDT",scope)
            adress="/XIM/DA/HL02/SXD";
        elseif strcmp("HL02OSPR",scope)
            adress="/XIM/DA/HL02/OSP";
        elseif strcmp('HM10ER',scope)
            adress="/XIM/DA/HM10/R";
        elseif strcmp('HM10ET',scope)
            adress="/XIM/DA/HM10/T";
        elseif strcmp('HU10OSPR',scope)
            adress="/XIM/DA/HU10/OSP";
        elseif strcmp('HU10SXDT',scope)
            adress="/XIM/DA/HU10/SXD";
        elseif strcmp('HE05ISPR',scope)
            adress="/XIM/DA/HE05/ISP/L";
        else
            error('Scope name is not recognized!')
        end
    end

%% Extract data for each scope if list is specified
if length(scopes)>=1
    for ii=1:length(scopes)
        scope=scopes{ii};
        [adress]=convert_Dalpha_channels(scope);
        [signal,time] = get_data(adress,shot);
        signal = apply_filter(time, signal, filter_kwargs{:}, to="data");
        DA.(scope).u=signal;
        DA.(scope).time=time;
    end
    %% Extract data for specified scope
elseif length(scopes)==1
    [adress]=convert_Dalpha_channels(scopes);
    [signal,time] = get_data(adress,shot);
    signal = apply_filter(time, signal, filter_kwargs{:}, to="data");
    DA.(scopes).u=signal;
    DA.(scopes).time=time;
    %% Give error if datatype is not correct
else
    error('Scope should be char or string for single scope, or cell for multiple scopes')
end
DA.label{1} = 'Dalpha filterscope voltage [V]';
DA.label{2} = 'Time [s]';

end

