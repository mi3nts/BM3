% FUNCTION TO CREATE PLOTS TO EVALUATE ML REGRESSION MODELS

% CODE AUTHORED BY: SHAWHIN TALEBI
% THE UNIVERSITY OF TEXAS AT DALLAS
% MULTI-SCALE INTEGRATED REMOTE SENSING AND SIMULATION (MINTS)

%% FUNCTION

function [] = regModelPlots(modelPath, Mdl, ...
    YTrain, YTest, ...
    YTrain_predicted, YTest_predicted, ...
    modelName, PredictorNames, TargetName)

    %% EVALUATE MODEL

    % calculate mean squared error for training set
    mseTrain = mean((YTrain_predicted-YTrain).^2);

    % calculate mean squared error for testing set
    mseTest = mean((YTest_predicted-YTest).^2);

    % calculate correlation coefficent for training set
    cc_train = corrcoef(YTrain_predicted,YTrain);
    r_train = cc_train(1,2);
    r2_train = r_train^2;
    if isnan(r2_train)
        r2_train = 1;
    end

    % calculate correlation coefficent for testing set
    cc_test = corrcoef(YTest_predicted,YTest);
    r_test = cc_test(1,2);
    r2_test = r_test^2;

    % calulate error for testing set
    e = (YTest_predicted-YTest);

    %% PLOT ERROR HISTOGRAM

    % create figure
    figure(1)
    fig = gcf;
    fig.Units = 'normalized';
    fig.Position = [0 0 1 1];

    % plot error histogram
    ploterrhist(double(e))
    title(strcat(modelName, " Error Histogram"),...
        'Fontsize', 16, ...
        'Interpreter', 'none');
    ax = gca;
    ax.OuterPosition = [0 0.1 1 0.9];
    ax.FontSize = 16;
    hold off

    % save histogram
    directory = strcat(modelPath, modelName, "/Plots/ErrorHistogram/");
    createDir(directory)
    print(strcat(directory, modelName,"_ErrHist"),'-dpng')

    %% PLOT PREDICTOR IMPORTANCE

    % compute importance rankings 
    imp=predictorImportance(Mdl);

    % sort importance in descending order
    [sorted_imp,isorted_imp] = sort(imp,'descend');

    % create figure
    figure(2)
    fig = gcf;
    fig.Units = 'normalized';
    fig.Position = [0 0 1 1];


    % create bar graph of importance rankings
    n_top_bars = 20;
    try
        barh(imp(isorted_imp(1:n_top_bars)));
    catch
        barh(imp(isorted_imp));
        n_top_bars = length(isorted_imp);
    end
    hold on;grid on;
        if length(isorted_imp)>=5
            barh(imp(isorted_imp(1:5)),'y');
        else
            barh(imp(isorted_imp),'y');
        end
        if length(isorted_imp)>=3
            barh(imp(isorted_imp(1:3)),'r');
        else
            barh(imp(isorted_imp(1:n_top_bars)),'r');
        end
    title(strcat(modelName, " Predictor Importance Estimates"), ...
        'Fontsize', 20, ...
        'Interpreter', 'none');
    xlabel('Estimated Importance', 'Fontsize', 16);
    ylabel('Predictors', 'Fontsize', 16);
    set(gca,'FontSize',16); set(gca,'TickDir','out'); set(gca,'LineWidth',2);
    ax = gca;ax.YDir='reverse';ax.XScale = 'log';
    xl=xlim;
    xlim([xl(1) xl(2)*2.75]);
    ylim([.25 n_top_bars+.75])

    % label the variables
    for i=1:n_top_bars
        text(...
            1.05*imp(isorted_imp(i)),i,...
            strrep(PredictorNames{isorted_imp(i)},'_',''),...
            'FontSize',16, 'Interpreter', 'none' ...
        )
    end
    hold off

    % save graph as png
    directory = strcat(modelPath, modelName, "/Plots/ImportanceRanking/");
    createDir(directory)
    print(strcat(directory, modelName,"_ImpRank_T", string(n_top_bars)),'-dpng')

    %% PLOT SCATTER DIAGRAM OF PERFORMANCE

    % create figure
    figure(3)
    fig = gcf;
    fig.Units = 'normalized';
    fig.Position = [0 0 1 1];


    % plot training/testing actual vs model estimation and 1 to 1
    plot(YTest,YTest,'k', 'LineWidth', 2)
    hold on
    scatter(YTrain,YTrain,'go')
    hold on
    scatter(YTest_predicted,YTest,'r+')
    try
    legend("1:1", strcat("Training r^2 = ",string(r2_train-rem(r2_train,0.01))), ...
        strcat("Testing r^2 = ",string(r2_test-rem(r2_test,0.01))),...
        'FontSize', 16,'Location', 'southeast');
    catch
        disp("There was an issue computing r^2 values.")
    end
    title(strcat(modelName, " Scatter Plot"), ...
        'FontSize', 16, ...
        'Interpreter', 'none')
    xlabel(strcat("Estimated ", TargetName), 'FontSize', 16)
    ylabel(strcat("True ", TargetName), 'FontSize', 16)
    ax = gca;
    % make x and y lims equal
    maxLim = (max(max(max(YTrain), max(YTrain)),max(max(YTest_predicted),max(YTest))));
    minLim = (min(min(min(YTrain), min(YTrain)),min(min(YTest_predicted),min(YTest))));
    ax.XLim = [minLim maxLim];
    ax.YLim = [minLim maxLim];
    hold off

    % save plot to file
    directory = strcat(modelPath, modelName, "/Plots/ScatterPlots/");
    createDir(directory)
    print(strcat(directory, modelName, "_Scatter"),'-dpng')