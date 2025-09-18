# Guía de Instalación Detallada

## Instalación de Fuentes Requeridas

### 1. Fira Sans
La fuente Fira Sans generalmente está disponible en los repositorios de la mayoría de las distribuciones Linux:

- Arch Linux y derivados:
```bash
sudo pacman -S ttf-fira-sans
```

- Ubuntu/Debian:
```bash
sudo apt install fonts-firacode
```

### 2. Kefa
Kefa es una fuente que necesita ser instalada manualmente:

1. Descarga la fuente Kefa
2. Crea el directorio si no existe:
```bash
sudo mkdir -p /usr/share/fonts/TTF
```
3. Copia los archivos de fuente:
```bash
sudo cp Kefa-Regular.ttf /usr/share/fonts/TTF/
sudo cp Kefa-Bold.ttf /usr/share/fonts/TTF/
```

### 3. Ndot55
Ndot55 es una fuente especial para el reloj digital:

1. Descarga Ndot55 desde [su sitio web oficial]
2. Instala la fuente:
```bash
sudo cp Ndot55.ttf /usr/share/fonts/TTF/
```

### Actualizar Cache de Fuentes
Después de instalar todas las fuentes, actualiza el cache:
```bash
sudo fc-cache -f -v
```

## Verificación de Fuentes
Para verificar que las fuentes están instaladas correctamente:
```bash
fc-list | grep -i "fira"
fc-list | grep -i "kefa"
fc-list | grep -i "ndot"
```

## Ajuste de Resolución

Si tu pantalla no es 2880x1800, necesitarás ajustar los siguientes valores en `theme.conf`:

1. Modifica la resolución:
```ini
ScreenWidth="TU_ANCHO"
ScreenHeight="TU_ALTO"
```

2. Ajusta los tamaños de fuente según sea necesario:
```ini
FontSize="20"           # Ajusta según tu resolución
ClockFontSize="120"    # Ajusta según tu resolución
```

## Solución de Problemas

### Fuentes no Detectadas
Si SDDM no detecta las fuentes:
1. Verifica que las fuentes estén instaladas en el sistema
2. Asegúrate de que el usuario SDDM tenga acceso a las fuentes
3. Reinicia el servicio SDDM:
```bash
sudo systemctl restart sddm
```

### Problemas de Escala
Si los elementos se ven demasiado grandes o pequeños:
1. Ajusta `FontSize` en `theme.conf`
2. Modifica los tamaños en los archivos QML individuales
3. Ajusta `InterfaceShadowSize` según sea necesario

### Problemas de Rendimiento
Si el desenfoque causa problemas de rendimiento:
1. Reduce `BlurRadius` en `theme.conf`
2. O desactiva el desenfoque:
```ini
FullBlur="false"
PartialBlur="false"
```