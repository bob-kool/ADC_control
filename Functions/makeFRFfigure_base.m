function [f,h] = makeFRFfigure_base(labels,plotsettings,varargin)

%% Determine if shot is specified for title
if nargin>2
    shot=varargin{1};
end

%% Create empty figure base
f=figure('color','w');
f.Position=[100,430,780,580];

%% Generate subplots
%upper figure
h(1) = subplot(2,1,1); grid on; hold on; box on;
set(gca,'Yscale','log')
set(gca,'Xscale',plotsettings.xscale)
set(h(1),'XMinorTick','on','YMinorTick','on')
set(h(1),'xminorgrid','on','yminorgrid','on')
yticks(h(1),10.^(-30:30));
%lower figure
h(2) = subplot(2,1,2); grid on; hold on; box on;
set(gca,'Xscale',plotsettings.xscale)
set(h(2),'XMinorTick','on','YMinorTick','on')
set(h(2),'xminorgrid','on','yminorgrid','on')

%reposition subplots
h(1).Position=h(1).Position+[0.04 0 0 0.017];
h(2).Position=h(2).Position+[0.04 0.025 0 0.017];

%link the axis
linkaxes([h(1),h(2)],'x');

%set fontsize
set(h,'FontSize',16)
%% Labels
%upper figure
ylabel(h(1),strcat('$|\frac{',labels.output,'(\mathrm{f})','}{',labels.input,'(\mathrm{f})','}|','[\frac{',labels.outputunits,'}{',labels.inputunits,'}$]'))

%lower figure
ylabel(h(2),strcat('$\angle','\frac{',labels.output,'(\mathrm{f})','}{',labels.input,'(\mathrm{f})','}$[deg]'))
if isfield(plotsettings,'xlabel')
    xlabel(h(2),plotsettings.xlabel);
else
    xlabel(h(2),'Frequency [Hz]')
end
%% Generate Title
if nargin>2
    title(h(1),strcat('MAST-U \#',num2str(shot)))
end
if isfield(plotsettings, "title")
    title(h(1), plotsettings.title);
end
%% Set limits as specified
xlim(h(2),plotsettings.freqrange_FRF)
ylim(h(2),plotsettings.phaserange)
end

