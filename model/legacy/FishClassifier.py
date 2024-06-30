#!/usr/bin/env python
# coding: utf-8

from __future__ import absolute_import, division, print_function, unicode_literals

import tensorflow as tf
import tensorflow_hub as hub
from tensorflow.keras.models import Sequential
from tensorflow.keras.layers import Dense
from tensorflow.keras.preprocessing.image import ImageDataGenerator
import os
import numpy as np
import matplotlib.pyplot as plt
from PIL import ImageFile
ImageFile.LOAD_TRUNCATED_IMAGES = True

#tf.config.gpu.set_per_process_memory_fraction(0.4)
physical_devices = tf.config.experimental.list_physical_devices('GPU')
assert len(physical_devices) > 0, "Not Enough GPUs available"
tf.config.experimental.set_memory_growth(physical_devices[0], True)
#gpu_options.allow_growth=True

PATH = os.path.join("steuren/")

train_dir = os.path.join(PATH, 'train')
validation_dir = os.path.join(PATH, 'validation')

batch_size = 32
epochs = 5
IMG_HEIGHT = 224
IMG_WIDTH = 224

train_image_generator = ImageDataGenerator(rescale=1./255) # Generator for our training data
validation_image_generator = ImageDataGenerator(rescale=1./255) # Generator for our validation data

train_data_gen = train_image_generator.flow_from_directory(batch_size=batch_size,
                                                           directory=train_dir,
                                                           shuffle=True,
                                                           target_size=(IMG_HEIGHT, IMG_WIDTH),
                                                           class_mode='categorical')

val_data_gen = validation_image_generator.flow_from_directory(batch_size=batch_size,
                                                              directory=validation_dir,
                                                              target_size=(IMG_HEIGHT, IMG_WIDTH),
                                                              class_mode='categorical')

# Get all of the images from each of the species and give a total
speciesnrtrain = []
speciesnrval = []

basedir = "steuren/train/"
species = os.listdir(basedir)

traindir = "steuren/train/"
valdir = "steuren/validation/"

for i in range(len(species)):
    if species[i] != ".DS_Store":
        number = len(os.listdir(traindir + str(species[i])))
        speciesnrtrain.append(number)
    else:
        print("This is .DS_STORE")

for j in range(len(species)):
    if species[j] != ".DS_Store":
        number = len(os.listdir(valdir + str(species[j])))
        speciesnrval.append(number)
    else:
        print("This is .DS_STORE")

total_train = sum(speciesnrtrain)
total_val = sum(speciesnrval) 

#train_batches = train_data_gen.shuffle(speciesnrtrain).batch(batch_size).prefetch(1)
#val_batches = val_data_gen.batch(batch_size).prefetch(1)

sample_training_images, _ = next(train_data_gen)

    # Here is the problem: the feature extracter
URL = "http://tfhub.dev/google/tf2-preview/mobilenet_v2/feature_vector/4"
feature_extractor = hub.KerasLayer(URL,
                                   input_shape=(IMG_HEIGHT, IMG_WIDTH, 3))

feature_extractor.trainable = False

model = Sequential([
  feature_extractor,
  Dense(3, activation='softmax')
])

# Firstly create a batch for training and validation 
model.compile(
  optimizer='adam',
  loss='categorical_crossentropy',
  metrics=['accuracy'])

model.summary()

history = model.fit_generator(
    train_data_gen,
    steps_per_epoch=total_train // batch_size,
    epochs=epochs,
    validation_data=val_data_gen,
    validation_steps=total_val // batch_size
)

#model.save_weights('./checkpoints/my_checkpoint')

model.save('saved_model/steuren')
