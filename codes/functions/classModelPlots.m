% FUNCTION TO CREATE PLOTS TO EVALUATE ML CLASSIFICATION MODELS

% CODE AUTHORED BY: SHAWHIN TALEBI
% THE UNIVERSITY OF TEXAS AT DALLAS
% MULTI-SCALE INTEGRATED REMOTE SENSING AND SIMULATION (MINTS)

%% FUNCTION

function [] = classModelPlots(modelPath, Mdl, ...
    YTrain, YTest, ...
    YTrain_predicted, YTest_predicted, ...
    modelName, PredictorNames)

    %% PLOT CONFUSION MATRIX
    
    % remove unused categories from categorical arrays
    YTrain = removecats(YTrain);
    YTest = removecats(YTest);
    YTrain_predicted = removecats(YTrain_predicted);
    YTest_predicted = removecats(YTest_predicted);
    
    % plot traing confusion matrix
    figure(1)
    fig = gcf;
    fig.Units = 'normalized';
    fig.Position = [0 0 1 1];
    plotconfusion(YTrain, YTrain_predicted)
    
    % save training confusion matrix
    directory = strcat(modelPath,modelName,"/Plots/ConfusionMatrices/");
    createDir(directory)
    print(strcat(directory, modelName,"_TrainingConfusion"),'-dpng')
    
    % plot traing confusion matrix
    figure(2)
    fig = gcf;
    fig.Units = 'normalized';
    fig.Position = [0 0 1 1];
    plotconfusion(YTest, YTest_predicted)
    
    % save training confusion matrix
    print(strcat(directory, modelName,"_TestingConfusion"),'-dpng')
    %% PLOT PREDICTOR IMPORTANCE

    % compute importance rankings 
    imp=predictorImportance(Mdl);

    % sort importance in descending order
    [sorted_imp,isorted_imp] = sort(imp,'descend');

    % create figure
    figure(3)
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
    directory = strcat(modelPath, modelName,"/Plots/ImportanceRanking/");
    createDir(directory)
    print(strcat(directory, modelName,"_ImpRank_T", string(n_top_bars)),'-dpng')