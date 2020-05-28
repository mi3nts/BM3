clear; close all; clc

% EXAMPLE CODE TO DO THE FOLLOWING IN THE BM LIBRARY:
%     1. IMPORT RAW EEG DATA
%     2. READ RAW DATA AND SAVE AS A TIMETABLE
%     3. ACCESS TIMETABLE

% CODE AUTHORED BY: SHAWHIN TALEBI
% THE UNIVERSITY OF TEXAS AT DALLAS
% MULTI-SCALE INTEGRATED REMOTE SENSING AND SIMULATION (MINTS)

%% SET UP ENVIRONMENT
% The first thing we need to do is navigate to the "home" directory of the
% BM library and then add the library functions to the current path. This 
% is to ensure that the libary works properly. This can be acheived by 
% executing the function "homeDir", which should be included in the current
% folder, if not, it is available in the directory BM3/codes/functions. 
% NOTE: homeDir does not take any inputs or have any outputs

homeDir

%% IMPORT RAW DATA
% To start processing raw EEG data it is recommended to include all data
% folders/files in the "raw/_newData" directory. For EEG data recorded 
% using the Cognionics Mobile-128, the following data files are required: a
% .eeg file, .vhdr file, and .vmrk file. These files should be stored in a
% single folder with a name corresponding to the data's ID. The ID for a
% dataset is a unique identifier that is heavily utilized by the BM library 
% to access data saved within the BM directory structure. The format for a
% EEG dataset's ID is the following: YYYY_MM_DD_TXX_UXXX_EEGXX_, where YYYY
% is the year the data was recorded, MM the month, and DD is the day. Here,
% the X's following T, U, and EEG are integers that correspond to the 
% dataset's trial number, user number, and EEG system number, respectively.

% Example raw data can be found in the "codes/exampleCodes/_resources" 
% directory. Copy the "2019_12_2_T03_U001_EEG01" folder in this directory,
% and drop it into the "raw/_newData" directory.

% Once all raw data folders are placed in the "raw/_newData" folder we 
% can run the "initial" function to make/save the raw data to their proper 
% branches in the "raw" directory.
% NOTE: initial does not take any inputs or have any outputs

initial

%% READ RAW DATA AND SAVE AS A TIMETABLE
% The "initial" function saved the EEG dataset to a directory corresponding
% to its ID, in other words, "raw/YYYY/MM/DD/TXX/UXXX/EEGXX/". Typically it
% is not necessary to manually navigate through the BM directories to
% access data. If you know the ID of the dataset you are interested in, you
% have everything you need access and work with your dataset.

% Let's define an ID for a dataset
ID = '2019_12_2_T03_U001_EEG01_';

% This ID references data recorded on December 2nd, 2019. It is trial 3 of
% the experiment, the user ID is U001, and the ID of EEG system used is
% EEG01

% With our ID we can generate the following strings: YEAR, MONTH, DAY, 
% TRIAL, USER, DEVICE. These strings will be used as function inputs in the
% proceeding sections. To get these strings we can use the function
% "decodeID()"

% Get YEAR, MONTH, DAY, TRIAL, USER, and DEVICE strings
[YEAR, MONTH, DAY, TRIAL, USER, DEVICE] = decodeID(ID);

% we can now read the raw data using the function "EEGread()"
EEGRead(YEAR, MONTH, DAY, TRIAL, USER, DEVICE)

% "EEGread()" will create a timetable of the data corresponding to the
% given input strings. This timetable is then automatically saved to the
% directory "objects/YYYY/MM/DD/TXX/UXXX/EEGXX/"
% NOTE: the timetable will NOT be returned by EEGread in the current
% workspace, we will need to do one additional step to import this
% timetable.

%% ACCESS TIMETABLE
% Now that we have read our raw data and saved it as a timetable we just
% need to bring the timetable into our workspace. We can this using the
% "LoadTimetable()" function.

% call LoadTimetable() function
[Timetable, ID, pathID, TT] = LoadTimetable(YEAR, MONTH, DAY,...
    TRIAL, USER, DEVICE);

% The timetable is now in the workspace with the name "Timetable"! ID
% returns a new ID corresponding to our timetable, pathID is the path where
% the timetable was saved, and TT is name for the timetable corresponding 
% to the data in it.

% It is often not necessary to return ID, pathID, and TT from the
% "LoadTimetable()" function. If we are only interest in the timetable we
% can only return that object.

% call LoadTimetable() function, but only return timetable
Timetable = LoadTimetable(YEAR, MONTH, DAY, TRIAL, USER, DEVICE);