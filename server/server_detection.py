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
from matplotlib import cm

# Reemplaza <tu_authtoken> con tu authtoken de ngrok
#ngrok.set_auth_token("TOKEN")


#model = load_model('model.keras')

model = load_model('pneumonia_detection_unet.keras')

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
    image = Image.open(data).convert('L')
    img_size = 200
    original_size = image.size
    image = image.resize((img_size, img_size))
    image = np.array(image).reshape(1, img_size, img_size, 1) / 255.0

    # Hacer la predicción
    prediction = model.predict(image)[0].squeeze()
    print(f"Prediction shape: {prediction.shape}, min: {prediction.min()}, max: {prediction.max()}")

    # Redimensionar la máscara al tamaño original de la imagen
    mask = Image.fromarray((prediction * 255).astype(np.uint8)).resize(original_size, Image.NEAREST)
    mask = np.array(mask) / 255.0  # Normalizar la máscara

    heatmap = cm.jet(mask)[:, :, :3]  # Obtener los colores RGB del mapa de calor
    heatmap = (heatmap * 255).astype(np.uint8)  # Convertir a valores enteros

    # Crear la imagen superpuesta
    original_image = np.array(Image.open(data).convert('RGB')) / 255.0
    combined_image = original_image * 0.7 + heatmap / 255.0 * 0.3


    # Determinar la etiqueta de clase
    result_final = 'PNEUMONIA' if np.mean(mask) > 0.5 else 'NORMAL'

        # Convertir la imagen combinada a bytes
    img_byte_arr = io.BytesIO()
    combined_image_pil = Image.fromarray((combined_image * 255).astype(np.uint8))
    combined_image_pil.save(img_byte_arr, format='PNG')
    img_byte_arr = img_byte_arr.getvalue()

    # Codificar la imagen combinada en base64
    encoded_img = base64.b64encode(img_byte_arr).decode('utf-8')

    response = {
        'result': result_final,
        'processed_image': encoded_img
    }
    return jsonify(response)


@app.route("/")
def hello():
    return "server for the detection of pneumonia."

if __name__ == '__main__':
  public_url = "https://handy-huge-glider.ngrok-free.app"
  print(f" * ngrok tunnel \"{public_url}\" -> \"http://127.0.0.1:5000\"")
  app.run(port=5000)
