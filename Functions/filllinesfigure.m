function [h] = filllinesfigure(h,plotsettings,uc,yc,Ydet,Yp,f_exc,sigma_noise,LPMtimedomain)
%% Fill data
%upper figure
yyaxis(h(1),'left')
plot(h(1),uc.time,uc.data,'k','LineWidth',2,'Displayname','Input')
yyaxis(h(1),'right')
plot(h(1),yc.time,yc.data,'-','LineWidth',2,'Color', [0.5 0.5 0.5],'Displayname','Output')
plot(h(1),yc.time,yc.data_detrend+mean(yc.data),'r','LineWidth',2,'Displayname','Output detrend')
hold(h(1),'on')
plot(h(1),LPMtimedomain.time,LPMtimedomain.data,'-','Color','g','LineWidth',2,'Displayname','LPM result')
%lower figure
a2=stem(h(2),Ydet.freq,abs(Ydet.data1),'r-','LineWidth',2,'Displayname','DFT');
a3=stem(h(2),f_exc,abs(Yp.out),'-','LineWidth',2,'Displayname','LPM','Color',	[0, 0.5, 0]);

%% Give SNR
a4=stem(h(2),f_exc,sigma_noise,'-','LineWidth',2,'Displayname','$\sigma_{\mathrm{noise}}$','Color','b');

%% Set limits as specified
%Upper plot
xlim(h(1),[min(uc.time) max(uc.time)])
yyaxis(h(1),'left')
ylim(h(1),[min(uc.data),max(uc.data)])
yyaxis(h(1),'right')
ylim(h(1),[min(min(yc.data),min(yc.data_detrend+mean(yc.data))),max(max(yc.data),max(yc.data_detrend+mean(yc.data)))])
%lower plot
ylim(h(2),[min(abs(Ydet.data1(2:max(find(Ydet.freq<max(h(2).XLim))))))/3,max(abs(Ydet.data1(1:max(find(Ydet.freq<max(h(2).XLim))))))*3]) ;

%% Add perturbed frequencies
%lines
for ii = 1:length(f_exc)
    a1=stem(h(2),[f_exc(ii),f_exc(ii)],[10^(-100) +10^(100)],'--k','LineWidth',2,'Displayname','Excited');
    set(a1, 'Marker', 'none')
end
%move lines to back of figures
set(h(2),'Children',[h(2).Children(length(f_exc)+1:end);h(2).Children(1:length(f_exc))])
%names
for ii = 1:length(f_exc)
    text(h(2),f_exc(ii),double(h(2).YLim(2)),strcat('$f_',num2str(ii),'$=',num2str(round(f_exc(ii),2))),'FontSize',13,'HorizontalAlignment', 'center','VerticalAlignment', 'bottom')
end



%% plot legend for lower figure
legend([a1(1),a2,a3,a4])