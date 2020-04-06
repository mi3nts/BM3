% FUNCTION TO SYNCHRONIZE EEG AND TOBII TIMETABLES. FUNCTION CREATES AND
% SAVES SYNCHRONIZED TIMETABLE TO APPROPRIATE DIRECTORY

% INPUTS
%     YEAR = STRING. EX: '2019'
%     MONTH = STRING. EX: '12'
%     DAY = STRING. EX: '5'
%     TRIAL = STRING. EX: 'T01'
%     USER = STRING. EX: 'U010'
%     EEG =  STRING. EX: 'EEG01'
%     Tobii = STRING. EX: 'Tobii01'

% CODE AUTHORED BY: SHAWHIN TALEBI
% THE UNIVERSITY OF TEXAS AT DALLAS
% MULTI-INTEGRATED REMOTE SENSING AND SIMULATION (MINTS)

function [] = EEGTobiiSync(YEAR, MONTH, DAY, TRIAL, USER, EEG, Tobii)

    % define ID and pathID
    ID = strcat(YEAR, '_', MONTH, '_',DAY, '_',TRIAL, '_',USER, '_');
    pathID = strrep(ID,'_','/');

    % define path for EEG and Tobii data
    pathEEG = strcat('objects/', pathID, EEG, '/', ID, EEG, ...
        '_EEGAccelTimetable.mat');
    pathTobii = strcat('objects/', pathID, Tobii, '/', ID, Tobii, ...
        '_TobiiTimetable.mat');

    %% LOAD TIMETABLES

    load(pathEEG);
    load(pathTobii);

    %% RESAMPLE TIMETABLES

    % define timestep
    dt = milliseconds(2);

    % reconfigure timesteps to be uniform
    EEGAccelTimetable = retime(EEGAccelTimetable,'regular'...
        ,'next','TimeStep', dt);

    % reconfigure timesteps to be uniform
    TobiiTimetable = retime(TobiiTimetable,...
        'regular', 'fillwithmissing', ...
        'TimeStep', dt);

    %% SYNCHRONIZE TIMETABLES

    EEGAccelTobiiTimetable = synchronize(EEGAccelTimetable,...
        TobiiTimetable, 'intersection');

    %% SAVE SYNCHRONIZED TIMETABLE

    % check if proper folder for storing timetables exists, if not create it
    if ~exist(strcat('objects/', pathID, '_Synchronized/'), 'dir')
        mkdir(strcat('objects/', pathID, '_Synchronized/'))
    end

    % save timetables
    save(strcat('objects/', pathID, '_Synchronized/', ID,...
        'Synchronized_EEGAccelTobiiTimetable'), 'EEGAccelTobiiTimetable');
end