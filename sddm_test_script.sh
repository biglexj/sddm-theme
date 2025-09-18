#!/bin/bash

# Hypr Ely-Neon Theme - Script de Testing
# Biglex J - 2025

# Detecta el directorio del script y asume que el tema está en la misma carpeta.
# Esto hace que el script sea más portable.
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
THEME_DIR="$SCRIPT_DIR"
DISPLAY_NUM=2  # Cambiamos a :2 para evitar conflictos

# Colores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${BLUE}🌟 Hypr Ely-Neon Theme Testing Script${NC}"
echo -e "${BLUE}======================================${NC}"

# Verifica dependencias
echo -e "${YELLOW}📋 Verificando dependencias...${NC}"

if ! command -v Xephyr &> /dev/null; then
    echo -e "${RED}❌ Xephyr no está instalado${NC}"
    echo "Instala con: sudo pacman -S xorg-server-xephyr"
    exit 1
fi

if ! command -v sddm-greeter &> /dev/null; then
    echo -e "${RED}❌ sddm-greeter no está disponible${NC}"
    echo "Instala con: sudo pacman -S sddm"
    exit 1
fi

# Limpia displays previos
echo -e "${YELLOW}🧼 Limpiando displays previos...${NC}"
sudo rm -f /tmp/.X${DISPLAY_NUM}-lock /tmp/.X11-unix/X${DISPLAY_NUM} 2>/dev/null
killall Xephyr 2>/dev/null
sleep 1

# Busca un display libre
find_free_display() {
    for i in {2..10}; do
        if ! ls /tmp/.X${i}-lock &> /dev/null; then
            DISPLAY_NUM=$i
            break
        fi
    done
}

find_free_display

# Verifica que el tema existe
if [ ! -f "$THEME_DIR/Main.qml" ]; then
    echo -e "${RED}❌ No se encontró Main.qml en: $THEME_DIR${NC}"
    exit 1
fi

echo -e "${GREEN}✅ Tema encontrado: $THEME_DIR${NC}"

# Inicia Xephyr
echo -e "${YELLOW}🚀 Iniciando Xephyr en :${DISPLAY_NUM} (2880x1800)...${NC}"
Xephyr -br -ac -noreset -screen 2880x1800 :${DISPLAY_NUM} &
XEPHYR_PID=$!

# Espera que Xephyr inicie
sleep 3

# Verifica que Xephyr está corriendo
if ! kill -0 $XEPHYR_PID 2>/dev/null; then
    echo -e "${RED}❌ Xephyr falló al iniciar${NC}"
    exit 1
fi

echo -e "${GREEN}✅ Xephyr corriendo (PID: $XEPHYR_PID)${NC}"

# Configura el entorno
export DISPLAY=:${DISPLAY_NUM}

# Función de cleanup
cleanup() {
    echo -e "\n${YELLOW}🧹 Cerrando Xephyr...${NC}"
    kill $XEPHYR_PID 2>/dev/null
    sudo rm -f /tmp/.X${DISPLAY_NUM}-lock 2>/dev/null
    export DISPLAY=:0
    echo -e "${GREEN}✅ Cleanup completado${NC}"
    exit 0
}

# Trap para cleanup automático
trap cleanup INT TERM

# Lanza el tema
echo -e "${BLUE}🎨 Lanzando Hypr Ely-Neon Theme...${NC}"
echo -e "${YELLOW}💡 Presiona Ctrl+C para salir${NC}"

# Ejecuta sddm-greeter
sddm-greeter --test-mode --theme "$THEME_DIR"

# Cleanup al finalizar
cleanup