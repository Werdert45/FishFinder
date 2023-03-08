import tensorflow as tf
# Load the MobileNet tf.keras model.
#model = tf.keras.applications.MobileNetV2(
#    weights="imagenet", input_shape=(224, 224, 3))

# Convert the model.
#converter = tf.lite.TFLiteConverter.from_keras_model(model)
#tflite_model = converter.convert()

model = tf.keras.models.load_model('my_model/1')

#concrete_func = model.signatures[
#  tf.saved_model.DEFAULT_SERVING_SIGNATURE_DEF_KEY]

#tf.saved_movel.saved(model, "/my_model")
#converter = tf.lite.TFLiteConverter.from_concrete_function(concrete_func)
converter = tf.lite.TFLiteConverter.from_keras_model(model)
tflite_model = converter.convert()

open("fishfinder.tflite","wb").write(tflite_model)
