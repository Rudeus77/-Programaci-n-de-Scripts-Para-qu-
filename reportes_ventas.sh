#!/bin/bash

ARCHIVO="ventas_2024.csv"
REPORTE="/workspaces/-Programaci-n-de-Scripts-Para-qu-/reporte_semanal.txt"

ventas_por_mes() {
    echo "📅 Ventas por mes:" >> "$REPORTE"
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
}

producto_mas_vendido() {
    echo "🎯 Producto más vendido:" >> "$REPORTE"
    tail -n +2 "$ARCHIVO" | awk -F ";" '
    {
        productos[$3] += $5
    }
    END {
        max = 0
        for (p in productos) {
            if (productos[p] > max) {
                max = productos[p]
                producto = p
            }
        }
        print producto " con " max " unidades vendidas"
    }' >> "$REPORTE"
    echo "" >> "$REPORTE"
}

monto_anual() {
    echo "💰 Monto total anual:" >> "$REPORTE"
    total=$(tail -n +2 "$ARCHIVO" | awk -F ";" '{suma += $6} END {print suma}')
    echo "Total anual: $total" >> "$REPORTE"
    echo "" >> "$REPORTE"
}

cliente_frecuente() {
    echo "👤 Cliente más frecuente:" >> "$REPORTE"
    tail -n +2 "$ARCHIVO" | awk -F ";" '
    {
        clientes[$2]++
    }
    END {
        max = 0
        for (c in clientes) {
            if (clientes[c] > max) {
                max = clientes[c]
                cliente = c
            }
        }
        print cliente " con " max " compras"
    }' >> "$REPORTE"
    echo "" >> "$REPORTE"
}

# Limpiar reporte anterior
echo "📊 Reporte semanal generado el $(date)" > "$REPORTE"
echo "--------------------------------------" >> "$REPORTE"

ventas_por_mes
producto_mas_vendido
monto_anual
cliente_frecuente
