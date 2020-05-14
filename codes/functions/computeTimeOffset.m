% FUNCTION TO COMPUTE TIME OFFSET BETWEEN TOBII AND COGNIONICS BIOMETRIC
% DATA. FUNCTION USES ACCELEROMETER MEASUREMENTS AND SIGNAL CROSS
% CORRELATION TO COMPUTE OFFSET. 
% NOTE: FUNCTION ASSUMES TOBII DATA IS LONGER THAN COGNIONICS DATA

% INPUTS:
%     TobiiTimetable = TIMETABLE OF TOBII DAA SAMPLED AT 100HZ
%     EEGAccelTimetable = TIMETABLE OF COGNIONICS DATA SAMPLED AT 500HZ
% OUTPUTS:
%     offset = TIME OFFSET BETWEEN TobiiTimetable EEGAccelTimetable AS 
%          DURATION DATA TYPE.
%          NOTE: FUNCTION ASSUMES TobiiTimetable IS LONGER THAN 
%          EEGAccelTimetable


% CODE AUTHORED BY: SHAWHIN TALEBI
% THE UNIVERSITY OF TEXAS AT DALLAS
% MULTI-INTEGRATED REMOTE SENSING AND SIMULATION (MINTS)

function offset = computeTimeOffset(TobiiTimetable, EEGAccelTimetable)

    %% GET ACCELEROMETER VALUES

    % define arrays with tobii and (downsampled) cgx acceleromter values
    TobiiAccel = [TobiiTimetable.AccelerometerX ...
        TobiiTimetable.AccelerometerY ...
        TobiiTimetable.AccelerometerZ]; 

    EEGAccel = downsample([EEGAccelTimetable.AccelX ...
        EEGAccelTimetable.AccelY ...
        EEGAccelTimetable.AccelZ], 5);

    % normalize each column (mean = 0, std = 1) and scale so max = 1
    TobiiAccel = normalize(TobiiAccel);
    TobiiAccel = TobiiAccel./max(abs(TobiiAccel));

    EEGAccel = normalize(EEGAccel);
    EEGAccel = EEGAccel./max(abs(EEGAccel));

    % change direction of cgx accelerometer values to point in the same
    % direction as the tobii values
    EEGAccel = [1 -1 1].*EEGAccel;

    %% COMPUTE CROSS CORRELATION

    % initialize arrays to store time indicies
    times = zeros(1, 3);

    % find cross correlation for each direction
    for i = 1:3
        
        % compute xcorr
        [r, lag] = xcorr(TobiiAccel(:,i), EEGAccel(:,i));
        % find where max occurs in xcorr coefficents
        [~,I] = max(abs(r));
        % get offset time index
        t = lag(I);

        % update times array
        times(i) = t;

    end

    %% COMPUTE OFFSET AS DURATION 
    
    % compute offset
    offset = EEGAccelTimetable.Properties.StartTime - ...
        TobiiTimetable.Datetime(abs(round(mean(times))));
    
    % round offset to nearest centisecond
    offset = seconds(round(seconds(offset), 2));
    
    % check if offset is positive or negative
    if round(mean(times)) < 0
        % if negatie multiply offset by -1
        offset = -1*offset;
        
        % otherwise do nothing
    end
    
    % reformat to show centiseconds
    offset.Format = 'hh:mm:ss.SS'; 