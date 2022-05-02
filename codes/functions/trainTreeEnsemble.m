% FUNCTION TO TRAIN ENSEMBLE OF TREES



% CODE AUTHORED BY: SHAWHIN TALEBI
% THE UNIVERSITY OF TEXAS AT DALLAS
% MULTI-SCALE INTEGRATED REMOTE SENSING AND SIMULATION (MINTS)

function Mdl = trainTreeEnsemble(X, Y, numWorkers)

% if a parallel pool doesn't exsist make one
if isempty(gcp('nocreate'))

    % create pool with numWorkers
    parpool(numWorkers);
    
end

% if target is categorical perform classification
if iscategorical(Y)

    % train regression model
    Mdl = fitcensemble(X, Y,...
        'OptimizeHyperparameters','all',...
        'HyperparameterOptimizationOptions',...
        struct(...
        'AcquisitionFunctionName','expected-improvement-plus',...
        'MaxObjectiveEvaluations', 30,...
        'UseParallel',true)...
        );
else
    % train classification model
    Mdl = fitrensemble(X, Y,...
        'OptimizeHyperparameters','all',...
        'HyperparameterOptimizationOptions',...
        struct(...
        'AcquisitionFunctionName','expected-improvement-plus',...
        'MaxObjectiveEvaluations', 30,...
        'UseParallel',true)...
        );
end