%%  Simple script to fit transfer functions to FRF data and  compare with data
% G.L. Derks, B.Kool
% g.l.derks@differ.nl, b.kool@differ.nl
%
% NOTE: G is defined from flowrate/1e21 to y
%       flowrate is calculated through conversion from measured voltage to
%       requested voltage, and subsequently to flowrate through the gas
%       callibration

%% Start clean
clc;clearvars;close all;
%% %%%%%%%%%%%%%%%%%%%% USER SETTINGS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Select shots to plot
shotlist=[47080,47083,47086,47116,47118,47119]; %midplane valve shots
% Specify legendentries
Legendnames{1}='47080 ED';
Legendnames{2}='47083 ED';
Legendnames{3}='47086 ED';
Legendnames{4}='47116 SXD';
Legendnames{5}='47118 SXD';
Legendnames{6}='47119 SXD';
labels.output='\delta\mathrm{Midplane\ D}_{\mathrm{alpha}}';
labels.input='\delta\mathrm{Flowrate}';
%specify colors
Colors{1}=[0.9290 0.6940 0.1250];
Colors{2}=['b'];%0.8500 0.3250 0.0980
Colors{3}=[0 0.4470 0.7410];
Colors{4}=[0.3010 0.7450 0.9330];
Colors{5}=[0.4660 0.6740 0.1880];
Colors{6}=['r'];%0.4940 0.1840 0.5560
% Specify markers
Markers{1}="*";
Markers{2}="*";
Markers{3}="*";
Markers{4}="diamond";
Markers{5}="diamond";
Markers{6}="diamond";
Markersizes{1}=12;
Markersizes{2}=12;
Markersizes{3}=12;
Markersizes{4}=8;
Markersizes{5}=8;
Markersizes{6}=8;
%% Select Fit to plot
FitName = 'fd_INV_MU02_LFSV_BOT_L09';

%% Select input and output
Input='valve';
Output='DA'; 

settings.FIGlocation="HL11";
settings.scope='HM10ET';
settings.UFDSfilter='FB';
settings.valve='LFSV_BOT_L09';

settings.fdspec = 'FB_50'; %for MWI Lpol
settings.referenceshot=0; %speficy 0 to disable
settings.inversion=0;
settings.fixequil=0;
settings.specline=settings.fdspec;
%% Select valve signal 
valveplenumpressure=750; %this can be a matrix!
settings.valvespec='flowrate';
settings.calculate_flowrate=1;
settings.take_requested_from_measured = 2;%take from measured

%% Select plotting options
plotsettings.phaserange=[-110 0]; %range of phases
plotsettings.freqrange_FRF=[0.5 200]; %range of frequencies to consider for FRF plot
plotsettings.correct_phase=1;    %correct for phase jump
plotsettings.xscale='log';
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Set latex to default interpreter
set_Latex_for_all
%% load and plot FRF
frfdatafolder=('/Differ/Data/MAST-U/FRFanalysis/FRFdata/');                 %specify frfdatafolder
% get labels
[~,labels.inputunits,~,labels.outputunits]=getlabels(Input,Output,settings);
% Create empty figure base
[f,h] = makeFRFfigure_base(labels,plotsettings);

% Plotting of FRF results
for ii=1:length(shotlist)
    %% Take valve plenumpressure
    if length (valveplenumpressure)>1 %apparently pressure is a matrix now
        settings.valveplenumpressure= valveplenumpressure(ii);
    else 
        settings.valveplenumpressure= valveplenumpressure;
    end
    %% Get figurename
    [figurename] = get_figurename(Input,Output,shotlist(ii),settings);
    %     load(strcat(frfdatafolder,figurename,'/parameters'));
    %% Get FRF parameters for this shot
    [f0,f_exc,t1,P,settings]=get_frfpars_mastu(shotlist(ii),Input,Output,settings);
    %% Get input and output
    [u,y]=get_inputandoutput(Input,Output,shotlist(ii),settings);
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
    yc  = frf_cutsignal(y.data,y.time,t1,f_exc(1),fs_y,P);
    %% Run LPM
    [FRF,U,Up,Y,Ydet,Yp] = frf_lpm_main(uc,yc,f0,f_exc,P,0);
    %% Get noise for each exited frequency
    sigma_noise=sqrt(squeeze(Yp.var)');
    SNR=abs(Yp.out)./sigma_noise;
    Qual=SNR>=1;
    disp(['SNR = [' num2str(SNR(:).') ']']) ;
    disp(['Qual = [' num2str(Qual(:).') ']']) ;
    %% Remove frequencies that do not meet SNR requirment from FRF plot
    f_exc=f_exc(Qual);
    FRF.TF=FRF.TF(Qual);
    FRF.s2g=FRF.s2g(Qual);
    FRF.s2p=FRF.s2p(Qual);
    %% Fill figure
    plotsettings.color=Colors{ii};
    [h] = fillFRFfigure(h,plotsettings,FRF,f_exc);
    %% change marker
    h(1).Children(1).Marker=Markers{ii};
    h(2).Children(1).Marker=Markers{ii};
    h(1).Children(1).MarkerSize=Markersizes{ii};
    h(2).Children(1).MarkerSize=Markersizes{ii};
    h(1).Children(1).MarkerFaceColor='w';
    h(2).Children(1).MarkerFaceColor='w';

end

ylim(h(1),[1e-23,1.0001e-21])

% % copy the objects
% hCopy = copyobj(h(1).Children, h(1)); 
% % replace coordinates with NaN 
% % Either all XData or all YData or both should be NaN.
% set(hCopy(1),'XData', [NaN,NaN], 'YData',[NaN,NaN])
% set(hCopy(2),'XData', [NaN,NaN], 'YData',[NaN,NaN])
% set(hCopy(3),'XData', [NaN,NaN], 'YData',[NaN,NaN])
% set(hCopy(4),'XData', [NaN,NaN], 'YData',[NaN,NaN])
% set(hCopy(5),'XData', [NaN,NaN], 'YData',[NaN,NaN])
% set(hCopy(6),'XData', [NaN,NaN], 'YData',[NaN,NaN])
% set(hCopy(7),'XData', [NaN,NaN], 'YData',[NaN,NaN])
% % Note, these lines can be combined: set(hCopy,'XData', NaN', 'YData', NaN)
% % To avoid "Data lengths must match" warning, assuming hCopy is a handle array, 
% % use arrayfun(@(h)set(h,'XData',nan(size(h.XData))),hCopy)
% % Alter the graphics properties
% % Create legend using copied objects
% Legendnames=fliplr(Legendnames);
% Legendnames{7}='Model';
% legend(hCopy,[Legendnames],Position=[0.797971784143189,0.702965525988874,0.186068653520347,0.290137922286987]);

% originalnames=Legendnames;
% Legendnames{1}='Model';
% Legendnames{2}=originalnames{1};
% Legendnames{3}=originalnames{2};
% Legendnames{4}=originalnames{3};
% Legendnames{5}=originalnames{4};
% Legendnames{6}=originalnames{5};
% Legendnames{7}=originalnames{6};
lhandle=legend(h(1),[Legendnames],Position=[0.797971784143189,0.702965525988874,0.186068653520347,0.290137922286987]);

%set painters
f.Renderer='painters';
