"""Exporta un icono geométrico propio a los tamaños de iOS y Android."""
import json
from pathlib import Path
from PIL import Image, ImageDraw

RAIZ = Path(__file__).resolve().parents[1]
imagen = Image.new('RGB', (1024, 1024), '#153b32')
dibujo = ImageDraw.Draw(imagen)
dibujo.rounded_rectangle((210, 280, 814, 744), radius=90, outline='#eff8ee', width=36)
dibujo.rounded_rectangle((586, 430, 836, 606), radius=48, fill='#80d8b6')
dibujo.ellipse((634, 492, 682, 540), fill='#153b32')
dibujo.line((306, 380, 490, 380), fill='#80d8b6', width=32)
destino = RAIZ / 'assets' / 'identidad'
destino.mkdir(parents=True, exist_ok=True)
imagen.save(destino / 'saldo_icono.png')

ios = RAIZ / 'ios/Runner/Assets.xcassets/AppIcon.appiconset'
for item in json.loads((ios / 'Contents.json').read_text())['images']:
    lado = round(float(item['size'].split('x')[0]) * float(item['scale'][:-1]))
    imagen.resize((lado, lado), Image.Resampling.LANCZOS).save(ios / item['filename'])

for densidad, lado in [('mdpi', 48), ('hdpi', 72), ('xhdpi', 96), ('xxhdpi', 144), ('xxxhdpi', 192)]:
    carpeta = RAIZ / f'android/app/src/main/res/mipmap-{densidad}'
    carpeta.mkdir(parents=True, exist_ok=True)
    imagen.resize((lado, lado), Image.Resampling.LANCZOS).save(carpeta / 'ic_launcher.png')
print('Icono Saldo exportado para iOS y Android.')
