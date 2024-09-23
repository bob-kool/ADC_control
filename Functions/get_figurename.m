function [figurename] = get_figurename(Input,Output,shot,settings,data)
%Dalpha
if strcmp(Output,'DA')
    outputname=strcat(Output,'_',settings.scope);
elseif strcmp(Input,'DA')
    inputname=strcat(Input,'_',settings.scope);
end
%Lpol
if strcmp(Output,'fd') || strcmp(Output,'fd_INV') 
    outputname=strcat(Output,'_',settings.specline);
    if settings.referenceshot~=0
        outputname=strcat(outputname,'_ref_',num2str(settings.referenceshot));
    end
elseif strcmp(Input,'fd') || strcmp(Output,'fd_INV')  
    inputname=strcat(Input,'_',settings.specline);
    if settings.referenceshot~=0
        inputname=strcat(inputname,'_ref_',num2str(settings.referenceshot));
    end
end
%Density
if strcmp(Output,'IF')
    outputname='IF';
elseif strcmp(Input,'IF')
    inputname='IF';
end
if strcmp(Output,'IF_LA')
    outputname='IF_LA';
elseif strcmp(Input,'IF_LA')
    inputname='IF_LA';
end
%Valves
if strcmp(Output,'valve')
    outputname=settings.valve;
    if strcmp(settings.valvespec,'measured')
        outputname=strcat(outputname,'_measured');
    elseif strcmp(settings.valvespec,'flowrate')
        outputname=strcat(outputname,'_flowrate');
    end
elseif strcmp(Input,'valve')
    inputname=settings.valve;
    if strcmp(settings.valvespec,'measured')
        inputname=strcat(inputname,'_measured');
    elseif strcmp(settings.valvespec,'flowrate')
        inputname=strcat(inputname,'_flowrate');
    end
end
%FIG
if strcmp(Output,'FIG')
    FIG = getFIG(shot,settings.FIGlocation,'raw');
    outputname=strcat('FIG_',settings.FIGlocation,'_',num2str(FIG.(settings.FIGlocation).c));
elseif strcmp(Input,'FIG')
    inputname=strcat('FIG_',settings.FIGlocation,'_',num2str(FIG.(settings.FIGlocation).c));
end
%RDI intensity
if strcmp(Output,'RDIintensity')
    outputname=strcat('RDIintensityCam',num2str(settings.camera));
elseif strcmp(Input,'FIG')
    inputname=strcat('RDIintensityCam',num2str(settings.camera));
end
%RDI intensity
if strcmp(Output,'DMSintensity')
    outputname=strcat('DMSintensity_',settings.DMSfilter,'_',settings.DMSsystem);
elseif strcmp(Input,'FIG')
    inputname=strcat('DMSintensity_',settings.DMSfilter,'_',settings.DMSsystem);
end
%UFDS
if strcmp(Output,'UFDS')
    outputname=strcat('UFDS_',settings.UFDSfilter);
elseif strcmp(Input,'UFDS')
    inputname=strcat('UFDS_',settings.UFDSfilter);
end
%LP
if strcmp(Output,'LP')
    outputname=strcat('LP_',settings.LPspec);
elseif strcmp(Input,'LP')
    inputname=strcat('LP_',settings.LPspec);
end

%else
if ~exist('inputname','var')
    inputname=Input;
    outputname=Output;
end
if ~exist('outputname','var')
    inputname=Input;
    outputname=Output;
end
figurename=strcat(num2str(shot),'_',inputname,'_to_',outputname);
try
if settings.inversion && (strcmp(Output,'fd')||strcmp(Input,'fd'))
    figurename=strcat(figurename,'_INV');
end
catch
end
end


