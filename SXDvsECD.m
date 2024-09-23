%% Start clean
clearvars;clc;close all
%% Define plotcolors
colorlist{1}="#4DBEEE";
colorlist{2}="#EDB120";
colorlist{3}="#D95319";
colorlist{4}="#7E2F8E";
colorlist{5}="#77AC30";
colorlist{6}="#0072BD";
%% Settings
settings.fittime=0.6;%specify efit time
tspan=[0.5,0.8];
%% Filelocations
cf=fileparts(which('main.m'));
addpath(genpath(cf));

vessel_path='/Differ/Data/MAST-U//MAST-Uvessel';
addpath(genpath('/Differ/Data/MAST-U/'));

savefitfolder='/Differ/Data/MAST-U//MWI/fronttracking/fitdata';
saveROIfolder='/Differ/Data/MAST-U//MWI/fronttracking/ROIdata';
savedatafolder='/Differ/Data/MAST-U//MWI/fronttracking/frontdata';
savegiffolder='/Differ/Data/MAST-U//MWI/fronttracking/gifs';

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% ECD vs SXD distance                %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
shotlist=[47086,47116,49303];
CDoutofviewtime=0.62;
legendlist={'47086 ED','47116 SXD','49303 CD'};
linelist={'-','-','-'};
%% Define plotcolors
colorlist{1}=[230,130,0]/256 ;
colorlist{2}=[69,133,136]/256;
colorlist{3}=[94,179,5]/256;

%% Make figure
set_Latex_for_all
fig2 = figure('color','white');
h = multiaxes(fig2,1,4,[0.13 0.1],[0.01 0.25],[0 0]);
set(fig2,'Position', [500 100 480 780])
% h(4).Position=[0.1271    0.0706    0.8167    0.2928];
h(4).Position=[0.1292    0.0507    0.8229    0.3183];

hold(h(1),'on')
hold(h(2),'on')
hold(h(3),'on')
hold(h(4),'on')
linkaxes([h(1),h(2),h(3)],'x')

xlabel(h(3),'Time [s]')
xlabel(h(4),'R [m]')

ylabel(h(4),'Z [m]')
ylabel(h(3),'Flowrate [$10^{21}\ \mathrm{s}^{-1}$]','Position',[0.484936920908121,1.301727714209723,-0.999999999999993])
ylabel(h(2),'$\mathrm{L}_{\mathrm{x}}$ [m]')
ylabel(h(2),'$\mathrm{L}_{\mathrm{x}}$ [m]')


ylabel(h(1),'$\mathrm{L}_{\mathrm{tar}}$ [m]')

fontsize=13;
h(1).FontSize=fontsize;
h(2).FontSize=fontsize;
h(3).FontSize=fontsize;
h(4).FontSize=fontsize;

xticklabels(h(1),'')
xticklabels(h(2),'')

xticks(h(1),[0:0.1:1])
xticks(h(2),[0:0.1:1])
xticks(h(3),[0:0.1:1])

box(h(1),'on')
box(h(2),'on')
box(h(3),'on')
box(h(4),'on')
%% set painters
set(fig2, 'Renderer', 'painters');
%% plot rhs coils
[coils] = plot_MAST_coils(h(4),vessel_path,'div','rhs');
h2(2).XDir = 'reverse';
%% loop over shots
for ii=1:length(shotlist)
    %% Load data
    shot=shotlist(ii);
