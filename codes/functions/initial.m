% FUNCTION TO INITIALIZE NEW BIOMETRIC DATA INTO DIRECTORY STRUCTURE. CODE READS
% ALL FOLDERS IN _newData FOLDER AND CREATES/PUTS IT IN THE PROPER
% DIRECTORY AND CREATES DIRECTORY FOR ANY FUTURE DATA OBJECTS

% CODE AUTHORED BY: SHAWHIN TALEBI
% THE UNIVERSITY OF TEXAS AT DALLAS
% MULTI-INTEGRATED REMOTE SENSING AND SIMULATION (MINTS)
% -------------------------------------------------------------------------

function [] = initial()
    % change directory to home directory if not already in it
    temp  = split(pwd,'/');
    if ~strcmp(temp(end),'BM3')
         homeDir
    end
   
    % change directory to raw/_newData
    cd raw/_newData

    % get folder names from _newData folder
    struc = dir;

    % % change directory back to home directory
    homeDir

    % iterate thorugh each folder name 
    for i = 1:length(struc)

        % set ID 
        ID = struc(i).name;

        % disregard any non-folders
        if strcmp(ID(1),'.')
            continue
        end

        pathID = strrep(ID,'_','/');

        % check if folder corresponding to ID exists for raw data, if not make it
        if ~exist(strcat('raw/',pathID), 'dir')
            mkdir(strcat('raw/',pathID))
        end

        % move folder to proper directory
        eval(strcat("movefile ", strcat('raw/_newData/',ID, " "), ...
            strcat('raw/',pathID)));

        % check if folder corresponding to ID exists for data objects, if not make it
        if ~exist(strcat('objects/',pathID), 'dir')
            mkdir(strcat('objects/',pathID))
        end

        % check if _Synchronized folder corresponding to ID exists for data 
        % objects, if not make it
        if ~exist(strcat('objects/',pathID(1:19),'/_Synchronized'), 'dir')
            mkdir(strcat('objects/',pathID(1:19),'/_Synchronized'))
        end    
    end
    
end
