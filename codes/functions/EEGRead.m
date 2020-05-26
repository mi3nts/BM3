% FUNCTION TO READ EEG DATA IN EEGLAB. DATA IS SAVED AS A TIMETABLE. THE 
% TIMETABLE INCLUDES DATA FROM THE EEG ELECTRODES IN ADDITION TO 
% DIFFERENCES IN SYMMETRIC NODES, AIM DATA, ACCELEROMETER DATA, AND 
% AUXILIARY DATA INCLUDING PACKET COUNT AND TRIGGER INFORMATION.

% INPUTS:
%     YEAR = STRING
%     MONTH = STRING
%     DAY = STRING
%     TRIAL = STRING
%     USER = STRING
%     EEG = STRING. NUMBER OF THE EEG SYSTEM USED

% THE UNIVERSITY OF TEXAS AT DALLAS
% MULTI-INTEGRATED REMOTE SENSING AND SIMULATION (MINTS)
% CODE AUTHORED BY: SHAWHIN TALEBI

function[] = EEGRead(YEAR, MONTH, DAY, TRIAL, USER, EEG)
    % define ID number and pathID
    ID = strcat(YEAR, '_', MONTH, '_',DAY, '_',TRIAL, '_',USER, '_', EEG);
    pathID = strrep(ID,'_','/');

     % change directory to home directory if not already in it
    temp  = split(pwd,'/');
    if ~strcmp(temp(end),'BM3')
         homeDir
    end

    % add paths to eeglab folders
    addEEGLabFunctions

    % use long format
    format long
    
    % define a switch for if EEG is tethered
    tetherSwitch = 0;

    %% -------------------------------------------------------------------------
    % GET START DATE AND TIME
    % -------------------------------------------------------------------------
    % define header filename
    header = strcat('raw/',pathID,'/',ID,'/',ID,'.vhdr');

    % open file for reading
    file = fopen(header);
    flag = 0;
    while feof(file)==0

        line = fgetl(file);
        if strcmp(line, 'Recording Start Time')
            flag = 1;
            continue
        end
        if flag == 1
            break
        end
    end

    start_date = datetime(line(1:10), 'InputFormat', 'yyyy-MM-dd');
    start_time = duration(line(12:end),'format','hh:mm:ss.SSSS');

    %% -------------------------------------------------------------------------
    % CREATE DATA objects FROM EEG DATA
    % -------------------------------------------------------------------------
    % define filename
    filename = strcat('raw/',pathID,'/',ID,'/',ID,'.eeg');

    % import eeg data for the accelerometer and full data
    EEG = pop_fileio(filename);
    EEG.setname = 'FullEEG';

    % add channel locations
    EEG=pop_chanedit(EEG, 'lookup','./backend/eeglab2019_1/plugins/dipfit/standard_BESA/standard-10-5-cap385.elp');

    % create structure with only EEG inputs
    electrodeNames = {'Fp1' 'Fp2' 'F3' 'F4' 'C3' 'C4' 'P3'...
        'P4' 'O1' 'O2' 'F7' 'F8' 'T7' 'T8' 'P7' 'P8' 'Fz' 'Cz' 'Pz' 'Oz'...
        'FC1' 'FC2' 'CP1' 'CP2' 'FC5' 'FC6' 'CP5' 'CP6' 'FT9' 'FT10' 'FCz'...
        'AFz' 'F1' 'F2' 'C1' 'C2' 'P1' 'P2' 'AF3' 'AF4' 'FC3' 'FC4' 'CP3'...
        'CP4' 'PO3' 'PO4' 'F5' 'F6' 'C5' 'C6' 'P5' 'P6' 'AF7' 'AF8' 'FT7'...
        'FT8' 'TP7' 'TP8' 'PO7' 'PO8' 'Fpz' 'CPz' 'POz' 'TP10'};

    EEG64 = pop_select( EEG, 'channel', electrodeNames);
    EEG64.setname = 'EEG64';

    % create structure with only Accelerometer inputs
    accelNames = {'AccelX' 'AccelY' 'AccelZ'};

    % if mobile-128 is unteathered acceleration channels will be 64 65 and 66
    % if 128 is teathered to AIM then accel channels will be 77 78 79
    % if there was an improper tether accel channels will be 72 73 74
    
    % untethered case
    try
        AccelEEG = pop_select( EEG, 'channel',{'ACC64' 'ACC65' 'ACC66'});
    catch
        tetherSwitch = 1;
    end
    
    if tetherSwitch
        % tethered cases
        try
            AccelEEG = pop_select( EEG, 'channel',{'ACC77' 'ACC78' 'ACC79'});

        catch
            AccelEEG = pop_select( EEG, 'channel',{'ACC72' 'ACC73' 'ACC74'});
            tetherSwitch = 0;
            disp('----warning: bad tether----')
        end
    end

    AccelEEG.setname= 'AccelEEG';

    % create structure with only Auxilliary inputs 
    auxNames = {'PacketCounter' 'TRIGGER'};

    AuxEEG = pop_select( EEG, 'channel', {'Packet Counter' 'TRIGGER'});
    
    % if mobile-128 is tethered create structure with AIM2 variables
    if tetherSwitch == 1
    % create structure with only AIM2 inputs 
        AIMNames = {'ExG1' 'ExG2' 'ExG3' 'ExG4'...
            'ECG' 'Resp' 'PPG' 'SpO2' 'HR' 'GSR' 'Temp'...
            'AUX1' 'AUX2'};

        AIMEEG = pop_select( EEG, 'channel', {'ExG 1' 'ExG 2' 'ExG 3' 'ExG 4'...
            'ECG.' 'Resp.' 'PPG' 'SpO2' 'HR' 'GSR' 'Temp.'...
            'AUX 1' 'AUX 2'}); 
    end
    %% -------------------------------------------------------------------------
    % TIMESTAMPS
    % -------------------------------------------------------------------------
    % create vector with timestamps in milliseconds since start of collection
    mstime = milliseconds(EEG64.times);
    
    % create table with actual time stamp
    datetimes = array2table((start_date + start_time + mstime)',...
        'VariableNames', "Datetime");

    %% -------------------------------------------------------------------------
    % TABLES
    % -------------------------------------------------------------------------
    % create table with electrodes as variables
    EEGTable = [datetimes ...
        array2table(EEG64.data', 'VariableNames', electrodeNames)];

    % create table with accelerometers are variables
    AccelTable = [datetimes ...
        array2table(AccelEEG.data', 'VariableNames', accelNames)];

    % create table with auxiliary inputs are variables
    AuxTable = [datetimes ...
        array2table(AuxEEG.data', 'VariableNames', auxNames)];
    
    if tetherSwitch == 1
        % create table with AIM inputs are variables
        AIMTable = [datetimes ...
            array2table(AIMEEG.data', 'VariableNames', AIMNames)];
    end
    % find off axis electrodes (excluding Tp10)
    idx = [];
    for i = 1:length(electrodeNames)-1

        bool = isstrprop(string(electrodeNames(i)),'digit');
        if sum(bool)>0
            idx = [idx; i];
        end
    end

    % create array of off axis electrodes
    offZelectrodeNames = electrodeNames(idx);

    % evaluate asymmerty by computing difference in voltage of symmetric
    % electrodes
    for i = 1:length(offZelectrodeNames)/2

       EEGTable = [EEGTable ...
           array2table(...
           table2array(EEGTable(:,offZelectrodeNames(2*i))) - ...
           table2array(EEGTable(:,offZelectrodeNames(2*i-1))),...
           'VariableNames',...
           strcat(string(offZelectrodeNames(2*i)),...
           'minus', string(offZelectrodeNames(2*i-1))))];

    end

    try
    % create table with all EEG, accelerometers, auxiliary, and AIM data
        EEGAccelTable = [EEGTable AIMTable(:,2:end) AccelTable(:,2:end)...
            AuxTable(:,2:end)];
    catch
        % create table with all EEG, accelerometers, auxiliary, and AIM data
        EEGAccelTable = [EEGTable AccelTable(:,2:end) AuxTable(:,2:end)];
    end
    %% -------------------------------------------------------------------------
    % TIMETABLES
    % -------------------------------------------------------------------------

    % create timetable of all data
    EEGAccelTimetable = table2timetable(EEGAccelTable);

    %% -------------------------------------------------------------------------
    % SAVE objects
    % -------------------------------------------------------------------------
    % check if proper folder for storing timetables exists, if not create it
    if ~exist(strcat('objects/', pathID), 'dir')
        mkdir(strcat('objects/', pathID))
    end

    % save timetables
    save(strcat('objects/', pathID, '/', ID, '_EEGAccelTimetable'), 'EEGAccelTimetable');
