clear; close all; clc

% EXAMPLE CODE TO DO THE FOLLOWING IN THE BM3 LIBRARY:
%     1. IMPORT RAW DATA
%     2. READ RAW DATA, SAVE AS A TIMETABLE
%     3. SYNCHRONIZE EEG AND TOBII DATA
%     4. ACCESS TIMETABLE

% CODE AUTHORED BY: SHAWHIN TALEBI
% THE UNIVERSITY OF TEXAS AT DALLAS
% MULTI-SCALE INTEGRATED REMOTE SENSING AND SIMULATION (MINTS)

%% SET UP ENVIRONMENT

% run the homeDir function. This adds all BM3 functions to path and changes
% the current directory to BM3.

% NOTE: make sure the homeDir function is saved to the current path. It is
% located in the /codes/functions sub directory
homeDir

%% IMPORT RAW DATA

% before running the initialize function below, drag and drop the 
% 2019_12_2_T03_U001_EEG01 and 2019_12_2_T03_U001_Tobii01 folders located
% in the codes/exampleCodes/_resources subdirectory to the raw/_newData sub
% directory

% now run the initialize function to bring the raw data files into BM3
initial

%% READ RAW DATA AND SAVE AS A TIMETABLE

% the raw data files are now in BM3, but they are not in a format suitable
% for data analysis. To get a more practical data structure we can access 
% the raw data via its ID

% define the dataset ID
ID = '2019_12_2_T03_U001_';

% This ID references data recorded on December 2nd, 2019. It is trial 3 of
% the experiment, the user ID is U001.

% With our ID we can generate the following strings: YEAR, MONTH, DAY, 
% TRIAL, USER, DEVICE. These strings will be used as function inputs in the
% proceeding sections. To get these strings we can use the function
% "decodeID()"

% Get YEAR, MONTH, DAY, TRIAL, USER, and DEVICE strings
[YEAR, MONTH, DAY, TRIAL, USER, ~] = decodeID(ID);

% we also need to reference with recording devices we are interested in.
% Here we have EEG and eye tracking data from the Cognionics Mobile-128 and
% Tobii Pro Glasses 2, respectively. The device IDs are:

EEG = 'EEG01';
Tobii = 'Tobii01';

% NOTE: device IDs are arbritrary names defined by the folder name placed 
% in the raw/_newData folder

% we can now read the raw data using the function "EEGread()" meaning we
% create a timetable with the EEG data
EEGRead(YEAR, MONTH, DAY, TRIAL, USER, EEG)

% and similaryly for the Tobii data we have
% NOTE: this function may take a while to run
TobiiRead(YEAR, MONTH, DAY, TRIAL, USER, Tobii)

%% SYNCHRONIZE EEG AND TOBII DATA

% notice the timetable were not loaded in to the workspace. This is by
% design to allow for easier processing of large datasets. The timetables
% were saved to the /objects/2019/12/2/T03/U001 subdirectory, which
% corresponds to the dataset ID

% join the two timetables into a single table we can use the EEGTobiiSync()
% function
EEGTobiiSync(YEAR, MONTH, DAY, TRIAL, USER, EEG, Tobii)

%% ACCESS TIMETABLE

% finally we can load the synced timetable into the workspace for analysis
% using the LoadTimetable() function
Timetable = LoadTimetable(YEAR, MONTH, DAY, TRIAL, USER, 'Synchronized');

% NOTE: the final input argument designating the synchronized timetable
