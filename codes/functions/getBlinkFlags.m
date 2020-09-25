% FUNCTION TO CLASSIFY BLINKS IN TOBII DATA

% VARIABLES ADDED:

%     1. BLINK FLAG: 0 = NO BLINK, 1 = BLINK, NaN = indeterminante

% CODE AUTHORED BY: SHAWHIN TALEBI
% THE UNIVERSITY OF TEXAS AT DALLAS
% MULTI-SCALE INTEGRATED REMOTE SENSING AND SIMULATION (MINTS)

function newTobiiTimetable = getBlinkFlags(oldTobiiTimetable)

    %% LABEL BLINKS BASED ON 

    % define number of rows in table
    numRecords = height(oldTobiiTimetable);

    % initialize blink array
    BlinkFlag = zeros(numRecords,1);
    % initialize blink array to be nan if AveragePupilDiameter is nan
    BlinkFlag(isnan(oldTobiiTimetable.AveragePupilDiameter)) = NaN;

    % initialize a nanSwitch
    nanSwitch = [0 0];

    % iterate through each row of table
    for i=1:numRecords

        % check if both left and right pupil diameter are nans
        if isnan(oldTobiiTimetable.PupilDiameter_LeftPupilDiameter_Timetable(i)) && ...
               isnan(oldTobiiTimetable.PupilDiameter_RightPupilDiameter_Timetable(i)) 

            % if both left and right pupil diameter are nans and nan switch is
            % already active go to next row
            if nanSwitch(1)

                continue

            % if both left and right pupil diameter are nans and nan switch is
            % not active activate it and store current index
            else

                nanSwitch = [1 i];

            end

        % check if both left and right pupil diameter are not nans and
        % nanSwitch is active
        elseif nanSwitch(1)

            % check if interval of bilateral nans is less than 6
            if length(nanSwitch(2):i-1) < 7

                % if interval of bilateral nans is less than 6 label all rows
                % in nan interval as blinks
                BlinkFlag(nanSwitch(2):i-1) = 1;

            end

            % deactivate nanSwtich
            nanSwitch = [0 0];

        end

    end
    %% ADD BLINK FLAG TO TIMETABLE

    newTobiiTimetable = addvars(oldTobiiTimetable, BlinkFlag);