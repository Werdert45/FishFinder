import json
import numpy as np
import requests
from PIL import Image
from cv2 import imread, resize
import tensorflow as tf

from tensorflow.keras.preprocessing.image import img_to_array as img_to_array
from tensorflow.keras.preprocessing.image import load_img as load_img


image_file = 'bermpje.jpg'


# Prepare the image for post
image = img_to_array(load_img(image_file, target_size=(224, 224, 3))) / 255.

image = image.reshape((-1,) + image.shape)
image = image.astype('float16')
data = json.dumps({
    "instances":image.tolist()
})
headers = {"content-type": "application/json"}


# Post the image
resp = requests.post('http://192.168.2.20:8501/v1/models/fish_finder:predict', data=data, headers=headers)


# Get predictions and format them
predictions = json.loads(resp.text)

#index_max = np.argmax(predictions[0])

species = ["alver_blankvoorn", "barbeel", "beekforel", "bittervoorn", "bot", "bronforel", "donaubrasem", "elrits", "fint", "grondels", "grote marene", "gup", "harder_band", "karpers", "kopblei", "kopvoorn", "meerval", "paling", "pos", "regenboogforel", "rietvoorn", "serpeling", "sneep", "snoeken", "spiering", "stekel_bermpje", "steur", "vetje", "wijting", "winde", "zalm", "zeeforel", "zeelt", "zonnebaars"]

#percentage = 100*(predictions[0][index_max])

sure = False
"""
if percentage > 70:
    prediction = species[index_max]
    print(prediction)
    sure = True

else:
    prediction = species[index_max]
    predictions[0].pop(index_max)
    prediction2 = species[np.argmax(predictions[0])]
    print("First prediction: ", prediction, " Second prediction: ", prediction2)
    sure = False

"""
#if sure:
#    submodels()

#Submodel function or class
"""
if prediction == "alver_blankvoorn":
    resp = requests.post('http://192.168.2.20:8501/v1/models/fish_finder:predict', data=data, headers=headers)
    predictions = json.loads(resp.text)['predictions']

elif prediction == "grondels":
    resp = requests.post('http://192.168.2.20:8501/v1/models/fish_finder:predict', data=data, headers=headers)
    predictions = json.loads(resp.text)['predictions']

elif prediction == "harder_band":
    resp = requests.post('http://192.168.2.20:8501/v1/models/fish_finder:predict', data=data, headers=headers)
    predictions = json.loads(resp.text)['predictions']

elif prediction == "karpers":
    resp = requests.post('http://192.168.2.20:8501/v1/models/fish_finder:predict', data=data, headers=headers)
    predictions = json.loads(resp.text)['predictions']

elif prediction == "meerval":
    resp = requests.post('http://192.168.2.20:8501/v1/models/fish_finder:predict', data=data, headers=headers)
    predictions = json.loads(resp.text)['predictions']

elif prediction == "snoeken":
    resp = requests.post('http://192.168.2.20:8501/v1/models/fish_finder:predict', data=data, headers=headers)
    predictions = json.loads(resp.text)['predictions']

elif prediction == "stekel_bermpje":
    resp = requests.post('http://192.168.2.20:8501/v1/models/fish_finder:predict', data=data, headers=headers)
    predictions = json.loads(resp.text)['predictions']

elif prediction == "steur":
    resp = requests.post('http://192.168.2.20:8501/v1/models/fish_finder:predict', data=data, headers=headers)
    predictions = json.loads(resp.text)['predictions']

else:
    predictions = prediction

"""




###################### Maybe Useful later or during later debugging ##############################

print('response.status_code: {}'.format(resp.status_code))
#print('response.content: {}'.format(resp.content))



