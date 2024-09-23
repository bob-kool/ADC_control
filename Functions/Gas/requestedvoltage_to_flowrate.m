function [flowrate] = requestedvoltage_to_flowrate(requestedvoltage,gascalibration)
%requestedvoltage to flowrate
%F = a*V +b calibrations of the flow rates
if isnan(requestedvoltage)
    flowrate=NaN;
else
    flowrate=(gascalibration.a.*requestedvoltage+gascalibration.b) *1e21;
end
end

