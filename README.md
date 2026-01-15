# Wheezedetect
*Aplicación multiplataforma para la detección de neumonía mediante IA*
## Descripción
WheezeDetect-SI-ULL es una aplicación desarrollada durante el Grado en Ingeniería Informática (ULL) cuyo objetivo es **detectar neumonía en radiografías de tórax** utilizando modelos de inteligencia artificial. El proyecto combina:
- Un **modelo de clasificación** basado en deep learning.
- Una **aplicación Flutter multiplataforma** (Android, iOS, Windows, Linux, macOS y Web).
- Un sistema de visualización de resultados e historial de predicciones.
## Funcionalidades principales
- Carga de radiografías de tórax.
- Clasificación automática (*Normal* vs *Neumonía*).
- Visualización de resultados.
- Historial de predicciones.
- Compatibilidad multiplataforma.
## Tecnologías utilizadas
- **Flutter** (Dart)
- **Python** (modelos de IA)
- **Deep Learning** (CNN / U-Net)
- **CMake / C++** (componentes nativos)
- **Multiplataforma**: Android, iOS, Web, Windows, Linux, macOS
## Estructura del repositorio
- `Modelo_Unet/` — Modelo de IA para segmentación o clasificación.  
- `lib/` — Código principal de la aplicación Flutter.  
- `assets/` — Recursos gráficos utilizados por la app.  
- `android/`, `ios/`, `web/`, `windows/`, `linux/`, `macos/` — Código específico por plataforma.  
- `README.md` — Documentación principal del repositorio.
## Demostración del funcionamiento
A continuación se muestra el flujo de uso de la aplicación y el proceso de detección:
### Ejemplo de radiografia con pneumonia
<img src="/assets/images/image_with_pneumonia.jpeg" width="350">

### Interfaz de la aplicación
> Detección automática de neumonía a partir de una radiografía.
<img src="/img/app_solo.png" width="300">

### Proceso de desarrollo
<img src="/img/app-foto.png" width="1500">

### Pantallas de la aplicación
Estas son las pantallas de la interfaz de usuario: 
- **Home**: muestra una breve explicación del funcionamiento de la aplicación y cómo cargar una radiografía.
- **Análisis**: permite seleccionar la imagen y ejecutar el proceso de detección (la pantalla de análisis detallado ya se mostró anteriormente).
- **Historial**: recoge las predicciones realizadas previamente para facilitar el seguimiento.
<p align="center"> 
  <img src="/img/home.png" width="198"> 
  <img src="/img/data_analysis.png" width="200"> 
  <img src="/img/history.png" width="200">
</p>

### Resultados de la detección
A continuación se muestran dos ejemplos de salida del sistema: 
- **Radiografía sin neumonía:** resultado *Normal*
- **Radiografía con neumonía:** resultado *Pneumonia detected*
<p align="center"> 
  <img src="/img/result_normal.png" width="198" alt="Resultado normal"> 
  <img src="/img/result_pneumonia.png" width="200" alt="Resultado con neumonía"> 
</p>

## Colaboradores
Proyecto desarrollado conjuntamente por:
- **Tania Évora Vargas Martínez** - Desarrollo, experimentación y análisis.  
- **José Fenic Peiteado Padilla** - Desarrollo, integración y documentación.

Trabajo realizado en la **Universidad de La Laguna (ULL)**.
## Nota
Este repositorio contiene la versión final del proyecto entregado para la asignatura correspondiente.



