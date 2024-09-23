%% Start clean
clc; close all; clearvars;set_Latex_for_all
%% import
[img, map, alphachannel] = imread('49297_550ms.png');
%% plot figure
R_lim = [0.4,1.8];
Z_lim = [0,-2.1];
        
f1=figure;
image(img,'AlphaData', alphachannel,'xdata',R_lim,'ydata',Z_lim);
set(gca,'YDir','normal')
axis('image')
f1.Renderer='painters';
%% change labels
xlabel('R [m]',Fontsize=10,Position=[1.100000646852365,-2.183858891063147,1])
ylabel('Z [m]',Fontsize=10,Position=[0.275753286574615,-1.755218173201083,1])
ylim([-2.105,-1.4])
%% colourbar
colormap hot
c=colorbar;
caxis([0e19 1e19]);
c.Label.Interpreter='Latex';
c.Label.String = '$\epsilon \ [\mathrm{ph}/(\mathrm{m}^3\ \mathrm{sr} \ \mathrm{s})]$';
c.Label.Position=[1.831748489727975,5000004768371582000,0]; 
c.Label.FontSize=10;
%% scale text
fontsize(gcf,scale=1.2)
%% set size
f1.Position=[680 667 560 262];

%% Add letter
text(f1.Children(2),0,0,strcat('\textbf{','b','}'),Units='normalized',FontSize=20,Position=[-0.319290758662899,1.033132561713426,0])


%% import
[img, map, alphachannel] = imread('49298_550ms.png');
%% plot figure
R_lim = [0.4,1.8];
Z_lim = [0,-2.1];
        
f1=figure;
image(img,'AlphaData', alphachannel,'xdata',R_lim,'ydata',Z_lim);
set(gca,'YDir','normal')
axis('image')
f1.Renderer='painters';
%% change labels
xlabel('R [m]',Fontsize=10,Position=[1.100000646852365,-2.183858891063147,1])
ylabel('Z [m]',Fontsize=10,Position=[0.275753286574615,-1.755218173201083,1])
ylim([-2.105,-1.4])
%% colourbar
colormap hot
c=colorbar;
caxis([0e19 1e19]);
c.Label.Interpreter='Latex';
c.Label.String = '$\epsilon \ [\mathrm{ph}/(\mathrm{m}^3\ \mathrm{sr} \ \mathrm{s})]$';
c.Label.Position=[1.831748489727975,5000004768371582000,0]; 
c.Label.FontSize=10;
%% scale text
fontsize(gcf,scale=1.2)
%% set size
f1.Position=[680 667 560 262];

%% Add letter
text(f1.Children(2),0,0,strcat('\textbf{','b','}'),Units='normalized',FontSize=20,Position=[-0.319290758662899,1.033132561713426,0])
