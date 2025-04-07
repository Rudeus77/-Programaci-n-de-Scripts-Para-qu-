#!/bin/bash

ARCHIVO="/workspaces/-Programaci-n-de-Scripts-Para-qu-/ventas_2024.csv"
REPORTE="/workspaces/-Programaci-n-de-Scripts-Para-qu-/reporte_semanal.txt"

# Limpiar reporte anterior y escribir encabezado
echo "📋 Resumen de Ventas - Generado el $(date)" > "/workspaces/-Programaci-n-de-Scripts-Para-qu-/reporte_semanal.txt"
echo "------------------------------------------" >> "/workspaces/-Programaci-n-de-Scripts-Para-qu-/reporte_semanal.txt"

# Ventas por mes
echo "📅 Total de ventas por mes:" >> "/workspaces/-Programaci-n-de-Scripts-Para-qu-/reporte_semanal.txt"
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
}' >> "/workspaces/-Programaci-n-de-Scripts-Para-qu-/reporte_semanal.txt"
echo "" >> "/workspaces/-Programaci-n-de-Scripts-Para-qu-/reporte_semanal.txt"

# Producto más vendido
echo "🎯 Producto más vendido:" >> "/workspaces/-Programaci-n-de-Scripts-Para-qu-/reporte_semanal.txt"
tail -n +2 "/workspaces/-Programaci-n-de-Scripts-Para-qu-/reporte_semanal.txt" | awk -F ";" '
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
}' >> "/workspaces/-Programaci-n-de-Scripts-Para-qu-/reporte_semanal.txt"
echo "" >> "/workspaces/-Programaci-n-de-Scripts-Para-qu-/reporte_semanal.txt"

# Monto total anual
echo "💰 Monto total anual:" >> "/workspaces/-Programaci-n-de-Scripts-Para-qu-/reporte_semanal.txt"
total=$(tail -n +2 "$ARCHIVO" | awk -F ";" '{suma += $6} END {printf "%.2f", suma}')
echo "Total: \$${total}" >> "/workspaces/-Programaci-n-de-Scripts-Para-qu-/reporte_semanal.txt"
echo "" >> "/workspaces/-Programaci-n-de-Scripts-Para-qu-/reporte_semanal.txt"

# Cliente más frecuente
echo "👤 Cliente más frecuente:" >> "/workspaces/-Programaci-n-de-Scripts-Para-qu-/reporte_semanal.txt"
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
}' >> "/workspaces/-Programaci-n-de-Scripts-Para-qu-/reporte_semanal.txt"
