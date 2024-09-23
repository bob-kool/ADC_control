function [f_0,f_exc,t1,P,settings] = get_frfpars_mastu(shot,Input,Output,settings)
%stored sysid settings for each shot
%f_exc = excited frequencies
%P     = number of periods
%t1    = start of sysid
%t1 and P are chosen to maximize results within the experiment
%
%signal = ['fd','DA','IF','IF_LA','intens','Ts_T']
%%%%%%%%%%%%%%%%%%%%%%%%
%b.kool@differ.nl

% Parse <shot>, as it may contain subshot specifications (e.g. "48468a")
[shot, subshot] = parse_shot_specification(shot);

%Switch which signal is dominant in  selection
if strcmp(Input,'Ts_T') || strcmp(Output,'Ts_T')
    signal = 'Ts_T';
else
    signal = Output;
end


%IF and IF_norm require the same settings
if strcmp(signal,'IF_norm')
    signal='IF';
end
%Shot Settings
switch shot
    %%%%%%% EXH-013 week 39 2021 %%%%%%%
    case {45069} %CD
        f_exc = 15.3846*[1]; %ramped sine!
        switch signal
            case 'fd'

            case 'DA'

            case 'IF_LA'

        end
        %%%%%%% EXH-013 week 41 2021 %%%%%%%
    case {45239} %SXD
        f_exc = 11.7647*[1,3,5];
        f_0=f_exc(1);
        switch signal
            case 'fd'
                P = 3;      t1 = 0.458;
                %                 P = 4;      t1 = 0.45; %for inverted data
            case 'DA'
                if strcmp(settings.scope,'HM10ET')
                    P = 3;      t1 = 0.54;
                elseif strcmp(settings.scope,'HM10ER')
                    P = 3;      t1 = 0.54;
                elseif strcmp(settings.scope,'HL02OSPR')
                    P = 3;      t1 = 0.5;
                elseif strcmp(settings.scope,'HL02BT')
                    P = 3;      t1 = 0.52;
                elseif strcmp(settings.scope,'HE05ISPR')
                    P = 3;      t1 = 0.52;
                end
            case 'IF_LA'
                P = 3;      t1 = 0.49;
        end
    case {45240} %CD
        f_exc = 11.7647*[1,3,5];
        f_0=f_exc(1);
        switch signal
            case 'fd'

            case 'DA'
                if strcmp(settings.scope,'HM10ER')
                    P = 3;      t1 = 0.52;
                elseif strcmp(settings.scope,'HM10ET')
                    P = 4;      t1 = 0.52;
                elseif strcmp(settings.scope,'HE05ISPR')
                    P = 4;      t1 = 0.52;
                end
            case 'IF_LA'
                P = 4;      t1 = 0.5;

        end
    case {45246} %SXD
        f_exc = 11.7647*[1,3,5];
        f_0=f_exc(1);
        switch signal
            case 'fd'
                if strcmp(settings.fdspec,'FB')
                    P = 3;      t1 = 0.49;
                    %                       P = 4;      t1 = 0.45; %for inverted data
                else
                    P = 3;      t1 = 0.5;
                end
            case 'IF_LA'
                P = 3;      t1 = 0.53;
            case 'IF'
                P = 3;      t1 = 0.55;
            case 'DA'
                if strcmp(settings.scope,'HM10ET')
                    P = 4;      t1 = 0.5;
                elseif strcmp(settings.scope,'HM10ER')
                    P = 3;      t1 = 0.52;
                elseif strcmp(settings.scope,'HL02BT')
                    P = 3;      t1 = 0.5;
                elseif strcmp(settings.scope,'HL02OSPR')
                    P = 3;      t1 = 0.5;
                elseif strcmp(settings.scope,'HE05ISPR')
                    P = 4;      t1 = 0.43;
                end
        end
        %%%%%%% EXH-013 week 42 2021 %%%%%%%
    case {45373} %CD
        f_exc = 11.7647*[1,3,5];
        f_0=f_exc(1);
        %         f_exc = 11.7647*[1,3];%last frequency no visible, too low base voltage
        switch signal
            case 'fd'
                P = 3;      t1 = 0.56;
            case 'DA'

                if strcmp(settings.scope,'HM10ET')
                    P = 4;      t1 = 0.5;
                elseif strcmp(settings.scope,'HM10ER')
                    P = 4;      t1 = 0.5;
                elseif strcmp(settings.scope,'HL02BT')
                    P = 4;      t1 = 0.5;
                elseif strcmp(settings.scope,'HL02OSPR')
                    P = 4;      t1 = 0.1;
                elseif strcmp(settings.scope,'HE05ISPR')
                    P = 4;      t1 = 0.5;
                end
            case 'IF_LA'
                P = 4;      t1 = 0.5;

        end
    case {45382} %CD
        %         f_exc = 10*[1,3,5];
        f_exc = 10*[1,3];%last frequency has 50Hz grid interference
        f_0=f_exc(1);
        switch signal
            case 'fd'

                if strcmp(settings.fdspec,'CIII')
                    P = 3;      t1 = 0.45;
                elseif strcmp(settings.fdspec,'D32')
                    P = 3;      t1 = 0.49;
                end
            case 'DA'
                f_exc = 10*[1,3];%last frequency has 50Hz grid interference

                if strcmp(settings.scope,'HM10ET')
                    P = 4;      t1 = 0.45;
                elseif strcmp(settings.scope,'HM10ER')
                    P = 4;      t1 = 0.45;
                elseif strcmp(settings.scope,'HE05ISPR')
                    P = 3;      t1 = 0.45;
                end
            case 'IF_LA'
                P = 4;      t1 = 0.45;
        end
        %%%%%%% RT-013 week 42 2021 %%%%%%%
    case {45391} %SXD
        f_exc = 11.7647*[1,3,5];
        switch signal
            case 'fd'
                if strcmp(settings.fdspec,'FB')
                    P = 3;      t1 = 0.46;
                elseif strcmp(settings.fdspec,'D62')
                    P = 3;      t1 = 0.52;
                elseif strcmp(settings.fdspec,'D32')
                    P = 3;      t1 = 0.57;
                end

            case 'DA'
                if strcmp(settings.scope,'HM10ET')
                    P = 3;      t1 = 0.55;
                elseif strcmp(settings.scope,'HL02BT')
                    P = 3;      t1 = 0.59;
                end

            case 'IF_LA'
                P = 4;      t1 = 0.5;

        end
    case {45398} %SXD
        f_exc = 10*[1,3,5];
        switch signal
            case 'fd'
                if strcmp(settings.fdspec,'FB')
                    P = 3;      t1 = 0.46;
                elseif strcmp(settings.fdspec,'CIII')
                    P = 3;      t1 = 0.52;
                elseif  strcmp(settings.fdspec,'D62') || strcmp(settings.fdspec,'D32')
                    P = 3;      t1 = 0.55;
                end
            case 'DA'
                P = 3;      t1 = 0.5;
            case 'IF_LA'
                P = 3;      t1 = 0.53;
        end
    case {45400} %SXD
        f_exc =  7.6923*[1,3,5];
        switch signal
            case 'fd'
                P = 3;      t1 = 0.45;
            case 'DA'
                P = 3;      t1 = 0.45;
            case 'Ts_T'
                P = 2;      t1 = 0.43;
            case 'IF_LA'
                P = 3;      t1 = 0.47;
        end
        %%%%%%% RT22-05 week 49 2022 %%%%%%%
    case {46643}
        P = 1; Amp = 1; f_exc = [3,5]; T_exp = 0.15; %This is not compatible with LPM!!!
        f_exc=f_exc.*1./T_exp;
        f_0=f_exc(1)/3;
        switch signal
            case 'DA'
                if strcmp(settings.scope,'HM10ET')
                    t1=0.42; P=3;
                end
        end

    case {46644}
        f_exc = [3]; T_exp = 0.15;
        f_exc=f_exc.*1./T_exp;
        f_0=f_exc(1)/3;
        switch signal
            case 'DA'
                if strcmp(settings.scope,'HM10ER')
                    t1=0.42; P=7;
                elseif strcmp(settings.scope,'HM10ET')
                    t1=0.42; P=7;
                elseif strcmp(settings.scope,"HL01SXDR" )
                    t1=0.42; P=5;
                elseif strcmp(settings.scope,'HL02SXDT')
                    t1=0.48; P=5;
                elseif strcmp(settings.scope, "HL02OSPR")
                    t1=0.42; P=5;
                elseif strcmp(settings.scope, "HU10OSPR")%this one saturates!
                    t1=0.42; P=5;
                elseif strcmp(settings.scope, "HU10SXDT")
                    t1=0.42; P=5;
                elseif strcmp(settings.scope, "HE05ISPR")
                    t1=0.42; P=5;
                end
            case 'IF_LA'
                t1=0.40; P=4;
            case 'FIG'
                t1=0.42; P=7;
            case 'RDIintensity'
                if settings.camera==7
                    t1=0.51; P=3;
                elseif settings.camera==5
                    t1=0.45; P=3;
                end
            case 'DMSintensity'
                t1=0.45; P=3;
        end

    case {46646}
        f_exc = [3]; T_exp = 0.38;
        f_exc=f_exc.*1./T_exp;
        f_0=f_exc(1)/3;
        switch signal
            case 'DA'
                if strcmp(settings.scope,'HM10ER')
                    t1=0.42; P=3;
                elseif strcmp(settings.scope,'HM10ET')
                    t1=0.42; P=3;
                elseif strcmp(settings.scope,"HL01SXDR" )
                    t1=0.42; P=3;
                elseif strcmp(settings.scope,'HL02SXDT')%this one saturates!
                    t1=0.42; P=3;
                elseif strcmp(settings.scope, "HL02OSPR")
                    t1=0.42; P=3;
                elseif strcmp(settings.scope, "HU10OSPR")%this one saturates!
                    t1=0.42; P=3;
                elseif strcmp(settings.scope, "HU10SXDT")
                    t1=0.46; P=3;
                elseif strcmp(settings.scope, "HE05ISPR")
                    t1=0.46; P=2;
                end
            case 'IF_LA'
                t1=0.57; P=2;
            case 'FIG'
                t1=0.42; P=3;
            case 'RDIintensity'
                if settings.camera==7
                    t1=0.43; P=3;
                elseif settings.camera==5
                    t1=0.45; P=3;
                end
            case 'DMSintensity'
                t1=0.43; P=3;
        end

    case {46647}
        f_exc = [3]; T_exp = 0.38;
        f_exc=f_exc.*1./T_exp;
        f_0=f_exc(1)/3;
        switch signal
            case 'DA'
                if strcmp(settings.scope,'HM10ER')
                    t1=0.42; P=4;
                elseif strcmp(settings.scope,'HM10ET')
                    t1=0.42; P=4;
                elseif strcmp(settings.scope,"HL01SXDR")%this one saturates!
                    t1=0.1; P=4;
                elseif strcmp(settings.scope,'HL02SXDT')
                    t1=0.42; P=4;
                elseif strcmp(settings.scope, "HL02OSPR")
                    t1=0.42; P=4;
                elseif strcmp(settings.scope, "HU10OSPR")%this one saturates!
                    t1=0.1; P=4;
                elseif strcmp(settings.scope, "HU10SXDT")
                    t1=0.42; P=4;
                elseif strcmp(settings.scope, "HE05ISPR")
                    t1=0.42; P=4;
                end
            case {'IF_LA','IF','IF_norm'}
                t1=0.36; P=4;
            case 'FIG'
                t1=0.42; P=4;
            case 'RDIintensity'
                if settings.camera==7
                    t1=0.65; P=2;
                elseif settings.camera==5
                    t1=0.5; P=3;
                end
            case 'DMSintensity'
                if strcmp(settings.DMSsystem,'3mid')
                    t1=0.38; P=4;
                elseif strcmp(settings.DMSsystem,'3btm')
                    t1=0.54; P=3;
                end
            case 'fdDMS'
                t1=0.38; P=4;
        end
    case {46648}
        f_exc = [3]; T_exp = 0.15;
        f_exc=f_exc.*1./T_exp;
        f_0=f_exc(1)/3;
        switch signal
            case 'DA'
                if strcmp(settings.scope,'HM10ER')
                    t1=0.39; P=4;
                elseif strcmp(settings.scope,'HM10ET')
                    t1=0.39; P=4;
                elseif strcmp(settings.scope,"HL01SXDR")%this one saturates!
                    t1=0.39; P=4;
                elseif strcmp(settings.scope,'HL02SXDT')
                    t1=0.39; P=4;
                elseif strcmp(settings.scope, "HL02OSPR")
                    t1=0.39; P=4;
                elseif strcmp(settings.scope, "HU10OSPR")%this one saturates!
                    t1=0.1; P=4;
                elseif strcmp(settings.scope, "HU10SXDT")
                    t1=0.39; P=4;
                elseif strcmp(settings.scope, "HE05ISPR")
                    t1=0.39; P=4;
                end
            case {'IF_LA','IF'}
                t1=0.37; P=5;
            case 'FIG'
                t1=0.39; P=4;
            case 'RDIintensity'
                if settings.camera==7
                    t1=0.39; P=4;
                elseif settings.camera==5
                    t1=0.35; P=4;
                end
            case 'DMSintensity'
                t1=0.35; P=3;
        end
    case {46649}
        f_exc = [3]; T_exp = 0.15;
        f_exc=f_exc.*1./T_exp;
        f_0=f_exc(1)/3;
        switch signal
            case 'DA'
                if strcmp(settings.scope,'HM10ER')
                    t1=0.39; P=4;
                elseif strcmp(settings.scope,'HM10ET')
                    t1=0.39; P=4;
                elseif strcmp(settings.scope,"HL01SXDR")%this one saturates!
                    t1=0.1; P=4;
                elseif strcmp(settings.scope,'HL02SXDT')
                    t1=0.39; P=4;
                elseif strcmp(settings.scope, "HL02OSPR")
                    t1=0.39; P=4;
                elseif strcmp(settings.scope, "HU10OSPR")%this one saturates!
                    t1=0.1; P=4;
                elseif strcmp(settings.scope, "HU10SXDT")
                    t1=0.39; P=4;
                elseif strcmp(settings.scope, "HE05ISPR")
                    t1=0.34; P=4;
                end
            case 'IF_LA'
                t1=0.43; P=2;
            case 'FIG'
                t1=0.39; P=4;
            case 'RDIintensity'
                if settings.camera==7
                    t1=0.39; P=3;
                elseif settings.camera==5
                    t1=0.39; P=3;
                end
            case 'DMSintensity'
                t1=0.43; P=3;
        end
    case {46650}
        %         P = 1; Amp = 1; f_exc = [3]; T_exp = 0.15;
        %         f_exc =  7.6923*[1,3,5];
        %         f_exc=f_exc.*1./T_exp;
        %         switch signal
        %             case 'DA'
        %                 if strcmp(settings.scope,'HM10ET')
        %                     t1=0.36; realP = 5;
        %                 end
        %             case 'IF_LA'
        %                 t1=0.36; realP = 5;
        %         end
    case {46666}
        f_exc = [3,6]; T_exp = 0.24;
        f_exc=f_exc.*1./T_exp;
        f_0=f_exc(1);
        switch signal
            case 'DA'
                if strcmp(settings.scope,'HM10ER')
                    t1=0.36; P = 7 ;
                elseif strcmp(settings.scope,'HM10ET')
                    t1=0.36; P = 7 ;
                elseif strcmp(settings.scope,"HL01SXDR")%this one saturates!
                    t1=0.42; P = 5 ;
                elseif strcmp(settings.scope,'HL02SXDT')
                    t1=0.42; P = 5 ;
                elseif strcmp(settings.scope, "HL02OSPR")
                    t1=0.36; P = 7 ;
                elseif strcmp(settings.scope, "HU10OSPR")%this one saturates!
                    t1=0.36; P = 7 ;
                elseif strcmp(settings.scope, "HU10SXDT")
                    t1=0.6; P = 4 ;
                elseif strcmp(settings.scope, "HE05ISPR")
                    t1=0.36; P = 7 ;
                end
            case 'IF_LA'
                t1=0.58; P = 5 ;
            case 'FIG'
                t1=0.36; P = 7 ;
            case 'RDIintensity'
                if settings.camera==7
                    t1=0.67; P=3;
                elseif settings.camera==5
                    t1=0.36; P=7;
                elseif settings.camera==9
                    t1=0.67; P=3;
                end
            case 'fd'
                t1=0.5; P=3;
        end
    case {46670}%LFSD modulation
        f_exc = [3]; T_exp = 0.25;
        f_exc=f_exc.*1./T_exp;
        f_0=f_exc(1)/3;
        switch signal
            case 'DA'
                if strcmp(settings.scope,'HM10ET')
                    t1=0.36; P = 7 ;
                end
            case 'IF_LA'
                t1=0.4; P = 3 ;
        end
    case {46671}%LFSD modulation
        f_exc = [3]; T_exp = 0.25;
        f_exc=f_exc.*1./T_exp;
        f_0=f_exc(1)/3;
        switch signal
            case 'DA'
                if strcmp(settings.scope,'HM10ET')
                    t1=0.36; P = 7 ;
                end
            case 'IF_LA'
                t1=0.4; P = 3 ;
            case 'FIG'
                t1=0.36; P = 7 ;
        end
    case {46672}
        f_exc = [3,6]; T_exp = 0.24;
        f_exc=f_exc.*1./T_exp;
        f_0=f_exc(1);
        switch signal
            case 'DA'
                if strcmp(settings.scope,'HM10ER')
                    t1=0.36; P = 7 ;
                elseif strcmp(settings.scope,'HM10ET')
                    t1=0.36; P = 7 ;
                elseif strcmp(settings.scope,"HL01SXDR")
                    t1=0.6; P = 3 ;
                elseif strcmp(settings.scope,'HL02SXDT')
                    t1=0.5; P = 5 ;
                elseif strcmp(settings.scope, "HL02OSPR")
                    t1=0.1; P = 3 ;
                elseif strcmp(settings.scope, "HU10OSPR")%this one saturates!
                    t1=0.36; P = 7 ;
                elseif strcmp(settings.scope, "HU10SXDT")
                    t1=0.6; P = 4 ;
                elseif strcmp(settings.scope, "HE05ISPR")
                    t1=0.6; P = 4 ;
                end
            case 'IF_LA'
                t1=0.62; P = 4 ;
            case 'BOLO'
                t1=0.62; P = 4 ;
            case 'FIG'
                t1=0.36; P = 4 ;
            case 'RDIintensity'
                if settings.camera==7
                    t1=0.67; P=3;
                elseif settings.camera==5
                    t1=0.47; P=6;
                end
            case 'DMSintensity'
                if strcmp(settings.DMSsystem,'3mid')
                    t1=0.36; P = 7 ;
                end
            case 'fdDMS'
                t1=0.47; P=5;

            case 'fd'
                t1=0.59; P=4;
        end
        %%% RT22-05 session II
    case {47080}
        f_exc = 7.692308*[1,2]; T_exp = 0.4;
        f_0=f_exc(1);
        switch signal
            case 'fd'
                t1=0.44; P=3;
                settings.fdcut=1; %cut fd to prevent anomolies from messing up FFT
                settings.fdmin=0.24;
                settings.fdmax=1;
            case 'fd_INV'
                t1=0.43; P=3;

                settings.fdcut=0; %cut fd to prevent anomolies from messing up FFT
                settings.fdmin=0.24;
                settings.fdmax=0;
            case 'DA'
                if strcmp(settings.scope,'HM10ET')
                    t1=0.36; P = 4 ;
                elseif strcmp(settings.scope,'HL01SXDR')
                    t1=0.48; P = 3 ;
                     elseif strcmp(settings.scope,'HL02SXDT')
                    t1=0.48; P = 3 ;
                end
            case {'IF_LA', 'IF'}
                t1=0.4; P = 4 ;
            case 'RDIintensity'
                if settings.camera==9
                    t1=0.43; P=6;
                elseif settings.camera==7
                    t1=0.42; P=3;
                end
        end
    case {47083}
        f_exc = 10.526316*[1,2]; T_exp = 0.3;
        f_0=f_exc(1);
        switch signal
            case 'fd'
                t1=0.48; P=4;
                if strcmp(settings.fdspec,'FB_50')
                    settings.fdcut=1; %cut fd to prevent anomolies from messing up FFT
                    settings.fdmin=0.04;
                    settings.fdmax=1;
                elseif strcmp(settings.fdspec,'FB_50_fix')
                    settings.fdcut=1; %cut fd to prevent anomolies from messing up FFT
                    settings.fdmin=0.16;
                    settings.fdmax=1;
                end
            case 'fd_INV'
                t1=0.41; P=4;
                if strcmp(settings.fdspec,'FB_50')
                    settings.fdcut=0; %cut fd to prevent anomolies from messing up FFT
                    settings.fdmin=0.04;
                    settings.fdmax=1;
                elseif strcmp(settings.fdspec,'FB_50_fix')
                    settings.fdcut=1; %cut fd to prevent anomolies from messing up FFT
                    settings.fdmin=0.16;
                    settings.fdmax=1;
                end
            case 'DA'
                if strcmp(settings.scope,'HM10ET')
                    t1=0.36; P = 6 ;
                elseif strcmp(settings.scope,'HL01SXDR')
                    t1=0.42; P = 5 ;
                       elseif strcmp(settings.scope,'HL02SXDT')
                    t1=0.42; P = 5 ;
                end
            case {'IF_LA', 'IF'}
                t1=0.44; P = 5 ;
            case 'RDIintensity'
                if settings.camera==9
                    t1=0.43; P=6;
                elseif settings.camera==7
                    t1=0.42; P=4;
                end
        end

    case {47086}
        f_exc = 8.695652*[1]; T_exp = 0.35;
        f_0=f_exc(1);
        switch signal
            case 'fd'
                t1=0.53; P=3;
                if strcmp(settings.fdspec,'FB_50')
                    settings.fdcut=0; %cut fd to prevent anomolies from messing up FFT
                elseif strcmp(settings.fdspec,'FB_50_fix')
                    settings.fdcut=0; %cut fd to prevent anomolies from messing up FFT
                end
            case 'fd_INV'
                t1=0.53; P=3;
                if strcmp(settings.fdspec,'FB_50')
                     settings.fdcut=1; %discarding target emission here, reason being this is not form ionisation but due to increased molecular density which gives this emission. So the ionsiation front itself is not attached here, it has a peak which is the actual front and the target emission
                    settings.fdmin=0.09;
                    settings.fdmax=1;
                elseif strcmp(settings.fdspec,'FB_50_fix')
                    settings.fdcut=0; %cut fd to prevent anomolies from messing up FFT
                end
            case 'DA'
                if strcmp(settings.scope,'HM10ET')
                    t1=0.36; P = 4 ;
                elseif strcmp(settings.scope,'HL01SXDR')
                    t1=0.44; P = 4 ;
                       elseif strcmp(settings.scope,'HL02SXDT')
                    t1=0.44; P = 4 ;
                end
            case {'IF_LA', 'IF'}
                t1=0.48; P = 4 ;
            case 'RDIintensity'
                if settings.camera==9
                    t1=0.67; P=3;
                elseif settings.camera==7
                    t1=0.52; P=3;
                end
        end

    case {47116}
        f_exc = 8.695652*[1]; T_exp = 0.35;
