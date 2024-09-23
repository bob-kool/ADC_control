function [inputlabel,inputunits,outputlabel,outputunits] = getlabels(input,output,settings)
%function that gives labels and units depending on selected input and output

inoutmat=[string(input),string(output)];
for ii=1:2
    inout=inoutmat(ii);
    switch inout
        case 'valve'
            if strcmp(settings.valvespec,'flowrate')
                label = strcat('\mathrm{',strrep(settings.valve,'_','\_'),'}');
                units ='\mathrm{s^{-1}}';
            elseif strcmp(settings.valvespec,'flowrate_norm')
                label = strcat('\mathrm{',strrep(settings.valve,'_','\_'),'}');
                units ='\mathrm{10^{21}s^{-1}}';
            else
                label = strcat('\mathrm{',strrep(settings.valve,'_','\_'),'}');
                units ='\mathrm{V}';
            end
        case 'DA'
            label = strcat('\mathrm{',strrep(settings.scope,'_','\_'),'}');
            units ='\mathrm{V}';
        case 'IF'
            label = 'n_\mathrm{e} \mathrm{\, line\, int.}';
            units = '\mathrm{m}^{-2}';
        case 'IF_LA'
            label = 'n_\mathrm{e} \mathrm{\, line\, av.}';
            units ='\mathrm{m}^{-3}';
        case 'IF_norm'
            label = 'n_\mathrm{e,norm} \mathrm{\, line\, av.}';
            units ='\mathrm{m}^{-2}\cdot 10^{21}';
        case 'fd'
            label = 'L_{\mathrm{pol}}';
            units ='\mathrm{m}';
        case 'fd_INV'
            label = 'L_{\mathrm{pol}} \mathrm{ inv.}';
            units ='\mathrm{m}';
        case 'fdDMS'
            label = 'L_{\mathrm{pol}}\mathrm{DMS}';
            units ='\mathrm{m}';
        case 'FIG'
            label = strcat('\mathrm{FIG}\_\mathrm{',settings.FIGlocation,'}');
            units ='\mathrm{Pa}';
        case 'RDIintensity'
            label = strcat('\mathrm{MWI intens. cam}',num2str(settings.camera));
            units ='\mathrm{-}';
        case 'DMSintensity'
            label = strcat('\mathrm{DMS intens.}');
            units ='\mathrm{-}';
        case 'UFDS'
            label = strcat('\mathrm{UFDS \_',num2str(settings.UFDSfilter),'}');
            units ='\mathrm{V}';
        case 'Z'
            label = '\mathrm{Z\_position}';
            units ='\mathrm{m}';
        case 'Zref'
            label = '\mathrm{Z\_ref}';
            units ='\mathrm{m}';
        case 'rit'
            label = '\mathrm{Lower\_outer\_IR(rit)}';
            units = '\mathrm{-}';
        case 'riv'
            label = '\mathrm{Upper\_outer\_IR(riv)}';
            units = '\mathrm{-}';
        case 'ris_lower'
            label = '\mathrm{Lower\_inner\_IR(ris)}';
            units = '\mathrm{-}';
        case 'ris_upper'
            label = '\mathrm{Lower\_upper\_IR(ris)}';
            units = '\mathrm{-}';
        case 'rba_lower'
            label = '\mathrm{Lower\_inner\_RBA}';
            units = '\mathrm{-}';
        case 'rba_upper'
            label = '\mathrm{Lower\_upper\_RBA}';
            units = '\mathrm{-}';
        case 'ait'
            label = '\mathrm{Lower\_outer\_analysed\_IR}';
            units = '\mathrm{W}';
        case 'aiv'
            label = '\mathrm{Upper\_outer\_analysed\_IR}';
            units = '\mathrm{W}';
        case 'LP'
            label = strcat('\mathrm{LP\_',strrep(settings.LPspec,'_','\_'),'}');
            units = '\mathrm{?}';
        case {'LP_VF_uo','LP_VF_ui','LP_VF_lo'}
            label = "LP VF";
            units = "V";
        case 'drsep'
            label = "\delta R_\mathrm{sep}";
            units = "m";
        case {"brunner_il","brunner_iu","brunner_ol","brunner_ou"}
            label = "brunner";
            units = "AB";
        otherwise
            error('Input/output not recognized!')
    end
    if ii==1
        inputlabel=label;
        inputunits=units;
    else
        outputlabel=label;
        outputunits=units;
    end
end

end