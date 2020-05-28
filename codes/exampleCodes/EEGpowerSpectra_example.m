clear; close all; clc

% EXAMPLE CODE TO IMPORT EEG DATA USING BM3 AND COMPUTE THE FULL POWER
% SPECTRA FOR EACH ELECTRODE

% CODE AUTHORED BY: SHAWHIN TALEBI
% THE UNIVERSITY OF TEXAS AT DALLAS
% MULTI-INTEGRATED REMOTE SENSING AND SIMULATION (MINTS)

%% IMPORT FUNCTIONS AND CHANGE TO BM3 HOME DIRECTORY
homeDir

%% DEFINE INPUTS PARAMETERS

% define string inputs corresponding to desired dataset
[YEAR, MONTH, DAY, TRIAL, USER, DEVICE] = ...
    decodeID('2019_12_2_T03_U001_EEG01_');

%% COMPUTE POWER SPECTRA AND SAVE TO FILE

% compute power spectra of 64 electrode EEG for the data corresponding to
% the string inputs. NOTE: last input of EEGPowerSpectra function is the
% Number of Workers desired for parallel processing. If you do not wish to
% use parallel processing leave it as [] (but it may take a while).
EEGPowerSpectra(YEAR, MONTH, DAY, TRIAL, USER, DEVICE, 6)

% data structure is now saved to directory objects/2019/12/5/T05/U011/EEG01
%% LOAD POWER SPECTRA DATA STRUCTURE

% define object name
ObjectName = 'EEGps';

% load EEG power spectra data structure
EEGps = LoadObject(YEAR, MONTH, DAY,...
    TRIAL, USER, DEVICE, ObjectName);