%         f_exc = 8.695652*[1,2,3,4]; T_exp = 0.35;
        f_0=f_exc(1);
        switch signal
            case 'fd'
                t1=0.42; P=4;
                if strcmp(settings.fdspec,'FB_50')
                    settings.fdcut=1; %cut fd to prevent anomolies from messing up FFT
                    settings.fdmin=0.45;
                    settings.fdmax=1;
                elseif strcmp(settings.fdspec,'FB_50_fix')
                    settings.fdcut=1; %cut fd to prevent anomolies from messing up FFT
                    settings.fdmin=0.45;
                    settings.fdmax=1;
                end
            case 'fd_INV'
                 t1=0.42; P=4;
                if strcmp(settings.fdspec,'FB_50')
                    settings.fdcut=1; %cut fd to prevent anomolies from messing up FFT
                    settings.fdmin=0.40;
                    settings.fdmax=1;
                elseif strcmp(settings.fdspec,'FB_50_fix')
                    settings.fdcut=1; %cut fd to prevent anomolies from messing up FFT
                    settings.fdmin=0.45;
                    settings.fdmax=1;
                end
            case {'UFDS'}
                t1=0.43; P=4;
            case 'DA'
                if strcmp(settings.scope,'HM10ET')
                    t1=0.4; P=5;
                elseif strcmp(settings.scope,'HL01SXDR')
                    t1=0.43; P=4;
                      elseif strcmp(settings.scope,'HL02SXDT')
                    t1=0.44; P=3;
                end
            case 'FIG'
                if strcmp(settings.FIGlocation,"HM12")
                    t1=0.44; P=4;
                elseif strcmp(settings.FIGlocation,"HL11")
                    t1=0.46; P=4;
                end
            case {'IF_LA', 'IF'}
                t1=0.48; P = 4 ;
            case 'RDIintensity'
                if settings.camera==9
                    t1=0.41; P=4;
                elseif settings.camera==7
                    t1=0.52; P=3;
                end
        end

    case {47118}
        f_exc = 8.695652*[1,3]; T_exp = 0.35;
        %    f_exc = 8.695652*[1,2,3,4]; T_exp = 0.35;
        f_0=f_exc(1);
        switch signal
            case 'fd'
                t1=0.42; P=4;
                if strcmp(settings.fdspec,'FB_50')
                    settings.fdcut=0; %cut fd to prevent anomolies from messing up FFT
                    settings.fdmin=0.48;
                    settings.fdmax=1;
                elseif strcmp(settings.fdspec,'FB_50_fix')
                    settings.fdcut=1; %cut fd to prevent anomolies from messing up FFT
                    settings.fdmin=0.48;
                    settings.fdmax=1;
                end

            case {'fd_INV','valve'}
                %This shot is the highest of the SXD shots, and the front
                %location goes down over time. So it is most effected by
                %the tracking algorithm limits, this might be an argument
                %to discard the first period an only use the later 2 or 3.
                %This then also removes the increase in phase over
                %frequency.

                %However, we could also be looking at a non-linear
                %contribution here, altough that seems unlikely as we are
                %skipping the second harmonic

                t1=0.52; P=3;
                if strcmp(settings.fdspec,'FB_50')
                    settings.fdcut=0; %cut fd to prevent anomolies from messing up FFT
                elseif strcmp(settings.fdspec,'FB_50_fix')
                    settings.fdcut=0; %cut fd to prevent anomolies from messing up FFT
                end
            case {'UFDS'}
                t1=0.43; P=4;
            case 'DA'
                if strcmp(settings.scope,'HM10ET')
                    t1=0.4; P=5;
                elseif strcmp(settings.scope,'HL01SXDR')
                    t1=0.43; P=4;
                elseif strcmp(settings.scope,'HL02SXDT')
                    t1=0.43; P=4;
                elseif strcmp(settings.scope,'HL02OSPR')
                    t1=0.52; P=3;
                end
            case 'FIG'
                if strcmp(settings.FIGlocation,"HM12")
                    t1=0.44; P=4;
                elseif strcmp(settings.FIGlocation,"HL11")
                    t1=0.43; P=4;
                end
            case {'IF_LA', 'IF'}
                t1=0.47; P = 4 ;
            case 'RDIintensity'
                if settings.camera==9
                    t1=0.44; P=4;
                elseif settings.camera==7
                    t1=0.52; P=3;
                end
        end
    case {47119}
        f_exc=38.461538;
        f_0=f_exc(1);
        switch signal
            case {'fd'}
                t1=0.42; P=15;
                if strcmp(settings.fdspec,'FB_50')
                    settings.fdcut=0; %cut fd to prevent anomolies from messing up FFT
                elseif strcmp(settings.fdspec,'FB_50_fix')
                    settings.fdcut=0; %cut fd to prevent anomolies from messing up FFT
                end
            case {'fd_INV'}
                t1=0.45;
                P=13;
                %                 t1=0.45124;
                if strcmp(settings.fdspec,'FB_50')
                    settings.fdcut=0; %cut fd to prevent anomolies from messing up FFT
                elseif strcmp(settings.fdspec,'FB_50_fix')
                    settings.fdcut=0; %cut fd to prevent anomolies from messing up FFT
                end
            case {'UFDS'}
                %                 t1=0.41; P=15;
                t1=0.5; P=10;
            case 'DA'
                if strcmp(settings.scope,'HM10ET')
                    t1=0.4; P=15;
                elseif strcmp(settings.scope,'HL01SXDR')
                    t1=0.43; P=12;
                elseif strcmp(settings.scope,'HL02SXDT')
                    t1=0.43; P=12;
                end
            case 'FIG'
                if strcmp(settings.FIGlocation,"HM12")
                    t1=0.42; P=14;
                elseif strcmp(settings.FIGlocation,"HL11")
                    t1=0.42; P=14;
                end
            case {'IF_LA', 'IF'}
                t1=0.43; P=14;
            case 'RDIintensity'
                if settings.camera==9
                    t1=0.43; P=15;
                elseif settings.camera==7
                    t1=0.43; P=12;
                end
        end

        %gas callibration
    case {47439}
        f_exc = 18.181818;
        f_0=f_exc(1);
        t1=0.1; P=7;
    case {47440}
        f_exc = 18.181818;
        f_0=f_exc(1);
        t1=0.1; P=7;
    case {47441}
        f_exc = [3.030303, 9.090909,15.151515];
        f_0=f_exc(1);
        t1=0.3; P=12;
    case {47444}
        f_exc = [3.030303, 9.090909,15.151515];
        f_0=f_exc(1);
        t1=0.2; P=5;
    case {47445}
        f_exc = [3.030303, 9.090909,15.151515];
        f_0=f_exc(1);
        t1=0.2; P=5;
    case {47446}
        f_exc = [3.030303, 9.090909,15.151515];
        f_0=f_exc(1);
        t1=0.2; P=5;
    case {47497}
        f_exc = 18.181818;
        f_0=f_exc(1);
        t1=0.1; P=7;
    case {47498} % error this went wrong do not push
        f_exc = [38.6956, 26.0869, 9.090909, 15.151515 ];
        f_0=f_exc(1);
        t1=0.2; P=5;
    case {47896}
        f_exc = [8.6956, 26.0869]; % Hz
        f_0=f_exc(1);
        t1=0.32; P = 3;
    case {47929}
        f_exc = [8.6956, 26.0869]; % Hz
        f_0=f_exc(1);
        t1=0.27; P = 2;
    case {47930}
        f_exc = [8.6956, 26.0869]; % Hz
        f_0=f_exc(1);
        %  t1=0.3; P = 3;
        t1 = 0.40; P=2;
    case {47963}
        f_exc = [10]; %Hz
        f_0=f_exc(1);
        t1=0.4; P=3;
    case {47980}
        f_exc = [10]; %Hz
        f_0=f_exc(1);
        t1=0.43; P=3;
        %divertor valves!
    case {48186}
        f_exc = [10]; %Hz
        f_0=f_exc(1);
        t1=0.38; P=3;
    case {48367}
        f_exc = [80]; %Hz
        f_0=f_exc(1);
        t1=0.3; P=8;
    case {48370}
        f_exc = [40]; %Hz
        f_0=f_exc(1);
        switch signal
            case {'riv','rit'}
                t1=0.3; P=5;
            otherwise
                t1=0.32; P=6;
        end

    case {48648}
        f_exc = [40]; %Hz
        f_0=f_exc(1);
        assert_subshot(shot, subshot);
        switch subshot
            case "a"
                t1 = 0.4; P = 4;
            case "b"
                t1 = 0.3; P = 4;
        end
    case {48652}
        f_exc = [80]; %Hz
        f_0=f_exc(1);
        t1 = 0.3125; P = 3;
        % Random peak before 0.31 (visible on multiple diagnostics)
        % ELM at 0.31
        % Ramdown after 0.35
    case {48853}
        f_exc = [80];
        f_0 = f_exc(1);
        switch signal
            case {'DA'}
                t1=0.305; P=5;
        end

    case {48864}
        f_exc = [10.526316,31.578947]; %Hz
        f_0=f_exc(1);
        switch signal
            case {'FIG'}
                t1=0.25; P=3;
        end
    case {48867}
        f_exc = [10.526316]; %Hz
        f_0=f_exc(1);
        switch signal
            case {'FIG'}
                t1=0.25; P=3;
            case {'DA'}
                t1=0.25; P=3;
        end
    case {48898}
        f_exc = [80]; %Hz
        f_0=f_exc(1);
        switch signal
            case {'DA'}
                t1=0.3; P=3;
        end
    case {48899}
        f_exc = [80]; %Hz
        f_0=f_exc(1);
        switch signal
            case {'DA'}
                t1=0.34; P=3;
        end
    case {48900}
        f_exc = [80]; %Hz
        f_0=f_exc(1);
        t1 = 0.3; P = 5;
    case {48909}
        f_exc = [120]; %Hz
        f_0=f_exc(1);
        switch subshot
            case ""
                t1 = 0.3083; P = 10;
                % first period is a bit weird on front position
            % these two we only use for the core density scan!
            case "a"
                t1 = 0.3; P = 5;
            case "b"
                t1 = 0.35; P = 5;
        end
    case {48927}
        f_exc = [31.578974]; %Hz
        f_0=f_exc(1);
        switch signal
            case {'DA'}
                t1=0.4; P=3;
            case {'FIG'}
                t1=0.25; P=8;
            case {'fd'}
                t1=0.35; P=6;
            case {'fd_INV'}
                t1=0.34; P=6;
                settings.fdcut=1; %cut fd to prevent anomolies from messing up FFT
                settings.fdmin=0.25;
                settings.fdmax=1;
        end
    case {48928}
        f_exc = [27.272727]; %Hz
        f_0=f_exc(1);
        switch signal
            case {'DA'}
                t1=0.25; P=3;
            case {'fd'}
                t1=0.25; P=3;
            case {'FIG'}
                t1=0.25; P=8;
            case {'fd_INV'}
                t1=0.26; P=4;
                settings.fdcut=1; %cut fd to prevent anomolies from messing up FFT
                settings.fdmin=0.25;
                settings.fdmax=1;
        end
    case {48929}
        f_exc = [12.5]; %Hz
        f_0=f_exc(1);
        switch signal
            case {'DA'}
                t1=0.25; P=2;
            case {'FIG'}
                t1=0.25; P=3;
            case {'fd'}
                t1=0.25; P=2;
            case {'fd_INV'}
                t1=0.255; P=2;
                settings.fdcut=1; %cut fd to prevent anomolies from messing up FFT
                settings.fdmin=0.25;
                settings.fdmax=1;
        end
    case {48930}
        f_exc = [12.5]; %Hz
        f_0=f_exc(1);
        switch signal
            case {'DA'}
                t1=0.27; P=2;
            case {'FIG'}
                t1=0.25; P=3;
            case {'fd'}
                t1=0.25; P=2;
            case {'fd_INV'}
                t1=0.27; P=3;
                settings.fdcut=1; %cut fd to prevent anomolies from messing up FFT
                settings.fdmin=0.25;
                settings.fdmax=1;
        end
    case {48931}
        f_exc = [12.5]; %Hz
        f_0=f_exc(1);
        switch signal
            case {'DA'}
                t1=0.27; P=2;
            case {'FIG'}
                t1=0.25; P=3;
            case {'fd'}
                t1=0.25; P=2;
            case {'fd_INV'}
                t1=0.25; P=2;
                settings.fdcut=1; %cut fd to prevent anomolies from messing up FFT
                settings.fdmin=0.25;
                settings.fdmax=1;
        end
    case {48932}
        f_exc = [12.5]; %Hz
        f_0=f_exc(1);
        switch signal
            case {'DA'}
                t1=0.25; P=2;
            case {'FIG'}
                t1=0.25; P=3;
            case {'fd'}
                t1=0.25; P=2;
        end
    case {48933}
        f_exc = [12.5]; %Hz
        f_0=f_exc(1);
        switch signal
            case {'DA'}
                t1=0.25; P=2;
            case {'FIG'}
                t1=0.25; P=3;
            case {'fd'}
                t1=0.25; P=2;
            case {'IF'}
                t1=0.25; P=2;
            case {'fd_INV'}
                t1=0.27; P=2;
                settings.fdcut=1; %cut fd to prevent anomolies from messing up FFT
                settings.fdmin=0.25;
                settings.fdmax=1;
        end
    case {48934}
        f_exc = [18.181818]; %Hz
        f_0=f_exc(1);
        switch signal
            case {'DA'}
                t1=0.27; P=2;
            case {'FIG'}
                t1=0.25; P=3;
            case {'fd'}
                t1=0.25; P=1;
        end
    case {48935}
        f_exc = [18.181818]; %Hz
        f_0=f_exc(1);
        switch signal
            case {'DA'}
                t1=0.27; P=2;
            case {'FIG'}
                t1=0.25; P=3;
            case {'fd'}
                t1=0.25; P=2;
        end
    case {48936}
        f_exc = [18.181818]; %Hz
        f_0=f_exc(1);
        switch signal
            case {'DA'}
                t1=0.27; P=2;
            case {'FIG'}
                t1=0.25; P=3;
            case {'fd'}
                t1=0.25; P=2;
        end

    case {49058}
        assert_subshot(shot, subshot);
        switch subshot
            case "a" % drsep not a nice sine in the first 5 ms
                f_exc = [200]; %Hz
                f_0=f_exc(1);
                t1 = 0.31; P = 8;
                % ELMs are very nasty for this high f_0.  Select the largest
                % window that avoids ELMs
            case "b"
                f_exc = [120]; %Hz
                f_0=f_exc(1);
                t1 = 0.4; P = 8;
        end

    case {49059}
        assert_subshot(shot, subshot);
        switch subshot
            case "a"
                f_exc = [200]; %Hz
                f_0=f_exc(1);
                t1 = 0.3; P = 20;
                % there are some ELMs in the first half, but not too disturbing
            case "b"
                f_exc = [80]; %Hz
                f_0=f_exc(1);
                t1 = 0.4; P = 5;
                % avoid some ELMs at the end
            case "q"
                f_exc = [80];
                f_0 = f_exc(1);
                t1 = 0.4;
                P = 5;
        end
    case {49062}
        assert_subshot(shot, subshot);
        f_exc = [120]; %Hz
        f_0=f_exc(1);
        switch subshot
            case "a"
                t1 = 0.325; P = 3;
            case "b"
                t1 = 0.35; P = 6;
            case "c"
                t1 = 0.4; P = 6;
        end
    case {49260}
        assert_subshot(shot, subshot);
        f_exc = [120];
        f_0 = f_exc(1);
        switch subshot % these t1+P are checked for DA, LP and rit
            case "a"
                t1 = 0.3; P = 6;
                % there is some disturbance for the last two periods, but not a
                % good physics reason to not include them...
            case "b"
                t1 = 0.35; P = 6;
                % there is an ELM in the first period, but nothing too serious
            case "c"
                t1 = 0.408; P = 5;
                % avoid ELM in first period
            case "d"
                f_exc = [160];
                f_0 = f_exc(1);
                t1 = 0.45; P = 8;
                % there is an ELM just before the middle, but nothing too serious
        end
    case {49261}
        assert_subshot(shot, subshot);
        f_exc = [120];
        f_0 = f_exc(1);
        switch subshot
            case "a"
                t1 = 0.3; P = 6;
            case "b"
                t1 = 0.35; P = 6;
            case "c"
                t1 = 0.4; P = 6;
            case "d"
                f_exc = [160];
                f_0 = f_exc(1);
                t1 = 0.475; P = 4;
                % avoid ELM in first half
        end

    case {49292}
        f_exc = [12.5];
        f_0 = f_exc(1);
        t1 = 0.63; P = 3;
    case {49294}
        f_exc = [23.1];
        f_0 = f_exc(1);
        t1 = 0.63; P = 6;


    case {49295}
        f_exc = [12.5]; %Hz
        f_0=f_exc(1);
        switch signal
            case {'DA'}
                t1=0.4; P=6;
        end
    case {49296}

        f_exc = [12.5]; %Hz
        f_0=f_exc(1);
        switch signal
                case {'fd','fd_INV'}
                t1=0.33; P=4;
                settings.fdcut=1; %cut fd to prevent anomolies from messing up FFT
                settings.fdmin=0.25;
                settings.fdmax=0.4;
            case {'DA'}
                t1=0.4; P=3; %exactly same response if take t1=0.68; P=3 after the event for HL02SXDT
               case {'FIG'}
                t1=0.4; P=5;
        end

    case {49297}
        f_exc = [23.1]; %Hz
        f_0=f_exc(1);
        switch signal
            case {'fd','fd_INV'}
                t1=0.4; P=8;
                settings.fdcut=0; %cut fd to prevent anomolies from messing up FFT
                settings.fdmin=0.25;
                settings.fdmax=0.58;
            case {'DA'}
                t1=0.4; P=7;
            case {'FIG'}
                t1=0.4; P=5;
        end



    case {49298}
        f_exc = [23.1]; %Hz
        f_0=f_exc(1);
        switch signal
            case {'DA'}
                                t1=0.4; P=5; %HU10SXDT shows decreasing amplitude as Dalpha moves out of vieuw, only taken first few for that reasong

