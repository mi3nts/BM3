


% CODE AUTHORED BY: SHAWHIN TALEBI
% THE UNIVERSITY OF TEXAS AT DALLAS
% MULTI-INTEGRATED REMOTE SENSING AND SIMULATION (MINTS)

function newStruct = getNextLevel(currStruct, i)

    currFolder = eval(strcat("currStruct.subdirList(",string(i),")"));

    % for each sub dir in current hfs stucture, cd to subfolder and 
    eval(strcat("cd ", currFolder));

    % create handle for current structure
    eval(strcat("currStruct = '", ...
        currStruct,".dir_",currFolder, ...
        "';"));
    % convert from char array to string
    currStruct = string(currStruct);

    % add field of list of subdirectories
    eval(strcat(currStruct,".subdirList = subDirs();"));

    % add subdirectory fields to structure
    eval(strcat(currStruct," = addSubDirFields(",currStruct,");"));

    newStruct = currStruct;