%     filename=strcat('fd_',num2str(shot),'_FB_50');
%     load(filename)
%    if shot==47116
%         fd.L(fd.L<0.3) = NaN;
%         fd.L = fillmissing(fd.L,'linear');
%     end
    if shot==47086 || shot==47116
        filename=strcat('fd_',num2str(shot),'_FB_50_MWI');
    else
        filename=strcat('fd_',num2str(shot),'_FB_50_dual');
    end
    [fd_inv] = getLpol_inv(filename);
    if shot == 49303
        CDoutofviewindex=fd_inv.tout>CDoutofviewtime;    
        fd_inv.L(CDoutofviewindex)=NaN;
        fd_inv.Lx(CDoutofviewindex)=NaN;
        fd_inv.RZ(:,CDoutofviewindex)=nan(2,sum(CDoutofviewindex));
    end
    %interpolation to get rid of faulty target detection s
    if shot == 47086
               disp('Limits applied to fd, replacing detected points through interpolation, are you sure?')
               idxremoveL=fd_inv.L<0.09;
               fd_inv.L(idxremoveL)=NaN;
               fd_inv.L = fillmissing(fd_inv.L,'linear');
               idxremoveLx=fd_inv.Lx>1.05;
               fd_inv.Lx(idxremoveLx) = NaN;
               fd_inv.Lx = fillmissing(fd_inv.Lx,'linear');
               fd_inv.RZ(:,idxremoveL|idxremoveLx) = NaN;
               fd_inv.RZ = fillmissing(fd_inv.RZ,'linear');
    end

%     camind = getcamind(shot,settings.specline);
        GV=getGas(shot,"LFSV_BOT_L09",'valve_spec','flowrate','valve_pressure',750,'calculate_flowrate',1,'take_requested_from_measured',2);
    %47116 does not reach target, is error in tracking
 
    %% Plotting    
%     plot(h(1),fd.tout,fd.L,linelist{ii},LineWidth=2,Color=colorlist{ii})
%     plot(h(2),fd.tout,fd.Lx,linelist{ii},LineWidth=2,Color=colorlist{ii})
    plot(h(1),fd_inv.tout,fd_inv.L,linelist{ii},LineWidth=2,Color=colorlist{ii})
