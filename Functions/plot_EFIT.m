function h = plot_EFIT(h,EFIT,time,varargin)
%PLOT_EFIT Plot magnetic equilibrium on given axis
%   Required arguments:
%       h: axis object
%       efit: efit data as returned by getEFIT(shot,'')
%       time: point in time to plot
%   Optional arguments:
%       color: line color
%       lw: line width

%% Parse input
p = inputParser;
p.addOptional('color','blue');
p.addOptional('lw',1);
p.parse(varargin{:})
color = p.Results.color;
lw = p.Results.lw;

%% Plot equilibrium
grid(h,'off')
[~,idx_EFIT] = min(abs(time-EFIT.time));

% draw magnetic equilibrium lines
current_psi = squeeze(EFIT.psi(idx_EFIT,:,:));
min_psi = min(current_psi,[],'all');
max_psi = max(current_psi,[],'all');
draw_psi = linspace(min_psi,0.999*max_psi,20);

for m = draw_psi
    level =[m m];
    contour(h,EFIT.R, EFIT.Z, squeeze(EFIT.psi(idx_EFIT,:,:))',level, Color=color);
end

% draw the separatrix
level = [EFIT.psi_bound(idx_EFIT) EFIT.psi_bound(idx_EFIT)]; %we have to specify it like this due to matlab syntax

% [~,c2] = contour(h,-EFIT.R, EFIT.Z, squeeze(EFIT.psi(idx_EFIT,:,:))',level,'Color',);
% c2.LineWidth = lw;
vessel_path='/Differ/Data/MAST-U//MAST-Uvessel';
limiter = load(strcat(vessel_path,'/limiter_imported.mat'));
[C]=contourc(EFIT.R, EFIT.Z, squeeze(EFIT.psi(idx_EFIT,:,:))',level);
[TFin,TFon]=isinterior(polyshape(limiter.R,limiter.Z),C(1,:),C(2,:));
C(1,~or(TFin,TFon))=nan;
C(2,~or(TFin,TFon))=nan;
plot(h,C(1,:),C(2,:),Color=color,LineWidth=lw);


end

