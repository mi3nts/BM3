from vosk import Model, KaldiRecognizer, SetLogLevel
import os
import subprocess
import json
from detoxify import Detoxify
import pandas as pd
import argparse

# converts the audio file to text
# input - the audio file
# returns the text, where each phrase spoken is on a new line
def convert_audio_to_text(file):
    SetLogLevel(0)
    
    result = ""
    
    if not os.path.exists("model"):
        print ("Please download the model from https://alphacephei.com/vosk/models and unpack as 'model' in the current folder.")
        exit (1)
    
    sample_rate=16000
    model = Model("model")
    rec = KaldiRecognizer(model, sample_rate)
    
    process = subprocess.Popen(['ffmpeg', '-loglevel', 'quiet', '-i',
                                file,
                                '-ar', str(sample_rate) , '-ac', '1', '-f', 's16le', '-'],
                                stdout=subprocess.PIPE)
    
    while True:
        data = process.stdout.read(4000)
        if len(data) == 0:
            break
        if rec.AcceptWaveform(data):
            r = json.loads(rec.Result())
        
            if r['text'] != '':
                result += r['text'] + "\n\n"
            #print(r['text'])
        #else:
            #print(rec.PartialResult())
    
    #print(rec.FinalResult())
    
    return result

# generates the toxicity analysis for the given text
# input - the text to be analyzed
# output - the toxicity analysis based
def toxicity_report(text):
    results = Detoxify('original').predict(text)
    df = pd.DataFrame(results, index=[0])
    df = df * 100
    
    text_display = 'Text Toxicity Analysis:\n'
    text_display += 'Toxicity: %.3f\n' %(df['toxicity'])
    text_display += 'Severe Toxicity: %.3f\n' %(df['severe_toxicity'])
    text_display += 'Obscene: %.3f\n' %(df['obscene'])
    text_display += 'Threat: %.3f\n' %(df['threat'])
    text_display += 'Insult: %.3f\n' %(df['insult'])
    text_display += 'Identity Hate: %.3f\n' %(df['identity_hate'])
    
    return text_display

# generates the text file with the audio script and the toxicity analysis
# input - the path to the audio file
# input - the output path where the text file should be
def audio_to_text_output(audio_path, output_path):
    if os.path.exists(audio_path):
        text = convert_audio_to_text(audio_path)
        toxicity_text = toxicity_report(text)
        
        text_file = open(output_path, 'w')
        
        text_file.write(text)
        text_file.write(toxicity_text)
        text_file.close()
    else:
        print('Specified audio path does not exist')
    
if __name__ == '__main__':
    # construct the argument parse and parse the arguments
    ap = argparse.ArgumentParser()
    ap.add_argument("-a", "--audio", type=str, required=True,
        help="path to input audio file")
    ap.add_argument("-o", "--output", type=str, required=True,
        help="path to output text file")
    args = vars(ap.parse_args())
    
    audio_path = args['audio']
    output_path = args['output']
    audio_to_text_output(audio_path, output_path)
