% FUNCTION TO SYNCHRONIZE EEG AND TOBII TIMETABLES. FUNCTION CREATES AND
% SAVES SYNCHRONIZED TIMETABLE TO APPROPRIATE DIRECTORY

% INPUTS
%     EEG =  STRING. EX: 'EEG01'
%     Tobii = STRING. EX: 'Tobii01'
%     NumberOfWorkers = INTEGER. EX: 2. 
%                       NOTE: USE [] IF PARALLEL IS NOT DESIRED

% CODE AUTHORED BY: SHAWHIN TALEBI
% THE UNIVERSITY OF TEXAS AT DALLAS
% MULTI-INTEGRATED REMOTE SENSING AND SIMULATION (MINTS)

function [] = EEGTobiiSyncAll(EEG, Tobii, NumberOfWorkers)

    %% GET FILE IDS OF TIMETABLES TO SYNCHRONIZE

    % get all files IDs corresponding to input EEG and Tobii devices
    EEGfileIDs = findAllFiles('objects', strcat(EEG,'_EEGAccelTimetable'));
    TobiifileIDs = findAllFiles('objects', strcat(Tobii,'_TobiiTimetable'));

    % consider only fileIDs in both EEGfileIDs and EEGfileIDs
    fileIDs = intersect(EEGfileIDs,TobiifileIDs);

    %% SYNCHRONIZE TIMETABLES IF NOT ALREADY DONE

    if ~isempty(NumberOfWorkers)    % if NumberOfWorkers is given use parfor

        % create parallel pool
        poolobj = parpool(NumberOfWorkers);

        parfor i = 1:length(fileIDs)

            % get input strings for ith raw EEG file for EEGRead
            [YEAR, MONTH, DAY, TRIAL, USER, ~] = decodeID(fileIDs(i));

            % get ID and pathID
            [ID, pathID] = makeIDs(YEAR, MONTH, DAY, TRIAL, USER, []);

            % create directory for synchronized timetable
            file = strcat('objects/',pathID, '/_Synchronized/',...
                ID, '_Synchronized_EEGAccelTobiiTimetable.mat'); 

            % if synchronized timetable already exists go to next fileID
            if exist(file, 'file')
                disp(strcat(fileIDs(i), " already exists"));
                continue
            end

            % synchronize timetables
            EEGTobiiSync(YEAR, MONTH, DAY, TRIAL, USER, EEG, Tobii)

            % print trial is complete
            disp(strcat(fileIDs(i), " is complete"));

        end

        % delete parallel pool
        delete(poolobj)

    else    % if NumberOfWorkers is not given use for loop

        % iteratively read data files
        for i = 1:length(fileIDs)

            % get input strings for ith raw EEG file for EEGRead
            [YEAR, MONTH, DAY, TRIAL, USER, ~] = decodeID(fileIDs(i));

            % get ID and pathID
            [ID, pathID] = makeIDs(YEAR, MONTH, DAY, TRIAL, USER, []);

            % create directory for synchronized timetable
            file = strcat('objects/',pathID, '/_Synchronized/',...
                ID, '_Synchronized_EEGAccelTobiiTimetable.mat'); 

            % if synchronized timetable already exists go to next fileID
            if exist(file, 'file')
                continue
            end

            % synchronize timetables
            EEGTobiiSync(YEAR, MONTH, DAY, TRIAL, USER, EEG, Tobii)

            % print trial is complete
            disp(strcat(fileIDs(i), " is complete"));

        end

    end