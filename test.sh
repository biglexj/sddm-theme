#!/bin/bash

# Directorio del tema (ajústalo si lo cambias)
THEME_DIR="$HOME/Themes/biglexj/sddm/themes/biglexj"

# Verifica si Xephyr está instalado
if ! command -v Xephyr &> /dev/null; then
    echo "❌ Xephyr no está instalado. Instálalo primero."
    exit 1
fi

# Mata cualquier instancia previa de Xephyr
echo "🧼 Cerrando instancias previas de Xephyr..."
killall Xephyr 2>/dev/null

# Inicia Xephyr en segundo plano
echo "🚀 Iniciando Xephyr en :1 (1280x720)..."
Xephyr -br -screen 1280x720 :1 &
XEPHYR_PID=$!

# Espera que Xephyr levante bien
sleep 2

# Exporta DISPLAY al nuevo entorno virtual
export DISPLAY=:1

# Lanza el sddm-greeter en modo prueba
echo "🎨 Lanzando sddm-greeter con tu tema personalizado..."
sddm-greeter --test-mode --theme "$THEME_DIR"

# Una vez que cierra el greeter, mata Xephyr
echo "🧹 Cerrando Xephyr (PID $XEPHYR_PID)..."
kill $XEPHYR_PID 2>/dev/null

# Restaura DISPLAY (opcional, si el script se ejecuta desde terminal gráfica)
export DISPLAY=:0
echo "✅ Sesión restaurada a DISPLAY=:0"

