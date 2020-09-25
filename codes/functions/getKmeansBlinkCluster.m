% FUNCTION TO LABEL BLINKS USING MINIMUM DISTANCE TO KMEANS CLUSTERING 
% CENTROIDS ON EYE IMAGES COLLECTED WITH TOBII PRO GLASSES 2 

% CODE AUTHORED BY: SHAWHIN TALEBI
% THE UNIVERSITY OF TEXAS AT DALLAS
% MULTI-SCALE INTEGRATED REMOTE SENSING AND SIMULATION (MINTS)

function [clusterNumber, distanceMatrix] = getKmeansBlinkCluster(img, C, bias)

    % reshape image array to be 1D
    X = reshape(double(img), [1 960*240]);
    % get shape of centroid matrix
    [sz1 sz2] = size(C);

    % initialize matrix of distances between input image and centroids
    distanceMatrix = zeros(1, sz1);

    % compute distances between input image and centroids
    for i = 1:sz1

        distanceMatrix(i) = norm(C(i,:)-X);

    end
    
    % apply bias vector to distance matrix
    distanceMatrix = distanceMatrix-bias; 

    % get cluster number
    [~, clusterNumber] = min(distanceMatrix);