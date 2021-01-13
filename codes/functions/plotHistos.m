% FUNCTION TO PLOT HISTOGRAMS FOR EVERY VARIABLE IN TABLE OR TIMETABLE

% INPUTS:
%     Table = table or timetable with variables
% OUPUTS:
%     none
%     NOTE: figure windows will be created with histograms but function
%     will not return any outputs

% CODE AUTHORED BY: SHAWHIN TALEBI
% THE UNIVERSITY OF TEXAS AT DALLAS
% MULTI-SCALE INTEGRATED REMOTE SENSING AND SIMULATION (MINTS)

function [] = plotHistos(Table)

    % get shape of input table
    [~, numPlots] = size(Table);

    % check if number of plots is > 36
    if numPlots>36
        % set number of plots for current function call to 36
        numPlots = 36;
        % call function for variables beyond 36
        plotHistos(Table(:,37:end))
    end

    % create figure to plot histograms
    fig = figure();
    fig.Units = 'normalized';
    fig.Position = [0 0 1 1];

    % use following heuristic to define number of rows and columns in
    % figure window
    numRows = floor(sqrt(numPlots));
    numCols = ceil(numPlots/numRows);

    % plot histograms in figure
    for i = 1:numPlots
        subplot(numRows,numCols, i)
        histogram(Table(:,i).Variables)
        % create title for ith histogram
        title(Table.Properties.VariableNames(i), ...
            'FontSize', 16, ...
            'Interpreter', 'none')
    end
    
end