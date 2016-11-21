#!/usr/bin/env python3

from w1thermsensor import W1ThermSensor
import speech_recognition as sr
import requests
import subprocess
import json
from time import sleep
import RPi.GPIO as GPIO

GPIO.setmode(GPIO.BCM)
GPIO.setwarnings(False) #suppress warning for non-default pin selection?

button_pin = 18
LED_pin = 26
temp_sensor = W1ThermSensor()
SAMPLE_RATE = 10

GPIO.setup(button_pin, GPIO.IN, pull_up_down=GPIO.PUD_UP)
GPIO.setup(LED_pin, GPIO.OUT)
GPIO.setup(19, GPIO.OUT)

record_cmd = 'arecord -D "plughw:1,0" -f U8 -d3 '

# Hard-Coded identifiers
bathroom_id = 8
# base_url = "http://10.0.0.22:3000/"
base_url = "http://75684563.ngrok.io/"

login_url = base_url + "bathroom/{}/shower/create".format(bathroom_id)
datapoint_url = base_url + "shower/{}/data_point/create"
NO_USER_ERROR = "NO_USER_FOUND"

from os import path
AUDIO_FILE = path.join(path.dirname(path.realpath(__file__)), "file.flac")

def record(file_name):
    process = subprocess.call(record_cmd+file_name, shell=True)
    if process:
        raise Exception("OH NO DIDNT WORK")

def recognize(file_name):
    # use the audio file as the audio source
    while True:
        print "Please say something:"
        record(file_name)
        r = sr.Recognizer()
        with sr.AudioFile(file_name) as source:
            audio = r.record(source) # read the entire audio file
        print("processing")
        # recognize speech using Google Speech Recognition
        try:
            # for testing purposes, we're just using the default API key
            # to use another API key, use `r.recognize_google(audio, key="GOOGLE_SPEECH_RECOGNITION_API_KEY")`
            # instead of `r.recognize_google(audio)`
                print
                passcode = r.recognize_google(audio)
                print("WowShow thinks you said \n\t" + passcode)
                url = "{}?passcode={}".format(login_url, passcode)
                print(url)
                r = requests.post(url)
                if r.status_code == 200:
                    info = json.loads(r.text)
                    if "ERROR" in info and info["ERROR"] == NO_USER_ERROR:
                        print "\n***That passcode did not match. Please try again"
                        sleep(1)
                        continue
                    print("Response from shower create:\n\t", r.text)
                    shower_id = info['shower_id']
                    return shower_id
                else:
                    print "ERROR posting to wowShow"
        except sr.UnknownValueError:
            print("Google Speech Recognition could not understand audio")
        except sr.RequestError as e:
            print("Could not request results from Google Speech Recognition service; {0}".format(e))

def solenoid_open():
    GPIO.output(19, GPIO.HIGH) #set high, flow through

def solenoid_close():
    GPIO.output(19, GPIO.LOW) #set low, no flow

def shower_loop(shower_id):
    send_shower_data(shower_id, 50, 50)
    sleep(3)
    send_shower_data(shower_id, 70, 50)
    sleep(3)

    solenoid_open()
    while True:
        temp = temp_sensor.get_temperature()
        water_amnt = 50    # flow_meter.get_flow()
        response = send_shower_data(shower_id, temp, water_amnt)
        if response:
            if "end_shower" in info:
                if info["end_shower"]:
                    solenoid_close()
                    break
            if "block_water" in info:
                if info["block_water"]:
                    solenoid_close()
                else:
                    solenoid_open()
        else:
            break
        sleep(SAMPLE_RATE)

def send_shower_data(shower_id, temp, flow_rate):
    new_data_point_url = datapoint_url.format(shower_id)
    new_data_point_url += "?temp={}&flow={}".format(temp, flow_rate)
    r = requests.post(new_data_point_url)
    if r.status_code == 200:
        return json.loads(r.text)
    else:
        return False

def button_pressed():
    return not GPIO.input(button_pin)


try:
    while True:
        if button_pressed():
            shower_id = recognize(AUDIO_FILE)
            shower_loop(shower_id)
            # break

        sleep(0.5)
except (KeyboardInterrupt, SystemExit):
    print "Cleaning up"
    GPIO.cleanup()
