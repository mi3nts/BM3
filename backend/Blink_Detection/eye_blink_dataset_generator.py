# -*- coding: utf-8 -*-

# import the necessary packages
from scipy.spatial import distance as dist
from imutils import face_utils
import argparse
import imutils
import time
import dlib
import cv2
import pandas as pd
import os

# calculates the eye aspect ratio
# input - eye landmarks
# return - eye aspect ratio
def eye_aspect_ratio(eye):
    # compute the euclidean distances between the two sets of
    # vertical eye landmarks (x, y)-coordinates
    A = dist.euclidean(eye[1], eye[5])
    B = dist.euclidean(eye[2], eye[4])
    # compute the euclidean distance between the horizontal
    # eye landmark (x, y)-coordinates
    C = dist.euclidean(eye[0], eye[3])
    # compute the eye aspect ratio
    ear = (A + B) / (2.0 * C)
    # return the eye aspect ratio
    return ear


# detects blinks and returns the data structure with the information
# input - the video to analyze, and the shape predictor to get the facial landmarks
# return - the data structure with the information
def blink_detect_data(video):
    data_dict = {'TimeStamp': [], 'Blink_Flag_EAR': [], 'Cumulative_NumBlinks': [], 'Left_EAR': [], 'Right_EAR': [],
                 'EAR_Avg': []}
    
    # define two constants, one for the eye aspect ratio to indicate
    # blink and then a second constant for the number of consecutive
    # frames the eye must be below the threshold
    # modify both if needed
    EYE_AR_THRESH = 0.2
    EYE_AR_CONSEC_FRAMES = 3
    # initialize the frame counters and the total number of blinks
    COUNTER = 0
    TOTAL = 0
    
    # initialize dlib's face detector (HOG-based) and then create
    # the facial landmark predictor
    #print("[INFO] loading facial landmark predictor...")
    detector = dlib.get_frontal_face_detector()
    predictor = dlib.shape_predictor('shape_predictor_68_face_landmarks.dat')
    
    # grab the indexes of the facial landmarks for the left and
    # right eye, respectively
    (lStart, lEnd) = face_utils.FACIAL_LANDMARKS_IDXS["left_eye"]
    (rStart, rEnd) = face_utils.FACIAL_LANDMARKS_IDXS["right_eye"]
    
    time.sleep(1.0)
    
    face = cv2.imread('face.jpg')
    
    
    # loop over frames from the video stream
    while True:
        # read frame from open cv
        ret, frame = video.read()
        
        if ret is None or frame is None:
            break
        
        data_dict['TimeStamp'].append(video.get(cv2.CAP_PROP_POS_MSEC)) # add timestamp value to dataset
        
        #print(frame.shape)
        right_eye = frame[250:460, 0:240] # right eye, modify values based on how big eye is
        h, w, layers = right_eye.shape
        frame_right = cv2.resize(right_eye, (int(w / 2), int(h / 2))) # resize the frame to fit on the face
        
        left_eye = frame[750:960, 0:240] # left eye
        h2, w2, l2 = left_eye.shape
        frame_left = cv2.resize(left_eye, (int(w2 / 2), int(h2 / 2)))  # resize the frame to fit on the face
        
        # overwrite face image with right eye from stream, change dimensions to get eye detected
        face[220:325, 540:660] = frame_right 
        
        # overwrite face image with left eye from stream, change dimensions to get eye detected
        face[235:340, 385:505] = frame_left # overwrite face image with left eye from stream
        
        frame = imutils.resize(face, width=450)
        
        gray = cv2.cvtColor(frame, cv2.COLOR_BGR2GRAY)
        # detect faces in the grayscale frame
        rects = detector(gray, 0)
        
        # loop over the face detections
        for rect in rects:
            # determine the facial landmarks for the face region, then
            # convert the facial landmark (x, y)-coordinates to a NumPy
            # array
            shape = predictor(gray, rect)
            shape = face_utils.shape_to_np(shape)
            # extract the left and right eye coordinates, then use the
            # coordinates to compute the eye aspect ratio for both eyes
            leftEye = shape[lStart:lEnd]
            rightEye = shape[rStart:rEnd]
            leftEAR = eye_aspect_ratio(leftEye)
            data_dict['Left_EAR'].append(leftEAR)
            rightEAR = eye_aspect_ratio(rightEye)
            data_dict['Right_EAR'].append(rightEAR)
            
            # average the eye aspect ratio together for both eyes
            ear = (leftEAR + rightEAR) / 2.0
            data_dict['EAR_Avg'].append(ear)
            
            # compute the convex hull for the left and right eye, then
            # visualize each of the eyes
            leftEyeHull = cv2.convexHull(leftEye)
            rightEyeHull = cv2.convexHull(rightEye)
            cv2.drawContours(frame, [leftEyeHull], -1, (0, 255, 0), 1)
            cv2.drawContours(frame, [rightEyeHull], -1, (0, 255, 0), 1)
            
            # check to see if the eye aspect ratio is below the blink
            # threshold, and if so, increment the blink frame counter
            if ear < EYE_AR_THRESH:
                COUNTER += 1
                
                data_dict['Blink_Flag_EAR'].append(0)
                data_dict['Cumulative_NumBlinks'].append(TOTAL)
                
            # otherwise, the eye aspect ratio is not below the blink
            # threshold
            else:
                # if the eyes were closed for a sufficient number of
                # then increment the total number of blinks
                if COUNTER >= EYE_AR_CONSEC_FRAMES:
                    TOTAL += 1
                    data_dict['Blink_Flag_EAR'].append(1)
                else:
                    data_dict['Blink_Flag_EAR'].append(0)
                
                data_dict['Cumulative_NumBlinks'].append(TOTAL)
                
                # reset the eye frame counter
                COUNTER = 0
        """       
            # draw the total number of blinks on the frame along with
            # the computed eye aspect ratio for the frame
            cv2.putText(frame, "Blinks: {}".format(TOTAL), (10, 30),
                cv2.FONT_HERSHEY_SIMPLEX, 0.7, (0, 0, 255), 2)
            cv2.putText(frame, "EAR: {:.2f}".format(ear), (300, 30),
                cv2.FONT_HERSHEY_SIMPLEX, 0.7, (0, 0, 255), 2)
        
        # show the frame - comment out if not needed
        cv2.imshow("Frame", frame)
        """
        key = cv2.waitKey(1) & 0xFF
        
        # if the `q` key was pressed, break from the loop
        if key == ord("q"):
            break
    
    # do a bit of cleanup
    cv2.destroyAllWindows()
    
    return data_dict

# converts the eyestream video to csv and saves it to given file
# input -  the filepath to the eyesteream video, and the filepath to where the csv should be saved
def eyestream_video_to_csv(video_path, output_filepath):
    if os.path.exists(video_path):
        video = cv2.VideoCapture(video_path)
        
        data_dict = blink_detect_data(video)
        
        df = pd.DataFrame.from_dict(data_dict)
    
        df['TimeStamp'] = pd.to_datetime(df['TimeStamp'], unit='ms') # convert ms to timestamp
    
        df.to_csv(output_filepath, index=False)
    else:
        print('Specified video path does not exist')
    
if __name__ == '__main__':
    # construct the argument parse and parse the arguments
    ap = argparse.ArgumentParser()
    ap.add_argument("-v", "--video", type=str, required=True,
        help="path to input video file")
    ap.add_argument("-o", "--output", type=str, required=True,
        help="path to output csv file")
    args = vars(ap.parse_args())
    
    video_path = args['video']
    output_path = args['output']
    
    eyestream_video_to_csv(video_path, output_path)
