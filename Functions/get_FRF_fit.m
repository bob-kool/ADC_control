function [G,varargout] = get_FRF_fit(Output,FitName,settings)
%specify transferfunction G, using flowrate to input 
%we are primairly using the actual inputs, so not normalised! 


%NOTE ON FRACTIONAL FUNCTIONS
%       to use fractional transferfunctions, install the FOMCON toolbox (download and add to path)
%       run "fomcon('config')" and change Internal_computation_accuracy to 1e-30
%       to enable use of the small gains we require. Do not add this to
%       the repo, because of a bug it refuses to save the config file
fconfig=fomcon('config');fconfig.Core.General.Internal_computation_accuracy=1e-30;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
s=tf('s');
switch Output
    case 'DA'
        switch settings.scope
            case 'HL01SXDR'
                gain = 15e-1;
                tau =3e-3*2*pi;
                tau_d = 8*1e-3; %deadtime
                G=gain*(1/(tau*s+1))*(exp(-tau_d*s));
            case 'HM10ET'
                gain = 5e-1;
                tau =2e-3*2*pi;
                tau_d = 1.5*1e-3; %deadtime
                %                 tau =3e-3*2*pi;
                %                 tau_d = 1*1e-3; %deadtime
                G=gain*(1/(tau*s+1))*(exp(-tau_d*s));
        end
    case 'fd_INV' 
        switch FitName
            case 'fd_INV_MU02_LFSV_BOT_L09'
%                as presented in ITPA divsol and as implemented in MU03
%                detachment control design and demonstration
                G=fotf('1','1/2*s^0.7+1',1e-3)*1e-22;
                %toy example for discussion with matthijs
%                 G=fotf('1','1/2*s^0.6+1',2e-3)*0.9e-22;

%             case 'fd_INV_MU03_LFSD_BOT_L0506'
% %                First quess for divertor valve detachment control based on
% %                'fd_INV_MU02_LFSV_BOT_L09'
%                 G=fotf('1','1/2*s^0.7+1',5e-3)*1e-22;

            case 'fd_INV_MU03_LFSD_BOT_L0506'
                %Tuned on Janary 2024 shots, Lmode SXD, 750kA
                %Used in divertor detachment control
                %Using hacked callibration without piezo offset (a =
                %0.0608; b = -3.0375;) at 500mbar
                G=fotf('1','1/2*s^0.7+1',10e-3)*1.3e-22;
        end
    case 'fd'
        switch FitName
            case 'fd_INV_MU02_LFSV_BOT_L09'
%                as presented in ITPA divsol and as implemented in MU03
%                detachment control design and demonstration
                G=fotf('1','1/2*s^0.7+1',1e-3)*1e-22;
                %toy example for discussion with matthijs
%                 G=fotf('1','1/2*s^0.6+1',2e-3)*0.9e-22;

