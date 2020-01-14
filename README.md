# BM3

## About

__BM3__ is a hierarchical file system and function library written using MATLAB that can be used to organize, analyze, and visualize biometric data. The file system consists of a home directory called __BM3__. The home directory has the following five subdirectories:

* __backend__  - dependencies beyond BM3’s function definitions 
* __codes__ - codes and functions for data organization, analysis, and visualization 
* __objects__  - formatted data as MATLAB data types
* __raw__ - raw data
* __visuals__ - visualizations such as plots and movies

## Quickstart

__BM3__ is designed to be mobile and easy to use. To get started complete the following steps:

1. Clone/install the repo (https://github.com/mi3nts/BM3) to your desired working folder
2. Navigate to the following directory: BM3/codes/functions
3. Call the function homeDir(). This function changes the current directory to BM3/ and adds any necessary paths. 
4. __BM3__ is now ready to use!

## Backend

The __BM3__ library includes functions built using the EEGLAB library. EEGLAB is an open source signal processing environment for electrophysiological signals running on MATLAB and developed at the SCCN/UCSD https://eeglab.ucsd.edu/. A compatible version of EEGLAB is included with BM3 in the /backend subdirectory.

The latest version of EEGLAB can be downloaded here: https://sccn.ucsd.edu/eeglab/download.php. __NOTE__: newer versions of EEGLAB (later than 2019_0) may not be compatible with __BM3__. For guaranteed operation please use version of EEGLAB provided.

More information on EEGLAB can be found here: https://sccn.ucsd.edu/eeglab/index.php

## Codes

Example codes and function source codes can be found in the /codes subdirectory. Example codes should run fine without any preceding steps. However, before calling functions it is important to follow the steps outlined in the Quickstart section of this documentation.

The simplest way to call __BM3__ functions is from the command window. However, this may not always be practical. To use library functions in user-defined scripts complete the following steps:

1. Create new script and save it anywhere in the /codes subdirectory. This includes any custom folders, sub-folders, sub-sub-folders, etc. 
2. At the top of your script call the function: homeDir(). This will find the home directory for you, and add all the __BM3__ functions to the current path.
3. (If not already done) Copy and paste the homeDir.m file from the /codes/functions subdirectory to the folder containing your user-defined script.
4. Run your code!
