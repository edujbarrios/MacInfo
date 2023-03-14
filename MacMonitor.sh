#!/bin/bash

echo "Información del usuario actual:"
whoami
id

# Muestra la RAM ocupada
echo "Estado de la memoria RAM:"
memory_free=$(vm_stat | awk '/Pages free/ {print $3}' | sed 's/\.//')
memory_inactive=$(vm_stat | awk '/Pages inactive/ {print $3}' | sed 's/\.//')
memory_wired=$(vm_stat | awk '/Pages wired down/ {print $4}' | sed 's/\.//')
memory_compressed=$(vm_stat | awk '/Pages occupied by compressor/ {print $5}' | sed 's/\.//')
memory_total=$((($memory_free+$memory_inactive+$memory_wired+$memory_compressed)*4096/1024/1024))
memory_used=$((($memory_total-$memory_free)*100/$memory_total))
echo "RAM disponible: $memory_free MB"
echo "RAM inactiva: $memory_inactive MB"
echo "RAM en uso: $memory_wired MB"
echo "RAM comprimida: $memory_compressed MB"
echo "RAM total: $memory_total MB"
echo "RAM en uso (%): $memory_used %"

# Muestra el almacenamiento utilizado
echo "Almacenamiento utilizado:"
df -h / | awk '{print $5}' | tail -n 1

# Muestra el espacio libre en el disco duro
echo "Espacio libre en el disco duro:"
df -h / | awk '{print $4}' | tail -n 1

# Muestra la versión del sistema operativo
echo "Sistema operativo:"
sw_vers -productName
sw_vers -productVersion

# Muestra el uso de la CPU
echo "Uso de la CPU:"
top -l 1 | awk '/CPU usage/ {print $8}' | cut -c 1-4

# Muestra el uso de la memoria por proceso
echo "Uso de la memoria por proceso:"
ps aux --sort=-%mem | awk '{if ($4!=0) printf("%d\t%s\t%s\n", $4, $11, $12);}'

# Muestra la dirección IP del dispositivo en la red
echo "Dirección IP del dispositivo:"
ipconfig getifaddr en0

# Muestra información de red adicional, como la dirección MAC y la puerta de enlace predeterminada
echo "Información de red:"
ifconfig en0 | awk '/ether/{print "Dirección MAC: " $2} /inet /{print "Dirección IP: " $2} /broadcast/{print "Dirección de Broadcast: " $6}'
netstat -nr | grep default | awk '{print "Puerta de enlace predeterminada: " $2}'

echo "Información del procesador:"
sysctl -n machdep.cpu.brand_string
sysctl -n machdep.cpu.core_count
sysctl -n machdep.cpu.thread_count

echo "Información de la batería:"
ioreg -rn AppleSmartBattery | grep -w "Capacity\|CycleCount" | awk '{print $3}' | tr '\n' ' '; echo

echo "Información de la tarjeta gráfica:"
system_profiler SPDisplaysDataType | grep "Chipset Model" | awk -F": " '{print $2}'
system_profiler SPDisplaysDataType | grep "VRAM (Dynamic, Max)" | awk -F": " '{print $2}'

echo "Información del disco:"
system_profiler SPSerialATADataType | grep "Media Name\|Capacity" | awk -F": " '{print $2}'

echo "Información del sistema de archivos:"
mount | grep " / " | awk '{print $5}'


