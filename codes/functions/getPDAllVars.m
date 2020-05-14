% FUNCTION TO COMPUTE AND APPEND VARIOUS PUPIL AND GAZE VARIABLES TO A
% TIMETABLE CONSISTING OF TOBII PRO GLASSES 2 DATA

% VARIABLES THAT ARE COMPUTED AND APPENDED:
%     1. AVERAGE PUPIL DIAMETER
%     2. PUPIL DIAMETER DIFFERENCE
%     3. PUPIL CENTER DISTANCE IN X DIRECTION (TOWARD LEFT EAR)
%     4. PUPIL CENTER DISTANCE IN Y DIRECTION (POINTING UP)
%     5. PUPIL CENTER DISTANCE IN Z DIRECTION (POINTING FORWARD)
%     6. PUPIL CENTER DISTANCE IN 3D
%     7. MOVING AVERAGE OF PUPIL CENTER DISTANCE IN 3D IN 1 SECOND WINDOW
%     8. MOVING VARIANCE OF PUPIL CENTER DISTANCE IN 3D IN 1 SECOND WINDOW
%     9. MOVING REPRESENTATIVENESS OF PUPIL CENTER DISTANCE IN 3D IN 1 
%        SECOND WINDOW
%     10. LEFT PUPIL AREA
%     11. RIGHT PUPIL AREA
%     12. PUPIL AREA DIFFERENCE
    

% THE UNIVERSITY OF TEXAS AT DALLAS
% MULTI-INTEGRATED REMOTE SENSING AND SIMULATION (MINTS)
% CODE AUTHORED BY: SHAWHIN TALEBI

function newTobiiTimetable = getPDAllVars(oldTobiiTimetable)

    % get average pupil diameter 
    oldTobiiTimetable = getPDAverage(oldTobiiTimetable);
    
    % get pupil diameter difference
    oldTobiiTimetable = getPDDiff(oldTobiiTimetable);
    
    % get X,Y,Z pupil center ditance, 3D pupil center distance, and 3D
    % pupil center distance moving average, moving variance, and moving
    % representativeness (standard deviation) in 1 second window
    oldTobiiTimetable = getPCDistance(oldTobiiTimetable);
    
    % get left and right pupil area and pupil area difference
    newTobiiTimetable = getPupilArea(oldTobiiTimetable);