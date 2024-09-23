%% Start clean
clearvars;clc;close all;set_Latex_for_all;
%% Specify shot data to load
filename='fd_48001_FB_50_ref_47985';plottime=0.534;
% filename='fd_47998_FB_50_ref_47980';plottime=0.593;
shot=str2double(extractBefore(extractAfter(filename,'fd_'),'_'));

%% Settings
tspan=[0.4,0.8];
%% Filelocations
cf=fileparts(which('main.m'));
addpath(genpath(cf));

vessel_path='/Differ/Data/MAST-U//MAST-Uvessel';
addpath(genpath('/Differ/Data/MAST-U/'));

savefitfolder='/Differ/Data/MAST-U//MWI/fronttracking/fitdata';
saveROIfolder='/Differ/Data/MAST-U//MWI/fronttracking/ROIdata';
savedatafolder='/Differ/Data/MAST-U//MWI/fronttracking/frontdata';
savegiffolder='/Differ/Data/MAST-U//MWI/fronttracking/gifs';
%% load saved data
load(filename)
camind = getcamind(shot,settings.specline);
[DC] = getPCSdetachmentcontrol(shot);
%correct for import
a=fd;
% get efit data
efit = getEFIT(shot,'reduced');

%% get timespans
[~, iistart] = min(abs(a.tout-settings.tspan(1)));
[~, iiend] = min(abs(a.tout-settings.tspan(2)));
[~,ii]=min(abs(a.tout-plottime));
[~,iiPCS]=min(abs(DC.lpol.time-plottime));
%% load images, callibration
if~exist('cam_images','var')
    disp('--- aquiring camera images ---')
    disp(string(strcat('shot',{' '},num2str(shot),'_',settings.specline)))
    if settings.inversion
        [cam_images,indices,t_vec,cam_R,cam_Z,sizecolomn,sizerow]= load_inv_data(shot,camind,settings,vessel_path);
    else
        [cam_images,indices,t_vec,xoffset,yoffset,sizecolomn,sizerow]= load_data(shot,camind,settings,ROI_pars);
    end
end

ROI_pars.imsize= [sizerow sizecolomn];
ROI_pars.inversion=settings.inversion;
%% Create Image vector
nind = length(indices);

% construct image vector by reading a raw-column major matlab image
% column-wise (same as openCV::mat reading row-wise)
image_in = reshape(permute(cam_images,[3 1 2]),nind,sizecolomn*sizerow);
imsize = size(cam_images(:,:,1)); % (i,j) convention;
%% Generate figure
g3 = figure('color','white');
h2 = multiaxes(g3,5,1,[0.00 0.00],[0.00 0.00],[0.00 0]);
set(gcf,'Position', [500 200 1200 300])




h2(1).YDir = 'reverse';
%set sizes
h2(1).Position =  [0       0.15   0.300    0.800];
h2(2).Position =  [ 0.3   0.15    0.25  0.7];
h2(3).Position =  [0.605   0.15    0.2    0.4];
h2(4).Position =  [0.605   0.55    0.2    0.4];
h2(5).Position =  [ 0.85    0.15   0.1   0.8];
hold(h2(1),'on')
hold(h2(2),'on')
hold(h2(3),'on')
hold(h2(4),'on')
xticklabels(h2(4),[])
box(h2(3),'on')
box(h2(4),'on')
box(h2(5),'on')

cmp = get(groot,'DefaultAxesColorOrder');
set(0,'defaultTextInterpreter','latex'); %trying to set the default

%add letter
if strcmp(filename,'fd_47998_FB_50_ref_47980')
    letter='a';
else
    letter='f';
end
text(h2(1),0.01,0.05,strcat('\textbf{',letter,'}'),'Units','Normalized','Interpreter','Latex','HorizontalAlignment','left','Fontsize',14,'Color','w')

%% Lpol result
ltrace=plot(h2(4),DC.lpol.time,DC.lpol.u,'LineWidth',1,'Color','r');
reftrace=plot(h2(4),DC.det_lpol_ref.time,DC.det_lpol_ref.u,'--','LineWidth',2,'color','k');

xlim(h2(4),tspan)

%set limits
if strcmp(filename,'fd_47998_FB_50_ref_47980') %for ECD
    h2(4).YLim = [0.08 0.4];
else %for SXD
    h2(4).YLim = [0.32 0.5];
end

