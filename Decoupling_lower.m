%% Decoupling lower
%% Start clean
clc; close all; clearvars;
%% Add functions and data path
% mydir  = which('example_frf_est_openloop');                                         %present folder path
% idcs   = strfind(mydir,filesep);                                            %find filesep indices
% maindir = mydir(1:idcs(end-1));                                             %get main folder
% addpath(genpath(maindir));                                                  %add full main folder
% addpath(genpath('/Differ/Data/MAST-U'));                                    %add datafolder
% frfdatafolder=('/Differ/Data/MAST-U/FRFanalysis/FRFdata/');                 %specify frfdatafolder
% set_python_env                                                              %set python environoment to access uda data

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Dalpha
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% User Settings
% Choose Shot
shot = "49297";settings.valveplenumpressure=500;

%select input and output ['valve','fd','fd_INV','fdDMS','DA','IF_LA','IF','FIG','BOLO','RDIintensity','DMSintensity','UFDS','rit','rir','riv','riu','ris_lower','ris_upper','rba','LP','Z']
Input='valve';
Output='DA';

%flip top half of output signal to get around the non-linearity of the valve
fliptop_output=false;

%save FRF estimate
do_save = false;

%% plotting options
plotsettings.fig_on=1;%show the debugger plot from interal function
plotsettings.phaserange=[-300 0]; %range of phases
plotsettings.freqrange_FRF=[0.5 200]; %range of frequencies to consider for FRF plot
plotsettings.freqrange_lines=[0.5 100]; %range of frequencies to consider for lines
plotsettings.correct_phase=0;    %correct for phase jump
plotsettings.xscale='linear';
%% Settings for input/output
% For valve
% settings.valve='PFR_BOT_B01';
% settings.valve='HFS_MID_U02';
settings.valve='LFSD_BOT_L0506';
% settings.valve='LFSV_BOT_L09';
% settings.valve='LFSD_TOP_U0102';
% settings.valve='LFSD_BOT_L0102';


%  settings.valve='LFSD_BOT_L0506';
% settings.valve='LFSV_BOT_L09';
% settings.valve='LFSD_TOP_U0102';
% settings.valve='LFSD_BOT_L0102';

% settings.valvespec='measured';
% settings.valvespec='requested';
settings.valvespec='flowrate'; % flow request die controller 
settings.take_requested_from_measured =2;
settings.calculate_flowrate = 1;

% For Lpol
settings.fdspec = 'FB_50'; %for MWI Lpol
% settings.fdspec = 'FB_50_fix'; %for MWI Lpol
settings.referenceshot=0; %speficy 0 to disable
settings.inversion=0;
settings.fixequil=0;
settings.specline=settings.fdspec;
settings.XPI=1;
%for Dalpha
% settings.scope="HM10ER";
% settings.scope="HM10ET";
% settings.scope="HL01SXDR";
settings.scope="HL02SXDT";
% settings.scope="HL02OSPR";
% settings.scope="HU10OSPR";
% settings.scope="HU10SXDT";

%for LP
% settings.LPspec="lower_4_T4T5_int";
settings.LPspec="upper_4_C5C6_int";

%for BOLO
settings.BOLOchannel=13;

%for FIG
%  settings.FIGlocation="HM12";
% settings.FIGlocation="HL11";
settings.FIGlocation="HU08";

%for RDI intensity
settings.camera=7; %7=Dalpha
settings.intensitylocation='ISP'; %ISP or OSP, specify as NaN to take whole image


%for DMS 
settings.DMSsystem='3btm'; %choose 1,2,3btm,3mid,4 (specify as string)
settings.DMSfilter='FB';
settings.DMSthresh=0.5;

%for UFDS
settings.UFDSfilter='FB'; %[FB,D32,D42]

% general settings
settings.filter_elms = false;

%% Get FRF parameters for this shot
[f0,f_exc,t1,P,settings]=get_frfpars_mastu(shot,Input,Output,settings);
%% Get input and output
[u,y]=get_inputandoutput(Input,Output,shot,settings);
%% Cut signals to size
fs_u= get_fs(Input,settings.valvespec,settings.take_requested_from_measured);
fs_y= get_fs(Output,settings.valvespec,settings.take_requested_from_measured);
%change t1 to fit smallest sampling rate
 if fs_u<=fs_y
     [~,id1]=min(abs(u.time-t1));
     t1=u.time(id1);
 else
      [~,id1]=min(abs(y.time-t1));
     t1=y.time(id1);
 end
