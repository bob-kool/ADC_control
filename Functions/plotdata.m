function [f1,f2] =plotdata(shot,FRF,Yp,Ydet,f_exc,Input,Output,yc,uc,sigma_noise,plotsettings,settings)
%% Set latex to default interpreter
set_Latex_for_all
%% Get labels for plotting
[labels.input,labels.inputunits,labels.output,labels.outputunits]=getlabels(Input,Output,settings);
%% Create empty figure base
[f1,h1] = makeFRFfigure_base(labels,plotsettings,shot);
[f2,h2] = makelinesfigure_base(labels,plotsettings,shot);
%% Evaluate LPM result in time domain
LPMtimeresp=get_frm_response(yc.time,min(yc.time),f_exc,Yp.out);
%shift signal to align with mean value of first peak
dt=mean(diff(yc.time));
periodidxlength=floor((1/min(f_exc))/dt);
[~,max_frist_period]=max(yc.data(1:periodidxlength));
% shift=mean(yc.data(max_frist_period-floor(periodidxlength/10):max_frist_period+floor(periodidxlength/10)))-LPMtimeresp(max_frist_period);
shift=0;
LPMtimedomain.data=LPMtimeresp+shift;
LPMtimedomain.time=yc.time;
%% Fill figures with data
%FRF figure
[h1] = fillFRFfigure(h1,plotsettings,FRF,f_exc);
%Lines figure
[h2] = filllinesfigure(h2,plotsettings,uc,yc,Ydet,Yp,f_exc,sigma_noise,LPMtimedomain);
end

