function [requestedvoltage] = measuredvoltage_to_requestedvoltage(measuredvoltage,gascalibration)
%MEASUREDVOLTAGE_TO_REQUESTEDVOLTAGE 
requestedvoltage=measuredvoltage*gascalibration.measured_to_requested;
end

