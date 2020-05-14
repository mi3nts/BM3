# BM3

## About

__BM3__ is an open source hierarchical file system and function library implemented in MATLAB to organize, analyze, and visualize biometric data.  The file system consists of a home directory called __BM3__. The home directory has the following five subdirectories:

* __backend__  - dependencies beyond BM3’s function definitions 
* __codes__ - codes and functions for data organization, analysis, and visualization 
* __objects__  - formatted data as MATLAB data structures
* __raw__ - raw data
* __visuals__ - visualizations such as plots and videos

## Functionality 

__BM3__ is tailored to meet the specific research needs of MINTS, a research group from The University of Texas at Dallas. In other words, its functionality is not meant to suit all biometric research applications. However, we hope to provide value to researchers working on similar problems by sharing our software tools and hope to benefit from open-source collaboration.

The hardware systems that are readily compatible with __BM3__ include:

* Cognionics Mobile-128 EEG (64 electrode): https://www.cgxsystems.com/mobile-128
* Cognionics AIM2 module: https://www.cgxsystems.com/auxiliary-input-module-gen2
* Tobii Pro Glasses 2: https://www.tobiipro.com/product-listing/tobii-pro-glasses-2/

Raw data from these systems can be read, aligned, and merged into aggregate dataset using __BM3__.

## Quickstart

__BM3__ is designed to be mobile and easy to use. To get started complete the following steps:

