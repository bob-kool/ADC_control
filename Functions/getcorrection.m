function [ FRF] = getcorrection(FRF,f_exc,Yp,Up)
%% load models
pipemodel=getpipemodel(f_exc*2*pi);
%% apply correction
FRF.TF=FRF.TF./pipemodel.raw;

%% recalculate error bars
FRF.var = squeeze(Yp.var)'./(abs(Up.out).^2);   %variance on FRF
FRF.s2g = 2*sqrt(FRF.var);                      %2 sigma bars on gain
FRF.s2p = 2*sqrt(FRF.var./(abs(FRF.TF).^2));    %2 sigma bars on phase (rad)
end