% l4=plot(h2(4),DC.lpol.time(iiPCS),DC.lpol.u(iiPCS),'LineStyle','none','Marker','x','MarkerSize',16,'color','red','LineWidth',3);
if strcmp(filename,'fd_47998_FB_50_ref_47980') %for ECD
        legend(h2(4),[ltrace,reftrace],{'data','ref'},'Interpreter','latex',FontSize=12,Units='normalized',Position=[0.61,0.79,0.0684,0.143])
else %for SXD
    legend(h2(4),[ltrace,reftrace],{'data','ref'},'Interpreter','latex',FontSize=12,Units='normalized',Position=[0.75,0.845,0.0684,0.143])
end
xlim(h2(4),[settings.tspan]);
yLimits = get(h2,'YLim');
ymax=max(yLimits{3});
ymin=min(yLimits{3});
dy=abs(ymax-ymin);
xLimits = get(h2,'XLim');
xmax=max(xLimits{3});
xmin=min(xLimits{3});
dx=abs(xmax-xmin);
h2(4).YAxis.FontSize = 12;

ylabel(h2(4),'$\mathrm{L}_{\mathrm{tar}}$ [m]','Interpreter','latex',FontSize=14)
h2(4).XTick=[   0.4000    0.5000    0.6000    0.7000    0.8000];

%add letter
if strcmp(filename,'fd_47998_FB_50_ref_47980')
    letter='c';
else
    letter='h';
end
text(h2(4),0.02,0.1,strcat('\textbf{',letter,'}'),'Units','Normalized','Interpreter','Latex','HorizontalAlignment','left','Fontsize',14,'Color','k')
%% plot fuelling
% GV=getGas(shot,"LFSV_BOT_L09",'valve_spec','flowrate','valve_pressure',750,'take_requested_from_measured',0);

plot(h2(3),DC.u_fb.time,DC.u_fb.u*1e21,'Color',[57,87,163]/256,'linewidth',2,'LineStyle','-.')
xlim(h2(3),tspan)
h2(3).YLim = [0,h2(3).YLim(2)*1.1];
%change exponent location
h2(3).YRuler.SecondaryLabel.Units='normalized';
h2(3).YRuler.SecondaryLabel.Position=[0.03,0.8,0];
%set labels
xlabel(h2(3),'time [s]','Interpreter','Latex',FontSize=14)
h2(3).XTick=[   0.4000    0.5000    0.6000    0.7000    0.8000];
h2(3).XLabel.Units='normalized';
h2(3).XAxis.FontSize = 12;
h2(3).YAxis.FontSize = 12;
h2(3).XLabel.Position=[0.87    0.18   0];
ylabel(h2(3),'Flowrate $[\mathrm{s}^{-1}]$','Interpreter','latex',FontSize=14)
%add letter
if strcmp(filename,'fd_47998_FB_50_ref_47980')
    letter='d';
else
    letter='i';
end
text(h2(3),0.02,0.1,strcat('\textbf{',letter,'}'),'Units','Normalized','Interpreter','Latex','HorizontalAlignment','left','Fontsize',14,'Color','k')
%% plot NBI and density
[IF] = getIF(shot);
% [NBI] =  getNBI(shot);
% NBImanual.time=[0,1];
% NBImanual.data=[1.45,1.45];%SW
% yyaxis left
plot(h2(5),IF.time,IF.ne,'-',Linewidth=1)
ylabel('$\mathrm{n}_\mathrm{e}$ [$\mathrm{m}^{-2}$]','Interpreter','Latex',FontSize=14)
h2(5).YLabel.Units='normalized';
% yyaxis right
% plot(h2(5),NBImanual.time,NBImanual.data,'-',Linewidth=2)
% ylabel('NBI [MW]',FontSize=14)
xlim(tspan)
xlabel('time [s]','Interpreter','Latex',FontSize=14)
h2(5).XLabel.Units='normalized';
h2(5).XAxis.FontSize = 12;
h2(5).YLabel.Units='normalized';
h2(5).YAxis(1).FontSize = 12;
% h2(5).YAxis(2).FontSize = 12;
h2(5).XLabel.Position=[0.75    0.09   0];
%change exponent location
h2(5).YRuler.SecondaryLabel.Units='normalized';
h2(5).YRuler.SecondaryLabel.Position=[0.03,0.9,0];
%add letter
if strcmp(filename,'fd_47998_FB_50_ref_47980')
    letter='e';
else
    letter='j';
