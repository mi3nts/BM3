% FUNCTION TO CONVERT AUDIO TO TEXT FILE. ROUTINE TAKES TOBII FULLSTREAM 
% POV VIDEO AND CONVERTS IT INTO A TXT. NOTE: FULLSTREAM VIDEO MUST BE 
% SAVED IN RAW SUBDIRECTORY FOR INPUT DATASET INFORMATION.

% INPUTS: 
%     YEAR
%     MONTH
%     DAY = STRING. 
%     TRIAL = STRING. TRIAL NUMBER
%     USER = STRING. USER ID.
%     Tobii = STRING. TOBII DEVICE ID.
%     pythonPath = STRING. PATH OF DESIRED VERSION OF PYTHON
%     sysPath = STRING. SYSTEM PATH. GET FROM TERMINAL VIA: "printenv PATH"

% CODE AUTHORED BY: SHAWHIN TALEBI
% THE UNIVERSITY OF TEXAS AT DALLAS
% MULTI-SCALE INTEGRATED REMOTE SENSING AND SIMULATION (MINTS)

%% FUNCTION

function [] = fullstreamAudioToText(YEAR, MONTH, DAY, TRIAL, USER, ...
    Tobii, pythonPath, sysPath)

% get ID and pathID
[ID, pathID] = makeIDs(YEAR, MONTH, DAY, TRIAL, USER, Tobii);

% define path to eyestream video
audioFilename = strcat(pwd,"/raw/",pathID,"/", ID,"/segments/1/tobiiaudio.wav");
outputFilename = strcat(pwd,"/raw/",pathID,"/", ID, ...
    "/segments/1/fullstreamText.txt");

% cd to dir with script
cd backend/Audio_Text

% add current directory to python path if not already added
if count(py.sys.path,'') == 0
    insert(py.sys.path,int32(0),'');
end

% create system command
cmd = strcat(pythonPath, " audio_text_generator.py -a ", audioFilename , ...
    " -o ", outputFilename);

% if audio file does not exist, make it
if ~isfile(audioFilename)
    TobiiAudioRead(YEAR, MONTH, DAY, TRIAL, USER, Tobii)
end

% execute system command
try
    system(cmd)
catch
    setenv('PATH', [getenv('PATH') sysPath]);
    system(cmd)
end

% change to home directory
homeDir()