%     if shot == 49303
%         yyaxis(h(2),'right')
%     end
    plot(h(2),fd_inv.tout,fd_inv.Lx,linelist{ii},LineWidth=2,Color=colorlist{ii})
    plot(h(3),GV.LFSV_BOT_L09.time,GV.LFSV_BOT_L09.u*1e-21,linelist{ii},Color=colorlist{ii},linewidth=2,linestyle='-.')
    %% load equilibrium
    efit = getEFIT(shot,'reduced');
    %% get index of closest timepoint
    [~,idx_efit] = min(abs(settings.fittime-efit.time));
    %% plot at timepoint
    vessel_path='/Differ/Data/MAST-U//MAST-Uvessel';
    limiter = load(strcat(vessel_path,'/limiter_imported.mat'));
    axis('equal')
    l=line(limiter.R,limiter.Z,'color',zeros(1,3));
    hold on
    level= [efit.psi_bound(idx_efit) efit.psi_bound(idx_efit)]; %we have to specify it like this due to matlab syntax
    %     idx_in= inpolygon(efit.R,efit.Z,-limiter.R,limiter.Z);
    %     R_leg=R_leg(idx_in);
    %     Z_leg=Z_leg(idx_in);

    %     [C,c]=contour(h(4),-efit.R, efit.Z, squeeze(efit.psi(idx_efit,:,:))',level,'EdgeColor','#4DBEEE');
%     [C,c]=contour(h(4),-efit.R, efit.Z, squeeze(efit.psi(idx_efit,:,:))',level,'EdgeColor',colorlist{ii});
    
    %discard outside vessel wall
    [C]=contourc(efit.R, efit.Z, squeeze(efit.psi(idx_efit,:,:))',level);
    [TFin,TFon]=isinterior(polyshape(limiter.R,limiter.Z),C(1,:),C(2,:));
    C(1,~or(TFin,TFon))=nan;
    C(2,~or(TFin,TFon))=nan;
    plot(h(4),C(1,:),C(2,:),color=colorlist{ii},LineWidth=1);

    hold(h(4),'on')
%     lower=plot(efit.xpoint_lower_r(idx_efit),efit.xpoint_lower_z(idx_efit),'*','MarkerEdgeColor','#4DBEEE','MarkerFaceColor','#4DBEEE');
%     upper=plot(efit.xpoint_upper_r(idx_efit),efit.xpoint_upper_z(idx_efit),'*','MarkerEdgeColor','#4DBEEE','MarkerFaceColor','#4DBEEE');

    %% Plot front positons inverted
    [~,time_idx_0] = min(abs(tspan(1)-fd_inv.tout));
    [~,time_idx_1] = min(abs(tspan(2)-fd_inv.tout));

    RZ=fd_inv.RZ;
    fronthandles(ii)=scatter(h(4),RZ(1,[time_idx_0:time_idx_1]),RZ(2,[time_idx_0:time_idx_1]),"o","filled",'Linewidth',4,'MarkerFaceAlpha',0.2,'MarkerEdgeAlpha',0.2,MarkerEdgeColor=colorlist{ii},MarkerFaceColor=colorlist{ii});

    %% Plot front positons raw
%     [~,time_idx_0] = min(abs(tspan(1)-fd.tout));
%     [~,time_idx_1] = min(abs(tspan(2)-fd.tout));
% 
%     %loop over front positions to get position along leg
%     frontRZalongleg=NaN(length(fd.tout),2);
%     for idx=time_idx_0:time_idx_1
%         L=fd.L(idx);
%         idx_nearest=dsearchn_local([xpointlegfit.R,xpointlegfit.Z],[fd.Rf(idx),fd.Zf(idx)]);
%         frontRZalongleg(idx,:)=[xpointlegfit.R(idx_nearest),xpointlegfit.Z(idx_nearest)];
%     end
% 
%     fronthandles(ii)=scatter(h(4),-frontRZalongleg([time_idx_0:time_idx_1],1),frontRZalongleg([time_idx_0:time_idx_1],2),"o","filled",'Linewidth',4,'MarkerFaceAlpha',0.2,'MarkerEdgeAlpha',0.2,MarkerEdgeColor=colorlist{ii},MarkerFaceColor=colorlist{ii});

    %% Plot density
    [IF_LA] = getIF_LA(shot);
    yyaxis(h(3),'right') 
    plot(h(3),IF_LA.time,IF_LA.ne*1e-19,'-',color=colorlist{ii},LineWidth=1)
    h(3).YAxis(2).Color='k';
    ylabel(h(3),'$\langle\mathrm{n}_\mathrm{e}\rangle\  [10^{19}\ \mathrm{m}^{-3}]$','Interpreter','Latex')
    yyaxis(h(3),'left') 
end
%% Add legend
legendhandles(1)= plot(h(4),nan, nan, '-',Color=colorlist{1},LineWidth=2);
legendhandles(2)= plot(h(4),nan, nan, '-',Color=colorlist{2},LineWidth=2);
legendhandles(3)= plot(h(4),nan, nan, '-',Color=colorlist{3},LineWidth=2);

legend(h(4),legendhandles,legendlist)
%% Add grid
grid(h(1),'on')
grid(h(2),'on')
grid(h(3),'on')



%% Set limits
ylim(h(1),[0,0.55])
ylim(h(2),[0.3,1.08])
% yyaxis(h(2),'left') 
% ylim(h(2),[0.76,1.03])
% range=1.03-0.76;
% yyaxis(h(2),'right') 
% ylim(h(2),[0.36,0.36+range])
yyaxis(h(3),'left') 
ylim(h(3),[-5,10])
yyaxis(h(3),'right') 
ylim(h(3),[2,8])

axis(h(4),'equal')

ylim(h(4),[-2.1,-1])
xlim(h(4),[0.25,2])

% xlim(h(3),[0.4,0.9])
xlim(h(3),tspan)
h(4).XLabel.Position=[1.124999165534974,-2.185456891976377,-1];
%% Add front definition arrows
%Add Ltar indicator
x = [1.08,1.30,1.48];
y = [-1.84,-1.92,-1.905];
ytext=y(2)+0.08;
xtext=x(2);

xq=linspace(x(1),x(end),50);
yq = spline(x,y,xq); 
arrow1 = plot(h(4),xq',yq', 'HandleVisibility', 'off' );
arrow2 = plot(h(4),flip(xq'),flip(yq'), 'HandleVisibility', 'off' );
set(fig2, 'CurrentAxes', h(4))
drawnow
line2arrow(arrow1);line2arrow(arrow2);
set(arrow1, 'color', 'k', 'linewidth', 1);
set(arrow2, 'color', 'k', 'linewidth', 1);
text(h(4),xtext,ytext,'$\mathrm{L}_{\mathrm{tar}}$','Interpreter','Latex','HorizontalAlignment','center','Fontsize',14)

%Add Lx indicator
x = [0.97,0.71,0.64];
y = [-1.78,-1.35,-1.11];
ytext=y(2)+0.08;
xtext=x(2)+0.06;

xq=linspace(x(1),x(end),50);
yq = spline(x,y,xq); 
arrow1 = plot(h(4),xq',yq', 'HandleVisibility', 'off' );
arrow2 = plot(h(4),flip(xq'),flip(yq'), 'HandleVisibility', 'off' );
set(fig2, 'CurrentAxes', h(4))
line2arrow(arrow1);line2arrow(arrow2);
set(arrow1, 'color', 'k', 'linewidth', 1);
set(arrow2, 'color', 'k', 'linewidth', 1);
text(h(4),xtext,ytext,'$\mathrm{L}_{\mathrm{x}}$','Interpreter','Latex','HorizontalAlignment','center','Fontsize',14)

%% Add letter
text(h(1),0,0,'\textbf{a}',Units='normalized',FontSize=20,Position=[-0.15,1.01,0])
text(h(2),0,0,'\textbf{b}',Units='normalized',FontSize=20,Position=[-0.15,0.97,0])
text(h(3),0,0,'\textbf{c}',Units='normalized',FontSize=20,Position=[-0.15,0.97,0])
text(h(4),0,0,'\textbf{d}',Units='normalized',FontSize=20,Position=[-0.15,0.97,0])

%% Add CD out of view indicator
text(h(1),0.627432432432432,0.320625,0,'\textbf{Front above X-point}','Interpreter','latex','Color',colorlist{3},'FontSize',14)
text(h(2),0.633108108108108,0.67,0,'\textbf{Front above X-point}','Interpreter','latex','Color',colorlist{3},'FontSize',14)

x = [0.67,0.623];
y = [0.28,0.17];
xq=linspace(x(1),x(end),50);
yq = spline(x,y,xq); 
arrow1 = plot(h(1),xq',yq', 'HandleVisibility', 'off' );
set(fig2, 'CurrentAxes', h(1))
line2arrow(arrow1);%line2arrow(arrow2);
set(arrow1, 'color', colorlist{3}, 'linewidth', 2,'Clipping','off');

x = [0.67,0.623];
y = [0.6,0.42];
xq=linspace(x(1),x(end),50);
yq = spline(x,y,xq); 
arrow1 = plot(h(2),xq',yq', 'HandleVisibility', 'off' );
set(fig2, 'CurrentAxes', h(2))
line2arrow(arrow1);%line2arrow(arrow2);
set(arrow1, 'color', colorlist{3}, 'linewidth', 2,'Clipping','off');

%for 2D view
x = [0.58,0.48];
y = [-1.4,-0.97];
ytext=y(2)+0.04;
xtext=x(2)-0.03;

xq=linspace(x(1),x(end),50);
yq = spline(x,y,xq); 
arrow1 = plot(h(4),xq',yq', 'HandleVisibility', 'off' );
set(fig2, 'CurrentAxes', h(4))
line2arrow(arrow1);%line2arrow(arrow2);
set(arrow1, 'color', colorlist{3}, 'linewidth', 2,'Clipping','off');
text(h(4),xtext,ytext,'\textbf{Front above X-point}','Interpreter','Latex','HorizontalAlignment','center','Fontsize',14,'Color',colorlist{3})

%% change plotting order
% oldorder=h(1).Children;
% h(1).Children=[oldorder(3:end);oldorder(1:2)];