end
text(h2(5),0.03,0.05,strcat('\textbf{',letter,'}'),'Units','Normalized','Interpreter','Latex','HorizontalAlignment','left','Fontsize',14,'Color','k')
%% plot coils
[~] = plot_MAST_coils(h2(2),vessel_path,'div');
h2(2).XDir = 'reverse';


%% Plot image
im = reshape(image_in(ii,:),[ROI_pars.imsize(1) ROI_pars.imsize(2)]);

fStruct.ind = a.ind(ii);
fStruct.qual = a.qual(ii);

if ROI_pars.discardtarget
    gif_plot(settings,im,a.x(ii,1:a.size(ii)),a.y(ii,1:a.size(ii)),fStruct,ROI_pars,h2,a.max(ii),a.isnottarget(ii,1:a.size(ii)),a.nclust(ii));
else
    gif_plot(settings,im,a.x(ii,1:a.size(ii)),a.y(ii,1:a.size(ii)),fStruct,ROI_pars,h2,a.max(ii));
end
daspect(h2(1),[1 1 1]);
%set limits
if strcmp(filename,'fd_47998_FB_50_ref_47980') %for ECD
    h2(1).XLim = [30 450];
    h2(1).YLim = [1 300];
else %for SXD
    h2(1).XLim = [30 450];
    h2(1).YLim = [1 300];
end



%% plot EFIT figure
[c1,c2]=plotefit(h2(2),efit,plottime,1);
daspect(h2(2),[1 1 1]);
h2(2).YLim = [-2.2 -1.38];
h2(2).XLim = [-1.75 -0.6 ];
h2(2).XAxis.Visible='off';h2(2).YAxis.Visible='off';

l1 = line(-a.Rf_edge(ii,1:a.size(ii)),a.Zf_edge(ii,1:a.size(ii)),'parent',h2(2),'LineStyle','none','color',cmp(2,:),'Marker','.');
l2 = line(-a.Rf(ii),a.Zf(ii),'parent',h2(2),'LineStyle','none','Marker','x','MarkerSize',16,'color','red','LineWidth',3);
if ROI_pars.discardtarget
    l3 = line(-a.Rf_edge(ii,a.isnottarget(ii,1:a.size(ii))==0),a.Zf_edge(ii,a.isnottarget(ii,1:a.size(ii))==0),'parent',h2(2),'LineStyle','none','color','black','Marker','.');
end


if ~settings.inversion
    %to plot ROI edge in pol plane
    %         line(h2(2),-[ROI_pars.limit.R_center,ROI_pars.limit.R_center],[ROI_pars.limit.Z_center-0.1,ROI_pars.limit.Z_center+0.3],'LineStyle','--','Marker','none','Color','red');
end
set(h2(2),'XTick',[], 'YTick', [])
title(h2(2),strcat('\textbf{MAST-U \#}','\boldmath{$',num2str(shot),'$ $',' \textbf{t}=',num2str(a.tout(ii)),'\textbf{s}$}'));

%Add Lpol indicator
if strcmp(filename,'fd_47998_FB_50_ref_47980') %for ECD
    x = [-1.04,-1.13,-1.16];
    y = [-1.88,-2,-2.05];
    ytext=y(2)+0.05;
    xtext=x(2)-0.06;
else
   x = [-1.08,-1.30,-1.48];
   y = [-1.84,-1.92,-1.905];
   ytext=y(2)+0.05;
   xtext=x(2);
end
xq=linspace(x(1),x(end),50);
yq = spline(x,y,xq); 
arrow1 = plot(h2(2),xq',yq');
arrow2 = plot(h2(2),flip(xq'),flip(yq'));
set(g3, 'CurrentAxes', h2(2))
line2arrow(arrow1);line2arrow(arrow2);
set(arrow1, 'color', 'r', 'linewidth', 1);
set(arrow2, 'color', 'r', 'linewidth', 1);
text(h2(2),xtext,ytext,'$\mathrm{L}_{\mathrm{tar}}$','Interpreter','Latex','HorizontalAlignment','center','Fontsize',14,'Color','r')

%add letter
if strcmp(filename,'fd_47998_FB_50_ref_47980')
    letter='b';
else
    letter='g';
end

text(h2(2),0,0.05,strcat('\textbf{',letter,'}'),'Units','Normalized','Interpreter','Latex','HorizontalAlignment','left','Fontsize',14,'Color','k')
%% set painters     
set(gcf, 'Renderer', 'painters');










