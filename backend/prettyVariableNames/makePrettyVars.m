clear; close all; clc

% CODE TO CREATE PRETTY VARIABLE NAMES FOR COGNIONICS AND TOBII BIOMETRIC
% SENSING PACKAGES

% CODE AUTHORED BY: SHAWHIN TALEBI
% THE UNIVERSITY OF TEXAS AT DALLAS
% MULTI-SCALE INTEGRATED REMOTE SENSING AND SIMULATION (MINTS)

%% OVERHEAD

% change to home dir
homeDir

% define ID
ID = '2019_12_2_T03_U001_Synchronized';

% get input strings
[YEAR, MONTH, DAY, TRIAL, USER, DEVICE] = decodeID(ID);

% load timetable
Timetable = LoadTimetable(YEAR, MONTH, DAY, TRIAL, USER, DEVICE);

%% GET PRETTY VARIABLE NAMES

% define cell array with raw variable names
varNamesRaw = Timetable.Properties.VariableNames';

% initialize array for pretty names
varNamesPretty = [];

% standard eeg variable names
for i = 1:64
    
    % create ith pretty eeg name
    varNamesPretty = [varNamesPretty strcat(varNamesRaw(i), " (V)")];
    
end

% derived eeg variable names
for i = 65:91
    
    prettyName = strrep(varNamesRaw(i), "minus", " - ");
    
    varNamesPretty = [varNamesPretty strcat("abs(",prettyName, ") (V)")];
end

% add AIM2 variable names
varNamesPretty = [varNamesPretty...
    "EMG 1 (V)" "EMG 2 (V)" "EMG 3 (V)" "EMG 4 (V)" ...
    "ECG (V)" "Respiration (kohms)" "PPG (MADU)" "SpO_2 (%)" ...
    "Heart Rate (bpm)" "Galvanic Skin Response (kohms)" "Temperature (C)" ...
    "Auxiliary Sensor 1 (V)" "Auxiliary Sensor 2 (V)" ...
    "Accelerometer X (g)" "Accelerometer Y (g)" "Accelerometer Z (g)" ...
    "Packet Counter" "Wireless Trigger"];

% add Tobii variable names
varNamesPretty = [varNamesPretty ...
    "Left Pupil Center Error" "Left Pupil Center Gaze Index" ...
    "Left Pupil Center X (mm)" ...
    "Left Pupil Center Y (mm)" ...
    "Left Pupil Center Z (mm)" ...
    "Right Pupil Center Error" "Right Pupil Center Gaze Index" ...
    "Right Pupil Center X (mm)" ...
    "Right Pupil Center Y (mm)" ...
    "Right Pupil Center Z (mm)" ...
    "Left Pupil Diameter Error" "Left Pupil Diameter Gaze Index" ...
    "Left Pupil Diameter (mm)" ...
    "Right Pupil Diameter Error" "Right Pupil Diameter Gaze Index" ...
    "Right Pupil Diameter (mm)" ...
    "Left Gaze Direction Error" "Left Gaze Direction Gaze Index" ...
    "Left Gaze Direction X (au)" ...
    "Left Gaze Direction Y (au)" ...
    "Left Gaze Direction Z (au)" ...
    "Right Gaze Direction Error" "Right Gaze Direction Gaze Index" ...
    "Right Gaze Direction X (au)" ...
    "Right Gaze Direction Y (au)" ...
    "Right Gaze Direction Z (au)" ...
    "Gaze Position Error" "Gaze Position Gaze Index" ...
    "Video Latency (us)" ...
    "Gaze Position X (au)" "Gaze Position Y (au)" ...
    "3D Gaze Position Error" "3D Gaze Position Gaze Index" ...
    "3D Gaze Position X (mm)" ...
    "3D Gaze Position Y (mm)" ...
    "3D Gaze Position Z (mm)" ...
    strcat("Gyroscope X (", char(176), "/s)") ...
    strcat("Gyroscope Y (", char(176), "/s)") ...
    strcat("Gyroscope Z (", char(176), "/s)") ...
    "Gyroscope Error" ...
    "Accelerometer X (m/s^2)" ...
    "Accelerometer Y (m/s^2)" ...
    "Accelerometer Z (m/s^2)" ...
    "Acceleromter Error"];

% add derived Tobii variable names
varNamesPretty = [varNamesPretty ...
    "Average Pupil Diameter (mm)" ...
    "Difference in Pupil Diameters (mm)" ...
    "Pupil Center X Distance (mm)" ...
    "Pupil Center Y Distance (mm)" ...
    "Pupil Center Z Distance (mm)" ...
    "Pupil Center 3D Distance (mm)" ...
    "Pupil Center 3D Distance - Moving Average (mm)" ...
    "Pupil Center 3D Distance - Moving Variance (mm)" ...
    "Pupil Center 3D Distance - Moving Representativeness (mm)" ...
    "Left Pupil Area (mm^2)" ...
    "Right Pupil Area (mm^2)" ...
    "Difference in Pupil Areas (mm^2)"];

% % convert varNamesPretty string array to cell array
% varNamesPretty = cellstr(varNamesPretty');
%% CREATE VARIABLE NAME TABLE    

variableNameTable = array2table(varNamesPretty, ...
    'VariableNames', varNamesRaw);

%% SAVE TABLE

% save table to file
save("backend/prettyVariableNames/variableNameTable.mat", ...
    'variableNameTable')

% write table as text file
writetable(rows2vars(variableNameTable), ...
    "backend/prettyVariableNames/variableNameTable.txt", ...
    'WriteVariableNames', 0)