% FUNCTION TO CREATE ID AND PATHIDFROM YEAR MONTH DAY TRIAL USER AND DEVICE 
% ID. NOTES, INPUTS MUST BE STRINGS.

% INPUTS:
%     YEAR = STRING. EX: '2019'
%     MONTH = STRING. EX: '12'
%     DAY = STRING. EX: '10'
%     TRIAL = STRING. EX: 'T01'
%     USER = STRING. EX: 'U000'
%     DEVICE = STRING. EX: 'EEG01'. NOTE: IF DEVICE IS NOT DESIRED IN ID
%     OR pathID INPUT [].

% THE UNIVERSITY OF TEXAS AT DALLAS
% MULTI-INTEGRATED REMOTE SENSING AND SIMULATION (MINTS)
% CODE AUTHORED BY: SHAWHIN TALEBI

function [ID, pathID] = makeIDs(YEAR, MONTH, DAY, TRIAL, USER, DEVICE)


if ~isempty(DEVICE)
    ID = strcat(YEAR, '_', MONTH, '_',DAY, '_',TRIAL, '_',USER, '_',...
        DEVICE);
    
else
    ID = strcat(YEAR, '_', MONTH, '_',DAY, '_',TRIAL, '_',USER);
   
end

pathID = strrep(ID,'_','/');

if strcmp(DEVICE,'Synchronized')
    pathID = strrep(pathID, '/S', '/_S');
end
