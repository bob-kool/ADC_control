function [h] = plot_MAST_coils(h,vessel_path,type,varargin)

% function to plot MAST vessel envelope, coils etc in Poloidal plane
% following the MAST-U coordinate convention

% inputs: vessel_path: string of path where the mat files containing the
% vessel structure are located
% equil: FIESTA LCFS on grid
% type: choose 'full' or 'div' to switch between full vessel or just the
% Divertor

if nargin>3
    rhs=varargin{1};
else
    rhs=false;
end

% import official mast-u efit files

coils = load(strcat(vessel_path,'/coil_simplified_imported.mat'));
vessel = load(strcat(vessel_path,'/passive_imported.mat'));

limiter = load(strcat(vessel_path,'/limiter_imported.mat'));


% get coil vertices
[rrcoils, zzcoils] = get_vertices(coils.centreR,coils.centreZ,coils.dR,coils.dZ,coils.angle1,coils.angle2);

% get vessel vertices
[rrvessel, zzvessel] = ...
                get_vertices(vessel.centreR,vessel.centreZ,vessel.dR,vessel.dZ,vessel.angle1,vessel.angle2);



%% plot            
scrsz = get(0,'ScreenSize');

% colormap
cmp = get(groot,'DefaultAxesColorOrder');

% coils
if rhs
    cp = patch(h,rrcoils,zzcoils,'red');
else
    cp = patch(h,-rrcoils,zzcoils,'red');
end
cp.FaceColor = ones(3,1); % white
cp.EdgeColor =[128,128,128]./225;

% vessel
if rhs
    vp = patch(h,rrvessel,zzvessel,'blue');
else
    vp = patch(h,-rrvessel,zzvessel,'blue');
end
vp.FaceColor = ones(3,1); % white
vp.EdgeColor =[128,128,128]./225;
% limiter
if rhs
    l=line(limiter.R,limiter.Z,'color',zeros(1,3),'parent',h);
else
    l=line(-limiter.R,limiter.Z,'color',zeros(1,3),'parent',h);
end
% line(-equil.R,equil.Z,'LineStyle','-','color','k','LineWidth',1,'parent',h);

set(h,'FontSize',13)
% xlabel(h,'R (m)');
% labelff(h,'Z (m)','y');

switch type
    
    case 'full'
        % do nothing
        axis equal;
    case 'div'
        xmin = min(min(-rrvessel));
        xmax = 0;
        h.YLim = [min(min(zzvessel)) -1.3];
        h.XLim = [xmin xmax];
        pbaspect(h,[1 abs((h.YLim(1)-h.YLim(2))/(h.XLim(1)-h.XLim(2))) 1])
        
end
%turn of legend
set(get(get(cp,'Annotation'),'LegendInformation'),...
    'IconDisplayStyle','off');

set(get(get(vp,'Annotation'),'LegendInformation'),...
    'IconDisplayStyle','off');
set(get(get(l,'Annotation'),'LegendInformation'),...
    'IconDisplayStyle','off');
