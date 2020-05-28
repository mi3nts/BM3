clear; close all; clc

% EXAMPLE CODE TO SERVE AS A QUICKSTART FOR WRITING YOUR OWN SCRIPTS AND
% FUNCTIONS IN BM3

% CODE AUTHORED BY: SHAWHIN TALEBI
% THE UNIVERSITY OF TEXAS AT DALLAS
% MULTI-SCALE INTEGRATED REMOTE SENSING AND SIMULATION (MINTS)

%% OVERHEAD

% NOTE: Before running this code run the SyncEEGTobiiData_example.m code so
% you have some data to play with

% first we run the obligatory homeDir function which ensures we have all 
% necessary functions added to the path and the current directory is BM3
homeDir

% NOTE: homeDir is not necessary to call for functions that are saved to
% the /codes/functions sub-directory 
%% DEFINE ID

% IDs are the keys to datasets in BM3. This enables one to perform data
% processing on large datasets without bringing them into the workspace.
% Here we want to load the timetable generated in the example
% SyncEEGTobiiData_example.m

ID = '2019_12_2_T03_U001_Synchronized';

% a quick way to get input strings for the LoadTimetable() function is the
% decodeID() function

% Get YEAR, MONTH, DAY, TRIAL, USER, and DEVICE strings
[YEAR, MONTH, DAY, TRIAL, USER, DEVICE] = decodeID(ID);

% now we can load the timetable corresponding to the ID
Timetable = LoadTimetable(YEAR, MONTH, DAY, TRIAL, USER, DEVICE);

% NOTE: if we just wanted EEG or eyetracking data we could have used the
% DEVICE strings "EEG01" or "Tobii01"

%% ANALYSIS

% your code goes here