from pyngrok import ngrok
from keras.models import load_model # Cargar el modelo
from PIL import Image
import numpy as np
import cv2
from flask import Flask, request, jsonify, send_file
from datetime import datetime
from flask_cors import CORS
from PIL import Image
import io
import base64


# Reemplaza <tu_authtoken> con tu authtoken de ngrok
#ngrok.set_auth_token("TOKE")


model = load_model('model.keras')

#model = load_model('pneumonia_detection_unet.keras')

IMG_SIZE = 200
def predict_image(image_path, model, img_size=IMG_SIZE):
    img = Image.open(image_path).convert('L')
    img = img.resize((img_size, img_size))
    img_array = np.array(img).reshape(1, img_size, img_size, 1) / 255.0
    prediction = model.predict(img_array)
    return 'PNEUMONIA' if prediction[0][0] < 0.5 else 'NORMAL'

app = Flask(__name__)
CORS(app)  # Habilita CORS para todas las rutas


@app.route('/process-image', methods=['POST'])
def process_image():
    if 'image' not in request.files:
        return jsonify({'error': 'No image provided'}), 400
    data = request.files['image']
    result_final = predict_image(data,model)
    image = Image.open(data)

    # Aquí puedes agregar el procesamiento de la imagen
    # Por ejemplo, convertir la imagen a escala de grises
    processed_image = image.convert('L')
    processed_image = image.rotate(180)

    # Convertir la imagen procesada a bytes
    img_byte_arr = io.BytesIO()
    processed_image.save(img_byte_arr, format='PNG')
    img_byte_arr = img_byte_arr.getvalue()

    # Codificar la imagen procesada en base64
    encoded_img = base64.b64encode(img_byte_arr).decode('utf-8')

    response = {
        'result': result_final,  # O 'no' dependiendo de tu lógica
        'processed_image': encoded_img
    }
    return jsonify(response)

@app.route("/")
def hello():
    return "Servidor Para el detection de pneumonia!"

if __name__ == '__main__':
    # Abre un túnel para exponer el puerto 5000 (puedes cambiar el número de puerto si lo necesitas)
  #public_url = ngrok.connect(5000)
  #print(f" * ngrok tunnel \"{public_url}\" -> \"http://127.0.0.1:5000\"")
  app.run(port=5000)
