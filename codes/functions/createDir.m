% FUNCTION TO MAKE DIRECTORY IN CURRENT DIRECTORY IF IT DOES NOT ALREADY
% EXIST

% CODE AUTHORED BY: SHAWHIN TALEBI
% THE UNIVERSITY OF TEXAS AT DALLAS
% MULTI-INTEGRATED REMOTE SENSING AND SIMULATION (MINTS)

function [] = createDir(directory)

% check if proper path exists for saving plots
if ~exist(directory, 'dir')

    % if not make directory
    mkdir(directory)
end 