1. Clone/install the repo (https://github.com/mi3nts/BM3) to your desired working folder
2. Navigate to the following directory: BM3/codes/functions
3. Call the function homeDir(). This function changes the current directory to BM3/ and adds any necessary paths. 
4. __BM3__ is now ready to use!

## Backend

The __BM3__ library includes functions built using the EEGLAB library. EEGLAB is an open source signal processing environment for electrophysiological signals running on MATLAB and developed at the SCCN/UCSD https://eeglab.ucsd.edu/. A compatible version of EEGLAB is included with BM3 in the /backend subdirectory.

The latest version of EEGLAB can be downloaded here: https://sccn.ucsd.edu/eeglab/download.php. __NOTE__: newer versions of EEGLAB (later than 2019_1) may not be compatible with __BM3__. For guaranteed operation please use the version of EEGLAB provided.

More information on EEGLAB can be found here: https://sccn.ucsd.edu/eeglab/index.php

## Codes

Example codes and function source codes can be found in the /codes subdirectory. Example codes should run without any preceding steps.

The simplest way to call __BM3__ functions is from the command window (after following steps 2 and 3 outlined in the _*Quickstart*_ section). However, this may not always be practical. To utilize BM3’s function library in your user-defined scripts complete the following steps:

1. Create new script and save it anywhere in the /codes subdirectory. This includes any custom folders, sub-folders, sub-sub-folders, etc. 
2. At the top of your script call the function: homeDir(). This will find the home directory for you, and add all the __BM3__ functions to the current path.
3. (If not already done) Copy and paste the homeDir.m file from the /codes/functions subdirectory to the folder containing your user-defined script.
4. Run your code!

## Objects

The /objects subdirectory organizes data structures that can be readily used in analysis. Typically data is stored as a MATLAB timetable (see: https://www.mathworks.com/help/matlab/timetables.html?s_tid=mwa_osa_a). 

Data are organized by the following naming convention: __YYYY_MM_DD_TXX_UXXX_DeviceXX__. 

For example, data collected on May 1st, 2019 during the 3rd trial of that day, for a participant with user ID U000, using a Tobii Pro Glasses 2 eye tracking system would correspond to: 2019_05_01_T03_U000_Tobii01. 

__NOTE__: trial, user, and device label conventions are defined by the researcher, ideally, such that unique IDs exist across multiple trials, participants, and devices.

This is referred to as the file ID or simply just ID. __IDs are a critical component of BM3__. They provide a flexible way to interface with several datasets without manually loading them into the workspace. More detail on this is given in the proceeding sections.

Within the /objects subdirectory, datasets are saved based on their ID. Using the example given above, the corresponding path where that dataset is saved would be: /objects/2019/05/01/T03/U000/Tobii01/.

__NOTE__: timetables of data merged from multiple devices will appear in the ./_Synchronized/ subdirectory as opposed to ./Tobii01/ or ./EEG01/

And the corresponding filename would be: 2019_05_01_T03_U000_Tobii01_TobiiTimetable.mat 

Although filenames and locations are verbose and may seem tedious to navigate, this is rarely an issue since __data is processed via the ID__. A quick example is given here. This is taken from the LoadEEGData_example.m in the /codes/exampleCodes subdirectory.

### Quick Example

>Let's define an ID for a dataset:

`ID = '2019_12_5_T03_U010_EEG01_';`

>This ID references data recorded on December 5th, 2019. It is trial 3 of the experiment, the user ID is U010, and the ID of EEG system used is EEG01.

>With our ID we can generate the following strings: YEAR, MONTH, DAY, TRIAL, USER, DEVICE. These strings will be used as function inputs in the proceeding sections. To get these strings we can use the function "decodeID()"

>Get YEAR, MONTH, DAY, TRIAL, USER, and DEVICE strings:

`[YEAR, MONTH, DAY, TRIAL, USER, DEVICE] = decodeID(ID);`

>We can now read the raw data using the function "EEGread()":

`EEGRead(YEAR, MONTH, DAY, TRIAL, USER, DEVICE)`

>"EEGread()" will create a timetable of the data corresponding to the given input strings. This timetable is then automatically saved to the directory "objects/YYYY/MM/DD/TXX/UXXX/EEGXX/"
>__NOTE__: the timetable will NOT be returned by EEGread in the current workspace, we will need to do one additional step to import this timetable.

>Now that we have read our raw data and saved it as a timetable we just need to bring the timetable into our workspace. We can this using the "LoadTimetable()" function.

>Call LoadTimetable() function:

`[Timetable, ID, pathID, TT] = LoadTimetable(YEAR, MONTH, DAY, TRIAL, USER, DEVICE);`

>The timetable is now in the workspace with the name "Timetable"! ID returns a new ID corresponding to our timetable, pathID is the path where the timetable was saved, and TT is name for the timetable corresponding to the data in it.

>It is often not necessary to return ID, pathID, and TT from the "LoadTimetable()" function. If we are only interest in the timetable we can only return that object.

>Call LoadTimetable() function, but only return timetable:

`Timetable = LoadTimetable(YEAR, MONTH, DAY, TRIAL, USER, DEVICE);`

## Raw

The /raw subdirectory is structured similarly to /objects. The key distinction is that data saved in /raw are typically in formats unsuitable for direct analysis and require some form of processing. Let’s take a look at the preceding steps to the example presented above, again this script can be found in the /codes/exampleCodes subdirectory.

### Quick Example Revisited

> The first thing we need to do is navigate to the "home" directory of the BM library and then add the library functions to the current path. This is to ensure that the libary works properly. This can be acheived by executing the function "homeDir", which should be included in the current folder, if not, it is available in the directory BM3/codes/functions. 
__NOTE__: homeDir does not take any inputs or have any outputs

`homeDir`

>To start processing raw EEG data it is recommended to include all data folders/files in the `"raw/_newData"` directory. For EEG data recorded  using the Cognionics Mobile-128, the following data files are required: a .eeg file, .vhdr file, and .vmrk file. These files should be stored in a single folder with a name corresponding to the data's ID. The ID for a dataset is a unique identifier that is heavily utilized by the BM library to access data saved within the BM directory structure. The format for a EEG dataset's ID is the following: YYYY_MM_DD_TXX_UXXX_EEGXX_, where YYYY is the year the data was recorded, MM the month, and DD is the day. Here, the X's following T, U, and EEG are integers that correspond to the dataset's trial number, user number, and EEG system number, respectively.

>Example raw data can be found in the `"codes/exampleCodes/_resources"` directory. Copy the "2019_12_5_T03_U010_EEG01" folder in this directory, and drop it into the "raw/_newData" directory.

>Once all raw data folders are placed in the `"raw/_newData"` folder we  can run the "initial" function to make/save the raw data to their proper branches in the "raw" directory.
>__NOTE__: initial does not take any inputs or have any outputs

`initial`

And that’s it! The raw data is now in BM3 and ready for further processing. However, it is critical to note the importance of properly naming data files and folders. For the Cognionics systems it best to have the proper filename when recording the data!

## Visuals

Just like /objects and /raw, the /visuals subdirectory is organized based on the file ID. Any visualizations created for a particular dataset by a BM3 function will be saved in the corresponding pathID within /visuals.

## Tips for BM3

Although it is possible to use BM3 strictly from the command window, it is best utilized through user defined functions. Beyond the basic set-up given in the Code section, some common utility functions are listed below. More information is provided in function source codes via developer comments.

* __[ ] = homeDir()__: Function to change path to home directory of BM3 file structure

* __[ ] = createDir(directory)__: Function to make new directory in input path if it does not already exist 

* __[YEAR, MONTH, DAY, TRIAL, USER, DEVICE]__ = decodeID(ID): Function to convert input ID to YEAR, MONTH, DAY, TRIAL, USER, DEVICE strings.

 * __[ID, pathID] = makeIDs(YEAR, MONTH, DAY, TRIAL, USER, DEVICE)__: Function to create ID and pathID from YEAR, MONTH, DAY, TRIAL, USER, DEVICE strings. Inverse of decodeID().

* __fileIDs = findAllFiles(dataRootFolder, dataObjectName)__: Function to find all data files of a certain kind in BM3 and return their file IDs

* __[ ] = initial()__: Function to initialize new biometric data in directory structure. Code reads all folders in the _newData folder and creates/puts it in the proper directory and creates directories for future data structures.

* __[objectStruct, fileIDs] = LoadAll(dataObjectName, DEVICE)__:  Function to load all objects of a certain kind into a data structure.

* __[mergedObject, fileIDs] = LoadMergeAll(dataObjectName, DEVICE)__: Function to load all objects of a certain kind and merge into a single merged object

* __[Object, ID, pathID] = LoadObject(YEAR, MONTH, DAY, TRIAL, USER, DEVICE, ObjectName)__: Function to load any objects in the BM3/objects subdirectory 

* __[Timetable, ID, pathID, TTname] = LoadTimetable(YEAR, MONTH, DAY, TRIAL, USER, DEVICE)__: Function to load a timetable

* __[ ] = Timetable2csv(YEAR, MONTH, DAY, TRIAL, USER, DEVICE)__: Function to convert a timetable to a .csv file. File is saved in the same directory as the corresponding timetable.

* __[ ] = Timetable2csvMulti(YEAR, MONTH, DAY, USER, DEVICE, TrialNumbers, NumberOfWorkers)__: Performs same function as Timetable2csv but multiple trials can be specified and operation can be done in parallel

There are key words in BM3 function names, typically at the beginning or end, that describe what the function does. Common key words are outlined below.

* __EEG__: Function performs processing on EEG data e.g. EEGPowerSpectra() which computes the moving window power spectra for each electrode over time. These functions typically have no output variables. Processed data are saved to the corresponding path based on ID.

* __Tobii__: Function performs processing on Tobii data e.g. TobiiRead() which reads in raw Tobii data as a timetable. These functions typically have no output variables. Processed data are saved to the corresponding path based on ID.

* __Read__: Coverts data in raw format to a timetable. Example: EEGRead()

* __Multi__: Performs root function for several trials and can be done in parallel. Example: EEGReadMulti()

* __get__: Performs some computation that returns an output. Example: getAlphaBand() which computes alpha band power from EEG power spectra

* __Load__: Loads some data structure into the workspace. Example: LoadTimetable()

* __visualize__: Creates some kind of visualization and saves it to the /visuals subdirectory. Example: visualizeHR().

## Reference

If you find value in __BM3__ for your research please use the following citation: 

`Talebi S., et al. BM3: Organize, analyze, and visualize biometric data. 2019. https://github.com/mi3nts/BM3`

__Bibtex__:
```
@misc{BM3,
authors={Shawhin Talebi & David J. Lary},
title={BM3: {Organize, analyze, and visualize biometric data}},
howpublished={https://github.com/mi3nts/BM3}
year={2019}
}
```
