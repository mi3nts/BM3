% FUNCTION TO LOAD A TIMETABLE

% INPUTS
%     YEAR = STRING. EX: '2019'
%     MONTH = STRING. EX: '12'
%     DAY = STRING. EX: '5'
%     TRIAL = STRING. EX: 'T01'
%     USER = STRING. EX: 'U010'
%     DEVICE =  STRING. 
%         SUPPORTED INPUTS: 'EEGXX', 'TobiiXX', 'Synchronized'

% CODE AUTHORED BY: SHAWHIN TALEBI
% THE UNIVERSITY OF TEXAS AT DALLAS
% MULTI-INTEGRATED REMOTE SENSING AND SIMULATION (MINTS)

function [Timetable, ID, pathID, TT] = LoadTimetable(YEAR, MONTH, DAY,...
    TRIAL, USER, DEVICE)

% define ID and pathID
[ID, pathID] = makeIDs(YEAR, MONTH, DAY, TRIAL, USER, DEVICE);

% adjust ID and pathID based on DEVICE
if strcmp(DEVICE, 'Synchronized')
    
    TT = 'EEGAccelTobiiTimetable';
    ID = strcat(ID, '_', TT);
    pathID = insertBefore(pathID,'Synchronized','_');
    
elseif strcmp(DEVICE(1:3), 'EEG')

    TT = 'EEGAccelTimetable';
    ID = strcat(ID, '_', TT);
    
elseif strcmp(DEVICE(1:5), 'Tobii')
    
    TT = 'TobiiTimetable';
    ID = strcat(ID, '_', TT);
end

% load desired timetable
load(strcat('objects/', pathID,'/',ID,'.mat'));

% relabel timetable as output
eval(strcat("Timetable = ", TT, ';'));
