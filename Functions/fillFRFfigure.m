function [h] = fillFRFfigure(h,plotsettings,FRF,f_exc)
%% fill data
%upper figure
try
    LW = plotsettings.linewidth;
catch
    LW = 2;
end

try
    col = plotsettings.color;
catch
    col = [];
end
if isempty(col)
errorbar(h(1),f_exc,abs(FRF.TF),FRF.s2g,'o-','LineWidth',LW, LineStyle="-")
else
    errorbar(h(1),f_exc,abs(FRF.TF),FRF.s2g,'o-','LineWidth',LW,'Color',col, LineStyle="-")
end
if plotsettings.correct_phase
    Angle=unwrap(angle(FRF.TF));
    Angle_deg=rad2deg(Angle);
    if Angle_deg>0
        Angle_deg=Angle_deg-360;
        warning('PHASE CORRECT ENABLED: ADDED 360 DEGREE SHIFT TO PHASE!')
    end
else
    Angle=angle(FRF.TF);
    Angle_deg=rad2deg(Angle);
end
if isfield(plotsettings,'shift_phase_90')
    if plotsettings.shift_phase_90
        Angle_deg=Angle_deg+90;
    end
elseif isfield(plotsettings,'phasechange')
    if plotsettings.phasechange~=0
        if length(plotsettings.phasechange)>1
            Angle_deg=Angle_deg+plotsettings.phasechange(length(Angle_deg));
        else
            Angle_deg=Angle_deg+plotsettings.phasechange;
        end
        warning(strcat('Phase changed by',num2str(plotsettings.phasechange)))
    end
end
%lower figure
while Angle_deg > 0
    Angle_deg = Angle_deg - 360;
end

if isempty(col)
errorbar(h(2),f_exc,Angle_deg,rad2deg(FRF.s2p),'o-','LineWidth',LW)
% plot(h(2),f_exc, Angle_deg);
else
    errorbar(h(2),f_exc,Angle_deg,rad2deg(FRF.s2p),'o-','LineWidth',LW,'Color',col);
end

