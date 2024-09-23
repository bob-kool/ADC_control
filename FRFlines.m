%FRF estimation of pertubative experiments
%Transfers and their variances are computed according to System
%Identification: A frequency domain approach - periodic Local Polynomial
%method. Signal to noise ratio is estimated.

%Variance
%2 sigma on gain
%2 sigma on phase

%J.T.W. Koenders
%j.t.w.koenders@differ.nl
%Modified for MAST-U by B.Kool
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
%% User Settings
% Choose Shot
% shot = "47080";settings.valveplenumpressure=750;letter='a';
% shot = "47083";settings.valveplenumpressure=750;letter='b';
% shot = "47086";settings.valveplenumpressure=750;letter='c';
% shot = "47116";settings.valveplenumpressure=750;letter='d';
% shot = "47118";settings.valveplenumpressure=750;letter='e';
shot = "47119";settings.valveplenumpressure=750;letter='f';

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
switch shot
    case "47119"
        plotsettings.freqrange_lines=[0.5 100]; %range of frequencies to consider for lines
    otherwise
        plotsettings.freqrange_lines=[0.5 60]; %range of frequencies to consider for lines
end
plotsettings.correct_phase=0;    %correct for phase jump
plotsettings.xscale='linear';
%% Settings for input/output
% For valve
% settings.valve='PFR_BOT_B01';
% settings.valve='HFS_MID_U02';
% settings.valve='LFSD_BOT_L0506';
settings.valve='LFSV_BOT_L09';
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
%for Dalpha
% settings.scope="HM10ER";
% settings.scope="HM10ET";
settings.scope="HL01SXDR";
% settings.scope="HL02SXDT";
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
%% Override legend
f2.Children(2).YLabel.String='$|\delta\mathrm{L}_{\mathrm{tar}}(\mathrm{f})|\ [\mathrm{m}]$';
f2.Children(4).YAxis(2).Label.String='$\mathrm{L}_{\mathrm{tar}}\ [\mathrm{m}]$';
f2.Children(4).YAxis(1).Label.String='$\mathrm{Flowrate}\ [\mathrm{s^{-1}}]$';
%% Remove other
delete(f2.Children(4).Children(1))
delete(f2.Children(4).Children(1))
if strcmp(shot,'47118')||strcmp(shot,'47080')|| strcmp(shot,'47083')
    delete(f2.Children(2).Children(3))
    delete(f2.Children(2).Children(3))
else
    delete(f2.Children(2).Children(2))
    delete(f2.Children(2).Children(2))
end
%% switch axes
yyaxis(f2.Children(4),'right')
Ylimright=f2.Children(4).YLim;
Ylabelright=f2.Children(4).YLabel.String;
Xright=f2.Children(4).Children.XData;
Yright=f2.Children(4).Children.YData;
delete(f2.Children(4).Children)
yyaxis(f2.Children(4),'left')
Ylimleft=f2.Children(4).YLim;
Ylabelleft=f2.Children(4).YLabel.String;
Xleft=f2.Children(4).Children.XData;
Yleft=f2.Children(4).Children.YData;
delete(f2.Children(4).Children)
yyaxis(f2.Children(4),'right')
plot(f2.Children(4),Xleft,Yleft,'Color','r','LineStyle','-',LineWidth=2,DisplayName='Input')
ylim(f2.Children(4),Ylimleft)
ylabel(f2.Children(4),Ylabelleft)
yyaxis(f2.Children(4),'left')
plot(f2.Children(4),Xright,Yright,'Color','k','LineStyle','-',LineWidth=2,DisplayName='Output')
ylim(f2.Children(4),Ylimright)
ylabel(f2.Children(4),Ylabelright)


%% change color
% colorcode=[1,0,0];
% 
% f2.Children(2).Children(2).Color=colorcode;
% f2.Children(4).Children.Color=colorcode;
% f2.Children(4).YAxis(2).Color='k';
% 
% colorcode=[57,87,163]/256;
% yyaxis(f2.Children(4),'left')
% f2.Children(4).Children.Color=colorcode;
% f2.Children(4).YLabel.Color='k';

%% Set colours
yyaxis(f2.Children(4),'left')
colorcode=[256,0,0]/256;
f2.Children(4).Children.Color=colorcode;
f2.Children(4).YAxis(2).Color='k';
if strcmp(shot,'47118') || strcmp(shot,'47080')|| strcmp(shot,'47083')
f2.Children(2).Children(3).Color=colorcode;
else
f2.Children(2).Children(2).Color=colorcode;
end

yyaxis(f2.Children(4),'right')
colorcode=[57,87,163]/256;
f2.Children(4).Children.LineStyle='-.';
f2.Children(4).Children.LineWidth=3;
f2.Children(4).Children.Color=colorcode;
f2.Children(4).YLabel.Color='k';

if strcmp(shot,'47118') || strcmp(shot,'47080') || strcmp(shot,'47083')
    f2.Children(2).Children(4).LineStyle='-.';
    f2.Children(2).Children(4).LineWidth=3;
    f2.Children(2).Children(4).Color=colorcode;
        f2.Children(2).Children(5).LineStyle='-.';
    f2.Children(2).Children(5).LineWidth=3;
    f2.Children(2).Children(5).Color=colorcode;
else
    f2.Children(2).Children(3).LineStyle='-.';
    f2.Children(2).Children(3).LineWidth=3;
    f2.Children(2).Children(3).Color=colorcode;
end

