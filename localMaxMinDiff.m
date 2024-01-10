function [staticThreshold,SD] = localMaxMinDiff(vGRF)
% NAME: Katelyn Campbell
% DATE CREATED: 6/12/2020
% LAST REVISED: 1/10/2024- transitioned to function file for open access
                
% PURPOSE: Find static threshold for differentiating phases of step
% recovery as layed out in "Deficits in recovery of postural stability after 
% stepping are limb- and phase-specific in children with unilateral cerebral palsy"

% INPUT:    
            % vGRF- vertical ground reaction force data for a single trial
% OUTPUTS:  
            % staticThreshold- average of the differences in each local extrema
            % SD- standard deviation of the differences in each local extrema

[lMax, maxLocs] = findpeaks(vGRF); % Find local maxima & locations
[lMin,minLocs] = findpeaks(-vGRF); % Find local minima & locations
lMin = -lMin; % negate (corrects sign after negatiting to find local minima)

% Double the locations because maximum or minimum (and it's location) is used twice (except for beginning and end maximum or minimum) once for maximum to minimum and once for minimum to maximum

% Starts with a maximum and ends with a maximum
if length(lMax) > length(lMin) 
    ptDiff = abs(lMax(1:end-1)-lMin); % Max-Min: deletes last maximum (no minimum to match)
    tpDiff = abs(lMin-lMax(2:end)); % Min-Max: deletes the first maximum (first minimum-maximum difference is between minimum 1 and maximum 2)
    
    allDiff = ([reshape(([ptDiff tpDiff])',[],1)]); % combines ptDiff and tpDiff alternating (starting at maximum to minimum) so it is chronological 
    
% Starts with maximum and ends with minimum    
elseif length(lMax) == length(lMin) & maxLocs(1,1) < minLocs(1,1) 
    ptDiff = abs(lMax-lMin); % Max-Min: no motification
    tpDiff = abs(lMin(1:end-1)-lMax(2:end)); % Min-Max: deletes first maximum (no minimum to match) and last minimum (no maximum to match)
    
    allDiff = ([reshape(([ptDiff [tpDiff;NaN]])',[],1)]); %combines ptDiff and tpDiff alternating (starting at maximum to minimum) so it is chronological ****will need to delete the last (can't concat two arrays of different dementions- add NaN to end to make same dementions and delete later)
    allDiff = allDiff(1:end-1);
    
% Starts with minimum and ends with minimum       
elseif length(lMin) > length(lMax) 
    ptDiff = abs(lMax-lMin(2:end)); % Max-Min: deletes the first minimum (first maximum-minimum difference is between maximmum 1 and minimum 2)
    tpDiff = abs(lMin(1:end-1)-lMax); % Min-Max: deletes the last minimum (no maximum to match)
    
    allDiff = ([reshape(([tpDiff ptDiff ])',[],1)]); % combines tpDiff and ptDiff alternating (starting at minimum to maximum) so it is chronological  
   
%Starts with minimum and ends with maximum  
elseif length(lMax) == length(lMin) & maxLocs(1,1) > minLocs(1,1) 
    ptDiff = abs(lMax(1:end-1)-lMin(2:end)); % Max-Min: deletes first minimum (no maximum to match) and last maximum (no minimum to match)
    tpDiff = abs(lMin-lMax); % Min-Max: no motification
    
    allDiff = ([reshape(([tpDiff [ptDiff;NaN]])',[],1)]); % combines tpDiff and ptDiff alternating (starting at minimum to maximum) so it is chronological ****will need to delete the last (can't concat two arrays of different dementions- add NaN to end to make same dementions and delete later)
    allDiff = allDiff(1:end-1);   
end

staticThreshold = mean(allDiff); %Find mean of difference between maxima and minima
SD = std(allDiff); %Find standard deviation of difference between maxima and minima

end