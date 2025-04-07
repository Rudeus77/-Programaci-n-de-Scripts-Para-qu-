#!/bin/bash

# Ruta completa del script de reporte
RUTA_SCRIPT="/workspaces/-Programaci-n-de-Scripts-Para-qu-/reportes_ventas.sh"

# Verifica si el archivo del script existe
if [ ! -f "$RUTA_SCRIPT" ]; then
    echo "❌ El script $RUTA_SCRIPT no existe. Asegúrate de que esté en la ruta correcta."
    exit 1
fi

# Dar permisos de ejecución automáticamente
chmod +x "$RUTA_SCRIPT"

# Crear cron job (ejecutar todos los domingos a las 2:00 AM)
CRON_JOB="0 2 * * 0 /bin/bash $RUTA_SCRIPT"

# Instalar el cron si no existe ya
(crontab -l 2>/dev/null | grep -v -F "$RUTA_SCRIPT" ; echo "$CRON_JOB") | crontab -

echo "✅ Cron instalado correctamente para ejecutarse todos los domingos a las 2:00 AM:"
echo "$CRON_JOB"
