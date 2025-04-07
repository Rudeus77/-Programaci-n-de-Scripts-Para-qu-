#!/bin/bash

ARCHIVO="/workspaces/-Programaci-n-de-Scripts-Para-qu-/ventas_2024.csv"
REPORTE="/workspaces/-Programaci-n-de-Scripts-Para-qu-/reporte_semanal.txt"

# Limpiar reporte anterior y escribir encabezado
echo "📋 Resumen de Ventas - Generado el $(date)" > "$REPORTE"
echo "------------------------------------------" >> "$REPORTE"

# Ventas por mes
echo "📅 Total de ventas por mes:" >> "$REPORTE"
tail -n +2 "$ARCHIVO" | awk -F ";" '
{
    split($1, fecha, "-")
    mes = fecha[1] "-" fecha[2]
    ventas[mes] += $6
}
END {
    for (m in ventas) {
        printf "%s: $%.2f\n", m, ventas[m]
    }
}' >> "$REPORTE"
echo "" >> "$REPORTE"

# Producto más vendido
echo "🎯 Producto más vendido:" >> "$REPORTE"
tail -n +2 "$ARCHIVO" | awk -F ";" '
{
    productos[$3] += $5
}
END {
    for (p in productos) {
        if (productos[p] > max) {
            max = productos[p]
            producto = p
        }
    }
    printf "%s con %d unidades vendidas\n", producto, max
}' >> "$REPORTE"
echo "" >> "$REPORTE"

# Monto total anual
echo "💰 Monto total anual:" >> "$REPORTE"
total=$(tail -n +2 "$ARCHIVO" | awk -F ";" '{suma += $6} END {printf "%.2f", suma}')
echo "Total: \$${total}" >> "$REPORTE"
echo "" >> "$REPORTE"

# Cliente más frecuente
echo "👤 Cliente más frecuente:" >> "$REPORTE"
tail -n +2 "$ARCHIVO" | awk -F ";" '
{
    clientes[$2]++
}
END {
    for (c in clientes) {
        if (clientes[c] > max) {
            max = clientes[c]
            cliente = c
        }
    }
    print cliente " con " max " compras"
}' >> "$REPORTE"
