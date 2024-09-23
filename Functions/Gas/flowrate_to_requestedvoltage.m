function [requestedvoltage] = flowrate_to_requestedvoltage(flowrate,gascalibration)
%requestedvoltage to flowrate
%F = a*V +b calibrations of the flow rates
requestedvoltage=(flowrate./1e21-gascalibration.b)./gascalibration.a;
end