uc  = frf_cutsignal(u.data,u.time,t1,f_exc(1),fs_u,P);
yc  = frf_cutsignal(y.data,y.time,t1,f_exc(1),fs_y,P,fliptop_output);

%% Run LPM
[FRF,U,Up,Y,Ydet,Yp] = frf_lpm_main(uc,yc,f0,f_exc,P,plotsettings.fig_on); 

%% Get noise for each exited frequency
sigma_noise=sqrt(squeeze(Yp.var)');
SNR=abs(Yp.out)./sigma_noise;
Qual=SNR>=5;
disp(['SNR = [' num2str(SNR(:).') ']']) ;
disp(['Qual = [' num2str(Qual(:).') ']']) ;
%% Plot data
[f1,f2]=plotdata(shot,FRF,Yp,Ydet,f_exc,Input,Output,yc,uc,sigma_noise,plotsettings,settings);
%% Set painters
f1.Renderer='painters';
f2.Renderer='painters';
%% delete extra lines
delete(f2.Children(2).Children(2))
delete(f2.Children(2).Children(2))
delete(f2.Children(4).Children(1))
delete(f2.Children(4).Children(2))
delete(f2.Children(4).Title)

%% switch axes
yyaxis(f2.Children(4),'right')
Xright=f2.Children(4).Children.XData;
Yright=f2.Children(4).Children.YData;
delete(f2.Children(4).Children)
yyaxis(f2.Children(4),'left')
Xleft=f2.Children(4).Children.XData;
Yleft=f2.Children(4).Children.YData;
delete(f2.Children(4).Children)
f2.Children(4).Title.String='Lower divertor valve perturbation';
f2.Children(4).Title.FontSize=25;
f2.Children(4).Title.Units='normalized';
f2.Children(4).Title.Position=[ 0.5000    0.9962         0];
yyaxis(f2.Children(4),'right')
plot(f2.Children(4),Xleft,Yleft,'Color','r','LineStyle','-',LineWidth=2,DisplayName='Input: gas valve flowrate')
yyaxis(f2.Children(4),'left')
plot(f2.Children(4),Xright,Yright,'Color','b','LineStyle','-',LineWidth=2,DisplayName='Output: $\mathrm{D}_{\mathrm{alpha}}$ filterscope')


%% set colors
f2.Children(2).YAxis.Color='k';
f2.Children(2).Children(2).Color=[230,130,0]/256;
f2.Children(2).Children(1).Color='k';
f2.Children(2).Children(3).Color=[57,87,163]/256;
f2.Children(2).Children(3).LineStyle='-.';
f2.Children(2).Children(3).LineWidth=3;
f2.Children(2).Children(2).LineWidth=3;

yyaxis(f2.Children(4),'left')
f2.Children(4).YAxis(1).Color='k';
f2.Children(4).Children.Color=[230,130,0]/256;
f2.Children(4).Children.LineStyle='-';
f2.Children(4).Children.LineWidth=2;
yyaxis(f2.Children(4),'right')
f2.Children(4).YAxis(2).Color='k';
f2.Children(4).Children.Color=[57,87,163]/256;
f2.Children(4).Children.LineStyle='-.';
f2.Children(4).Children.LineWidth=3;

%% tuning
f2.Position=[100 430 1000 400];
f2.Children(2).Position=[0.145    0.1428    0.72   0.3412];
f2.Children(4).Position=[0.145    0.5938    0.72   0.3412];
f2.Children(4).Legend.Location='southeast';
f2.Children(2).XLabel.Units='normalized';
f2.Children(4).XLabel.Units='normalized';
f2.Children(4).XLabel.Position=[ 0.5000   -0.1524         0];
f2.Children(2).XLabel.Position=[0.500000476837158,-0.138775508257808,0];
f2.Children(4).YAxis(1).Limits=[2.4   3.4];
f2.Children(4).YAxis(2).Limits=[-2e21   3.16e21];
f2.Children(2).XAxis.Limits=[0   60];

%labels
f2.Children(4).YAxis(2).Label.String='$\mathrm{Flowrate} \ [\mathrm{s^{-1}}]$';
f2.Children(4).YAxis(1).Label.String='$\mathrm{Lower \ D}_{\mathrm{alpha}} \ [\mathrm{V}]$';
f2.Children(2).YAxis(1).Label.String='$|\delta\mathrm{Lower \ D}_{\mathrm{alpha}}(\mathrm{f})| \ [\mathrm{V}]$';

fontsize(gcf,scale=0.75)
%note
a=annotation('textarrow',[0.4,0.3],[0.4,0.3],'String','Perturbation successful','FontSize',14);
a.Position=[ 0.4780    0.3708   -0.0460    0.0396];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Front position
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% User Settings
% Choose Shot
shot = "49297";settings.valveplenumpressure=500;

%select input and output ['valve','fd','fd_INV','fdDMS','DA','IF_LA','IF','FIG','BOLO','RDIintensity','DMSintensity','UFDS','rit','rir','riv','riu','ris_lower','ris_upper','rba','LP','Z']
Input='valve';
Output='fd_INV';

%flip top half of output signal to get around the non-linearity of the valve
fliptop_output=false;

%save FRF estimate
do_save = false;

%% plotting options
plotsettings.fig_on=1;%show the debugger plot from interal function
plotsettings.phaserange=[-300 0]; %range of phases
plotsettings.freqrange_FRF=[0.5 200]; %range of frequencies to consider for FRF plot
plotsettings.freqrange_lines=[0.5 60]; %range of frequencies to consider for lines
plotsettings.correct_phase=0;    %correct for phase jump
plotsettings.xscale='linear';
%% Settings for input/output
% For valve
% settings.valve='PFR_BOT_B01';
% settings.valve='HFS_MID_U02';
settings.valve='LFSD_BOT_L0506';
% settings.valve='LFSV_BOT_L09';
% settings.valve='LFSD_TOP_U0102';
% settings.valve='LFSD_BOT_L0102';


%  settings.valve='LFSD_BOT_L0506';
% settings.valve='LFSV_BOT_L09';
% settings.valve='LFSD_TOP_U0102';
% settings.valve='LFSD_BOT_L0102';

% settings.valvespec='measured';
% settings.valvespec='requested';
settings.valvespec='flowrate'; % flow request die controller 
settings.take_requested_from_measured =2;
settings.calculate_flowrate = 1;

% For Lpol
settings.fdspec = 'FB_50'; %for MWI Lpol
% settings.fdspec = 'FB_50_fix'; %for MWI Lpol
settings.referenceshot=0; %speficy 0 to disable
settings.inversion=0;
settings.fixequil=0;
settings.specline=settings.fdspec;
settings.XPI=0;
settings.dual=1;
settings.wrt_Xpoint=0;
%for Dalpha
% settings.scope="HM10ER";
% settings.scope="HM10ET";
% settings.scope="HL01SXDR";
settings.scope="HL02SXDT";
% settings.scope="HL02OSPR";
% settings.scope="HU10OSPR";
% settings.scope="HU10SXDT";

%for LP
% settings.LPspec="lower_4_T4T5_int";
settings.LPspec="upper_4_C5C6_int";

%for BOLO
settings.BOLOchannel=13;

%for FIG
%  settings.FIGlocation="HM12";
% settings.FIGlocation="HL11";
settings.FIGlocation="HU08";

%for RDI intensity
settings.camera=7; %7=Dalpha
settings.intensitylocation='ISP'; %ISP or OSP, specify as NaN to take whole image


%for DMS 
settings.DMSsystem='3btm'; %choose 1,2,3btm,3mid,4 (specify as string)
settings.DMSfilter='FB';
settings.DMSthresh=0.5;

%for UFDS
settings.UFDSfilter='FB'; %[FB,D32,D42]

% general settings
settings.filter_elms = false;

%% Get FRF parameters for this shot
[f0,f_exc,t1,P,settings]=get_frfpars_mastu(shot,Input,Output,settings);
%% Get input and output
[u,y]=get_inputandoutput(Input,Output,shot,settings);
%% Cut signals to size
fs_u= get_fs(Input,settings.valvespec,settings.take_requested_from_measured);
fs_y= get_fs(Output,settings.valvespec,settings.take_requested_from_measured);
%change t1 to fit smallest sampling rate
 if fs_u<=fs_y
     [~,id1]=min(abs(u.time-t1));
     t1=u.time(id1);
 else
      [~,id1]=min(abs(y.time-t1));
     t1=y.time(id1);
 end
uc  = frf_cutsignal(u.data,u.time,t1,f_exc(1),fs_u,P);
yc  = frf_cutsignal(y.data,y.time,t1,f_exc(1),fs_y,P,fliptop_output);

%% Run LPM
[FRF,U,Up,Y,Ydet,Yp] = frf_lpm_main(uc,yc,f0,f_exc,P,plotsettings.fig_on); 

%% Get noise for each exited frequency
sigma_noise=sqrt(squeeze(Yp.var)');
SNR=abs(Yp.out)./sigma_noise;
Qual=SNR>=5;
disp(['SNR = [' num2str(SNR(:).') ']']) ;
disp(['Qual = [' num2str(Qual(:).') ']']) ;
%% Plot data
[f1,f2]=plotdata(shot,FRF,Yp,Ydet,f_exc,Input,Output,yc,uc,sigma_noise,plotsettings,settings);
%% Set painters
f1.Renderer='painters';
f2.Renderer='painters';
%% delete extra lines
delete(f2.Children(2).Children(2))
delete(f2.Children(2).Children(2))
delete(f2.Children(4).Children(1))
delete(f2.Children(4).Children(2))
% delete(f2.Children(4).Title)
f2.Children(4).Title.String='Front position response';
f2.Children(4).Title.FontSize=25;
f2.Children(4).Title.Units='normalized';
f2.Children(4).Title.Position=[ 0.5000    0.9962         0];
%% switch axes
yyaxis(f2.Children(4),'right')
Xright=f2.Children(4).Children.XData;
Yright=f2.Children(4).Children.YData;
delete(f2.Children(4).Children)
yyaxis(f2.Children(4),'left')
Xleft=f2.Children(4).Children.XData;
Yleft=f2.Children(4).Children.YData;
delete(f2.Children(4).Children)
yyaxis(f2.Children(4),'right')
plot(f2.Children(4),Xleft,Yleft,'Color','r','LineStyle','-',LineWidth=2,DisplayName='Input')
yyaxis(f2.Children(4),'left')
plot(f2.Children(4),Xright,Yright,'Color','r','LineStyle','-',LineWidth=2,DisplayName='Output')



%% set colors

f2.Children(2).YAxis.Color='k';
f2.Children(2).Children(2).Color='r';
f2.Children(2).Children(1).Color='k';
f2.Children(2).Children(3).Color=[57,87,163]/256;
f2.Children(2).Children(3).LineWidth=3;
f2.Children(2).Children(3).LineStyle='-.';

yyaxis(f2.Children(4),'left')
f2.Children(4).YAxis(1).Color='k';


yyaxis(f2.Children(4),'right')
f2.Children(4).YAxis(2).Color='k';
f2.Children(4).YAxis(2).Label.Visible='off';
f2.Children(4).YAxis(2).TickValues='';
% yyaxis(f2.Children(4),'left')
% plot(f2.Children(4),X,Y,'Color',orangecolor,'LineStyle','-',LineWidth=2)
% 
% yyaxis(f2.Children(4),'right')
% cla(f2.Children(4))
% f2.Children(4).YAxis(2).Visible='off';
% yyaxis(f2.Children(4),'left')
% f2.Children(4).YAxis(1).Color=orangecolor;


%% tuning
f2.Position=[100 430 650 430];
f2.Children(2).Position=[0.145    0.1428    0.72   0.3412];
f2.Children(4).Position=[0.145    0.5938    0.72   0.3412];
f2.Children(4).YAxis(1).Limits=[0.56   0.62];
f2.Children(2).XLabel.Units='normalized';
f2.Children(4).Legend.Visible='off';
f2.Children(4).XLabel.Units='normalized';
f2.Children(4).XLabel.Position=[ 0.5000   -0.1524         0];
f2.Children(2).XLabel.Position=[0.500000476837158,-0.138775508257808,0];
f2.Children(2).XAxis.Limits=[0   60];

%labels
f2.Children(4).YAxis(2).Label.String='';
f2.Children(4).YAxis(1).Label.String='$\mathrm{L}_{\mathrm{tar}} \ [\mathrm{m}]$';
f2.Children(2).YAxis.Label.String='$|\delta\mathrm{L}_{\mathrm{tar}}(\mathrm{f})| \ [\mathrm{m}]$';
fontsize(gcf,scale=0.75)

%note
annotation('textarrow',[0.335384615384616,0.409230769230769],[0.425581395348837,0.398372093023256],'String','Clear response','FontSize',14)