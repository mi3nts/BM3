% FUNCTION TO CONVERT A DATA STRUCTURE (E.G. TIMETABLE) CONTAINING EEG 
% POWER SPECTRA DATA FROM COLUMNS GROUPED BY EEG ELECTRODES TO COLUMNS
% GROUPED BY FREQUENCY VALUES
% THIS IS MEANT TO BE USED TO CONVERT THE OUTPUT FROM THE EEGPowerSpectra.m
% FUNCTION

% INPUT:
%     Object_groupedByElectrodes = A DATA STRUCTUE (ARRAY, TABLE, OR
%     TIMETABLE) OF EEG POWER SPECTRA DATA GROUPED BY ELECTRODE VALUES I.E.
%     SUCH THAT FIRST 257 COLUMNS CORRESPOND TO THE POWER SPECTRUM OF
%     ELECTRODE 1, THE NEXT 257 COLUMNS CORRESPOND TO THE POWER SPECTRUM OF
%     ELECTRODE 2, AND SO ON

% OUTPUT:
%     Object_groupedByFreqValues = A DATA STRUCTUE (ARRAY, TABLE, OR
%     TIMETABLE) OF EEG POWER SPECTRA DATA GROUPED BY FREQUENCY VALUES I.E.
%     SUCH THAT THE FIRST 64 COLUMNS CORRESPOND TO THE POWER VALUES OF THE
%     THE FIRST FREQUENCY BIN FOR ALL 64 ELECTRODES, THE NEXT 64 COLUMNS 
%     CORRESPOND TO THE POWER VALUES FOR THE SECOND FREQUENCY BIN FOR ALL
%     64 ELECTRODES, AND SO ON


% THE UNIVERSITY OF TEXAS AT DALLAS
% MULTI-INTEGRATED REMOTE SENSING AND SIMULATION (MINTS)
% CODE AUTHORED BY: SHAWHIN TALEBI

function Object_groupedByFreqValues =...
    EEGPowerSpectraReorderVars(Object_groupedByElectrodes)

    % initialze an array to store "shuffling indicies", i.e. indicies that
    % reorder Timetable_groupedByElectrodes to Timetable_groupedByFreqValues
    shuffleIndx = [];

    % generate shuffleIndx array
    for i = 1:257
        shuffleIndx = [shuffleIndx; linspace(i, 16448-(257-i), 64)'];
    end

    Object_groupedByFreqValues = ...
        Object_groupedByElectrodes(:, shuffleIndx);