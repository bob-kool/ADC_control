function [f,h] = makelinesfigure_base(labels,plotsettings,shot)
%% Create empty figure base
f=figure('color','w');
f.Position=[100,430,780,580];

%% Generate subplots
%upper figure
h(1) = subplot(2,1,1); grid on; hold on; box on; legend;
yyaxis(h(1),'right')
h(1).YAxis(2).Color = 'r';
yyaxis(h(1),'left')
h(1).YAxis(1).Color = 'k';
set(h(1),'XMinorTick','on','YMinorTick','on')
set(h(1),'xminorgrid','on','yminorgrid','on')
legend('orientation','vertical')
legend('location','northeast')

%lower figure
h(2) = subplot(2,1,2); grid on; hold on; box on;
set(gca,'Yscale','Log')
set(h(2),'XMinorTick','on','YMinorTick','on')
set(h(2),'xminorgrid','on','yminorgrid','on')
yticks(h(2),10.^(-30:30));


%reposition subplots
h(1).Position=h(1).Position+[-0.01  0.01    0 0];
h(2).Position=h(2).Position+[-0.01  0 0 0];

%set fontsize
set(h,'FontSize',16)
%% Labels
%upper figure
yyaxis(h(1),'right')
ylabel(h(1),strcat('$',labels.output,'[',labels.outputunits,']$'))
yyaxis(h(1),'left')
ylabel(h(1),strcat('$',labels.input,'[',labels.inputunits,']$'))
xlabel(h(1),'Time [s]')

%lower figure
ylabel(h(2),strcat('$|',labels.output,'(f)|','[',labels.outputunits,']$'))
xlabel(h(2),'Frequency [Hz]')

%% Generate Title
title(h(1),strcat('MAST-U \#',num2str(shot)))
%% Set limits as specified
xlim(h(2),plotsettings.freqrange_lines)