%                 t1=0.4; P=3; %HU10SXDT shows decreasing amplitude as Dalpha moves out of vieuw, only taken first few for that reasong
            case {'IF'}
                t1=0.45; P=9;
            case {'fd','fd_INV'}% no reponse, but needed for comparison
                t1=0.4; P=8;
                settings.fdcut=0; %cut fd to prevent anomolies from messing up FFT
                       case {'FIG'}
                t1=0.35; P=5;
        end


    case {49299}
        f_exc = [9.1,27.3]; %Hz
        f_0=f_exc(1);
        switch signal
            case {'fd','fd_INV'}
                t1=0.32; P=3;
                settings.fdcut=1; %cut fd to prevent anomolies from messing up FFT
                settings.fdmin=0.25;
                settings.fdmax=1;
            case {'DA'}
                t1=0.42; P=2;
            case {'IF'}
                t1=0.45; P=9;
            case{'FIG'}
                t1=0.35; P=6;
        end
    case {49300} %NO SW!!
        f_exc = [9.1,27.272727]; %Hz
        f_0=f_exc(1);
        switch signal
            case {'fd'}
                t1=0.35; P=3;
                settings.fdcut=1; %cut fd to prevent anomolies from messing up FFT
                settings.fdmin=0.25;
                settings.fdmax=1;
            case {'DA'}
                t1=0.4; P=3;%HU10SXDT shows decreasing amplitude as Dalpha moves out of vieuw, only taken first few for that reasong
            case {'IF'}
                t1=0.45; P=9;
        end

    case {49301}
        f_exc = [9.1,27.272727]; %Hz
        f_0=f_exc(1);
        switch signal
            case {'fd'}
                t1=0.35; P=3;
                settings.fdcut=1; %cut fd to prevent anomolies from messing up FFT
                settings.fdmin=0.25;
                settings.fdmax=1;
            case {'DA'}
                t1=0.43; P=3;%HU10SXDT shows decreasing amplitude as Dalpha moves out of vieuw, only taken first few for that reasong
                %             case {'FIG'}
                %                 t1=0.4; P=5;
            case {'IF'}
                t1=0.45; P=9;
        end
    case {49302}
        f_exc = [9.1]; %Hz
        f_0=f_exc(1);
        switch signal
            case {'fd'}
                t1=0.35; P=3;%no response, but needed for comparison
                settings.fdcut=1; %cut fd to prevent anomolies from messing up FFT
                settings.fdmin=0.17;
                settings.fdmax=1;
            case {'DA'}
                t1=0.33; P=3;
            case {'FIG'}
                t1=0.34; P=3;
            case {'IF'}
                t1=0.34; P=3;
        end
    otherwise
        warning('Shot specification not defined!')
        %GASCAL
        %         t1=0.1; P=6;
        %         f_exc = [1]; T_exp = 0.2;
        P = 9; f_exc = [1,3,5]; T_exp = 1;
        t1=0.4;

        % MS1
        %         f_exc = [1,2]; T_exp = 0.4;
        % MS2
        %          f_exc = [1,2]; T_exp = 0.3;

        % MS3
        % optimize = 'crest'
        %   f_exc = [1,3,5]; T_exp = 0.4;
        % MS4
        %  f_exc = [1,3]; T_exp = 0.4;
        % MS5
        %  f_exc = [1]; T_exp = 0.4;
        % MS6
        %          f_exc = [3]; T_exp = 0.4;
        % MS7
        %  f_exc = [5]; T_exp = 0.4;
        % MS8
        %  f_exc = [1,3,5]; T_exp = 0.35;
        % MS9
        %          f_exc = [1]; T_exp = 0.35;
        % MS 10
        %           f_exc = [1,3]; T_exp = 0.25;
        % MS 11
        %  f_exc = [8]; T_exp = 0.4;

        % MS 12
        % optimize = 'integral'
        %  f_exc = [1,2]; T_exp = 0.35;
        % optimize = 'crest';
        % MS13
        %   f_exc = [1,3,6]; T_exp = 0.3;
        % MS14
        % f_exc = [1,3]; T_exp = 0.3;
        % MS15
        %  f_exc = [1]; T_exp = 0.3;
        % MS16
        %          f_exc = [1,3]; T_exp = 0.35;

        %conversion
        f_exc=f_exc.*3./T_exp;
        f_0=f_exc(1);

        %%%%%%% otherwise %%%%%%%
        %     otherwise
        %         fprintf('--------------------------------------------\n');
        %         fprintf('frfpars unvailable, git pull or update\n');
        %         fprintf('--------------------------------------------\n');
        %         f_exc = []; P = []; t1 = [];
        %end
end

settings.perturbation_window = [t1, t1 + P*(1/f_0)];