%             case 'fd_INV_MU03_LFSD_BOT_L0506'
% %                First quess for divertor valve detachment control based on
% %                'fd_INV_MU02_LFSV_BOT_L09'
%                 G=fotf('1','1/2*s^0.7+1',5e-3)*1e-22;
            case 'fd_MU03_LFSD_BOT_L0506'
                %Tuned on Janary 2024 shots, Lmode SXD, 750kA
                %Used in divertor detachment control
                %Using hacked callibration without piezo offset (a =
                %0.0608; b = -3.0375;) at 500mbar
                G=fotf('1','1/2*s^0.7+1',10e-3)*1.3e-22;
        end
    case 'FIG'
        gain = 4.5e-2;
        pole = 100*1e-3*2*pi*30;
        deadtime = 8*1e-3; % s
    case 'IF'
        switch FitName
            case 'IF_MU02_LFSV_BOT_L09_DEC22'
                %fit during experiments on two 46647 and 46648 by gijs in document
                gain = 17.14e-3;
                tau = 0.1;
                tau_d = 3*1e-3;
                G=gain*(1/(tau*s+1))*(exp(-tau_d*s));
            case 'IF_MU02_LFSV_BOT_L09'
                %new fit after experiments, using ss gain information from
                %closed-loop, used in ITPAdivsol presentation
                gain = 43e-3;
                tau = 0.2;
                tau_d = 3.5*1e-3;
                G=gain*(1/(tau*s+1))*(exp(-tau_d*s));
            case 'IF_MU03_HFS_MID_U02_11JUL23'
                % fit based on single experiment 4
                gain = 12e-3;
                tau = 0.08;
                tau_d = 13.5*1e-3;
                G=gain*(1/(tau*s+1))*(exp(-tau_d*s));
            case 'IF_MU03_HFS_MID_U02_13JUL23'
                % fit based on single experiment 4
                gain = 153e-3;
                tau = 0.08;
                tau_d = 13.5*1e-3;
                G=gain*(1/(tau*s+1))*(exp(-tau_d*s));

            case 'IF_MU03_LFSD_BOT_U0506_09AUG23'
                % for now similar
                gain = 43e-3;
                tau = 0.2;
                tau_d = 3.5*1e-3;
                G=gain*(1/(tau*s+1))*(exp(-tau_d*s));      
        end
    case 'IF_norm'
        switch FitName
            case 'IF_MU02_LFSV_BOT_L09_DEC22'
                %fit during experiments on two 46647 and 46648 by gijs in document
                gain = 17.14e-3;
                tau = 0.1;
                tau_d = 3*1e-3;
                G=gain*(1/(tau*s+1))*(exp(-tau_d*s));
            case 'IF_norm_MU02_LFSV_BOT_L09'
                %ITPAdivsol presentation fit corrected for normalisation
                %this one is in the density control paper by gijs
                gain = 43e-3;
                tau = 0.2;
                tau_d = 3.5*1e-3;
                G=gain*(1/(tau*s+1))*(exp(-tau_d*s));
            case 'IF_norm_MU03_HFS_MID_U02_13JUL23'
                % fit based on single experiment 4
                gain = 153e-3/10;
                tau = 0.08;
                tau_d = 13.5*1e-3;
                G=gain*(1/(tau*s+1))*(exp(-tau_d*s));
        end
    case 'UFDS'
        switch settings.UFDSfilter
            case 'D32'
                gain = 5e-1;
                tau =2e-3*2*pi;
                tau_d = 1.5*1e-3; %deadtime
                G=gain*(1/(tau*s+1))*(exp(-tau_d*s));
            case 'FB'
                %                 %fit for 47116
                gain = 3e-1;
                tau =1*2*pi;
                tau_d = 29*1e-3; %deadtime
                %fit for 47119
                %                 gain = 13e-4;
                %                 tau =3e-4*2*pi;
                %                 tau_d = 0*1e-3; %deadtime

                G=gain*(1/(tau*s+1))*(exp(-tau_d*s));
        end
    case 'MIMO'
        switch FitName
            case 'test'
                %naming convention: G_output_input
                
                %get divertor valve transferfunction
                Output='fd'; 
                FitName = 'fd_MU03_LFSD_BOT_L0506';
                [G_BD] = get_FRF_fit(Output,FitName,settings);
                G_TD=G_BD;

                %get core valve transferfunctions
                Output='IF_norm';
                FitName = 'IF_norm_MU02_LFSV_BOT_L09';
                [G_CC] = get_FRF_fit(Output,FitName,settings);
                Output='fd_INV'; 
                FitName = 'fd_INV_MU02_LFSV_BOT_L09';
                [G_BC] = get_FRF_fit(Output,FitName,settings);
                G_TC=G_BC;

                %actual transferfunction, from actual flowrate to actual
                %density and actual lpol
                G=[G_TD,G_TC,fotf(0);fotf(0),G_CC,fotf(0);fotf(0),G_BC,G_BD]; 
                %nomralised transferfunction, from normalised flowrate to
                %normalised density and actual lpol
                G_norm=[G_TD*1e21,G_TC*1e21,fotf(0);fotf(0),G_CC,fotf(0);fotf(0),G_BC*1e21,G_BD*1e21];

        end
        if nargout==2
            varargout{1}=G_norm;
        end

end
end

