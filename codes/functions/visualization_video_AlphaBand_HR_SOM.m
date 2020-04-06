% FUNCTION TO CREATE VIDEO VISUALIZATION INCLUDING TOBII POV VIDEO, ALPHA
% BAND EEG VISUALIZATION, HEART RATE, AND TIME SERIES OF SELF ORGANIZING 
% MAP CLASSES

% CODE AUTHORED BY: SHAWHIN TALEBI
% THE UNIVERSITY OF TEXAS AT DALLAS
% MULTI-INTEGRATED REMOTE SENSING AND SIMULATION (MINTS)

function [] = visualization_video_AlphaBand_HR_SOM(...
    YEAR, MONTH, DAY, TRIAL, USER, EEG, Tobii, ...
    iSOM, jSOM, onOffVisible)

    %% LOAD DATASETS AND FUNCTIONS

    % add eeglab functions
    addEEGLabFunctions
    
    % get dataset ID and pathID
    [ID, pathID] = makeIDs(YEAR, MONTH, DAY, TRIAL, USER, []);

    % load synchronized EEGAccelTobiiTimetable
    load(strcat('objects/',pathID, '/_Synchronized/', ID, ...
        '_Synchronized_EEGAccelTobiiTimetable.mat'));
    % load Tobii Timetable
    load(strcat('objects/',pathID, '/', Tobii, '/', ...
        ID, '_', Tobii,'_TobiiTimetable.mat'));
    % load EEG power spectra data
    load(strcat('objects/',pathID, '/', EEG, '/', ...
        ID, '_', EEG,'_EEGps.mat'));

    % load channel locations
    load(strcat('backend/channelLocations/', EEG, '_chanlocs.mat'));
    
    %% SETUP TOBII PRO GLASSES VIDEO 

    % read video
    v = VideoReader(strcat('raw/',pathID, '/', Tobii, '/', ...
        ID, '_', Tobii, '/segments/1/fullstream.mp4'));

    % get start time of entire dataset
    tobiiStartTime = seconds(EEGAccelTobiiTimetable.Properties.StartTime - ...
        TobiiTimetable.Properties.StartTime);
    v.CurrentTime = tobiiStartTime;

    % clear unnecessary variables from workspace
    clear TobiiTimetable
    %% GET SOM CLASSES

    % create variable to check whether SOM Classes are provided in Table
    hasSOMClasses = ...
        sum(strcmp(EEGAccelTobiiTimetable.Properties.VariableNames, 'Class'));

    if ~hasSOMClasses
%         disp('no SOM classes provided in EEGAccelTobiiTimetable')

        % remove meta variables from timetable
        EEGAccelTobiiTimetable = rmMetaVars(EEGAccelTobiiTimetable);
        % convert timetable to table
        Table = timetable2table(EEGAccelTobiiTimetable);
        % convert table to timetable
        Data = table2array(Table(:,2:end));
        % get SOM classes
        [classes, numClasses] = getClassesSOM(Data, iSOM, jSOM);
        % create timetable of SOM classes
        SOMTimetable = table2timetable([Table(:,1) array2table(classes', ...
            'VariableNames', "Class")]);

    end

    % get HR data
    HR = EEGAccelTobiiTimetable.HR;

    % get sample rate of biometric data
    dataSampleRate = EEGAccelTobiiTimetable.Properties.SampleRate;

    % clear unnecessary variables from workspace
    clear EEGAccelTobiiTimetable Table
    
    %% GET ALPHA BAND POWER

    alphaBand = getAlphaBand(EEGps);

    % clear unnecessary variables from workspace
    clear EEGps
    %% SET UP FIGURES

    fig1 = figure(1);
    fig1.Units = 'normalized';
    fig1.Position = [0 0 1 1];
    fig1.Visible = onOffVisible;

    %% PLOT SOM CLASSES OVER TIME

    % define maximum class value
    y = max(SOMTimetable.Class) + round(0.1*max(SOMTimetable.Class));

    % plot class time series
    subplot(2, 7, 8:14)
    plot(SOMTimetable.Datetime, SOMTimetable.Class)
    title('SOM Classes Over Time', 'FontSize', 18)
    hold on
    % initilize time mark time
    plot(SOMTimetable.Datetime([1 1]),[0 y])
    %% RUN VISUALIZATION

    % define number of records
    numRecords = max(size(alphaBand));

    % define colormap for HR plot
    cmap = colormap(hot);

    % define directory to save video
    directory = strcat('visuals/', pathID,'/videos/');

    % create directory if it does not alreay exist
    createDir(directory)

    % set up writer object to record plot (uncomment this for recording)
    writerObj = VideoWriter(...
        strcat(directory, ID,'_video_EEGps_HR_SOM', ...
        string(iSOM),'by', string(jSOM)), ...
        'MPEG-4');
    writerObj.FrameRate = v.FrameRate;
    open(writerObj);

    for i = 1:round(dataSampleRate/v.FrameRate):numRecords

        % update video
        subplot(2, 7, 1:3)
        videoAxes = gca;
        vidFrame = readFrame(v);
        image(vidFrame, 'Parent', videoAxes);
        videoAxes.Visible = 'off';

        % update SOM time series
        subplot(2, 7, 8:14)
        % get current axis
        ax = gca;    
        % delete old time mark line
        delete(ax.Children(1))
        % plot new time mark line
        plot(SOMTimetable.Datetime([i i]),[0 y], ...
            'r--', 'LineWidth', 1);

        % update HR plot
        subplot(2, 7, 7)
        b = bar(HR(i));
        b.Parent.XLim = [0.25 1.75];
        b.Parent.YLim = [0 220];
        b.FaceColor = cmap(HR(i)+50,:);
        ax = gca; ax.XTickLabel = '';
        ax.YAxis.FontSize = 16;
        ax.Title.String = 'Heart Rate (bpm)';
        ax.Title.FontSize = 18;
        text(1, 200, string(HR(i)), 'Fontsize', 32, ...
            'Fontweight', 'bold', 'HorizontalAlignment', 'center')


        % update EEG PS
        subplot(2, 7, 4:6)
        % clear old topoplot
        cla('reset')
        if ~isnan(alphaBand(i,1))
            % plot new topoplot
            topoplot(alphaBand(i,:), EEG01_chanlocs, 'conv', 'on');
            % update all plots now
            drawnow
        else
            % update all plots now
            drawnow
        end

        % get frame and add to video object (uncomment this for recording)
        frame = getframe(fig1);
        writeVideo(writerObj,frame);

    end

    % close video
    close(writerObj)