%% Switch plot order
% set(f2.Children(4), 'SortMethod', 'depth')
% change manually in inkscape!

%% Add letter
text(f2.Children(4),0,0,strcat('\textbf{',letter,'}'),Units='normalized',FontSize=20,Position=[-0.140009585221331,1.121853048248987,0])

%% Adjust whitespace
f2.Children(2).Position=[0.1200 0.1341 0.7750 0.3412];
freqlabels=findobj(f2.Children(2).Children,'type','Text');
for ii=1:length(freqlabels)
    freqlabels(ii).Units='normalized';
    freqlabels(ii).Position(2)=0.8738 ;%move text inside
end
%% give 47118 correct f3 label
switch shot
    case {"47118"}
        f2.Children(2).Children(1).String=strrep(f2.Children(2).Children(1).String,'f_2','f_3');
end
%% add colours
% Remove the vertical exitation lines
for ii=1:length(f_exc)
    delete(f2.Children(2).Children(end))
end

%find index of excited frequencies and remove them
for ii=1:length(f_exc)
    [ d, ix ] = min( abs(Ydet.freq-f_exc(ii) ) );
    idx_exc(ii)=ix;
end
stemobj=findobj(f2.Children(2).Children,'type','Stem');
stemobj.XData(idx_exc)=NaN;
stemobj.YData(idx_exc)=NaN;

%find index of 1st harmonic and remove them
switch shot
    case {"47080","47083","47086","47116","47118","47119"}
        for ii=1:length(f_exc)
            [ d, ix ] = min( abs( Ydet.freq-f_exc(ii)*2 ) );
            idx_harm1(ii)=ix;
        end
        %first harmonic is exited frequency, so remote from index
        switch shot
             case {"47080","47083"}
                 idx_harm1=idx_harm1(end);
        end
        stemobj=findobj(f2.Children(2).Children,'type','Stem');
        stemobj.XData(idx_harm1)=NaN;
        stemobj.YData(idx_harm1)=NaN;
end

%find index of 2nd harmonic and remove them
switch shot
    case {"47080","47083","47086","47116"}
        for ii=1:length(f_exc)
            [ d, ix ] = min( abs( Ydet.freq-f_exc(ii)*3 ) );
            idx_harm2(ii)=ix;
        end
        stemobj=findobj(f2.Children(2).Children,'type','Stem');
        stemobj.XData(idx_harm2)=NaN;
        stemobj.YData(idx_harm2)=NaN;
end

if length(f_exc)>2
    error('color coding not made to handle more then 2 frequencies')
end

%find index of f1+f2 and remove them
switch shot
    case "47118"
        [ d, ix ] = min( abs(Ydet.freq-sum(f_exc)) );
        idx_harmsum=ix;
        stemobj=findobj(f2.Children(2).Children,'type','Stem');
        stemobj.XData(idx_harmsum)=NaN;
        stemobj.YData(idx_harmsum)=NaN;
end

% Add excited freqencies colour
stem(f2.Children(2),Ydet.freq(idx_exc),abs(Ydet.data1(idx_exc)),'-','LineWidth',2,'Displayname','Excited',Color=colorcode);

% Add excited 1st harmonic colour
switch shot
    case {"47080","47083","47086","47116","47118","47119"}
        stem(f2.Children(2),Ydet.freq(idx_harm1),abs(Ydet.data1(idx_harm1)),'-','LineWidth',2,'Displayname','$1^{\mathrm{st}}$ harmonic',Color="#77AC30");
end

% Add excited sum harmonic colour
switch shot
    case "47118"
        stem(f2.Children(2),Ydet.freq(idx_harmsum),abs(Ydet.data1(idx_harmsum)),'-','LineWidth',2,'Displayname','$\mathrm{f}_1+\mathrm{f}_3$',Color="#EDB120");
end

% Add excited second harmonic
switch shot
    case {"47080","47083","47086","47116"}
        stem(f2.Children(2),Ydet.freq(idx_harm2),abs(Ydet.data1(idx_harm2)),'-','LineWidth',2,'Displayname','$2^{\mathrm{nd}}$ harmonic',Color="#7E2F8E");
end

%correct legend position
f2.Children(1).Position=[0.743233886983057,0.363855798725032,0.206171266321433,0.168677427217215];

%correct DFT to non-excited
f2.Children(1).String{1}='Non-excited';

%% Add noise floor
%get index for non-excited frequencies
idx_allexited_and_nonlinear=[idx_exc];
if exist('idx_harm1','var')
    idx_allexited_and_nonlinear=[idx_allexited_and_nonlinear,idx_harm1];
end
if exist('idx_harm2','var')
    idx_allexited_and_nonlinear=[idx_allexited_and_nonlinear,idx_harm2];
end
if exist('idx_harmsum','var')
    idx_allexited_and_nonlinear=[idx_allexited_and_nonlinear,idx_harmsum];
end
%make frequecy index vector for average
idx_for_avg=1:length(Ydet.freq(Ydet.freq<200));
idx_for_avg(idx_for_avg<min(idx_allexited_and_nonlinear))=NaN;
idx_for_avg(idx_allexited_and_nonlinear)=NaN;
idx_for_avg=idx_for_avg(~isnan(idx_for_avg));

noisefloor=mean(abs(Ydet.data1(idx_for_avg)));
floor=yline(f2.Children(2),noisefloor,'k--','LineWidth',1);
floor.Annotation.LegendInformation.IconDisplayStyle='off';


