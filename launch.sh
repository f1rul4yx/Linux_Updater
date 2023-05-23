#!/bin/bash

# Author: Diego Vargas (f1rul4yx)

# Colors
negrita="\033[1m"
subrayado="\033[4m"
negro="\033[30m"
rojo="\033[31m"
verde="\033[32m"
amarillo="\033[33m"
azul="\033[34m"
magenta="\033[35m"
cian="\033[36m"
blanco="\033[37m"
reset="\033[0m"

# Functions
function root_verification() {
    clear
    if [ "$EUID" -ne 0 ]; then
        echo -e "\n${negrita}${rojo}Este script debe ser ejecutado como usuario root${reset}"
        exit 1
    fi
}
function username() {
    clear
    echo -e "\n${negrita}Escribe tu nombre de usuario perfectamente:${reset} \c"
    read username
}
function sudoers() {
    clear
    if ! grep "${username}" /etc/sudoers; then
        echo -e "${username}    ALL=(ALL:ALL) ALL" >> /etc/sudoers
    fi &>/dev/null
}
function question() {
    echo -e "\n${negrita}¿Qué sistema operativo estás usando?${reset}"
    echo -e "\n${verde}1. Debian${reset}"
    echo -e "${verde}2. Parrot${reset}"
    echo -e "\n${negrita}----->${reset} \c"
    read answer
    case ${answer} in
        1)
            commands_debian
            ;;
        2)
            commands_parrot
            ;;
        *)
            clear
            echo -e "\n${negrita}${rojo}Esta respuesta no es válida, por favor vuelva a intentarlo${reset}"
            question
            ;;
    esac
}
function commands_debian() {
    clear
    sudo apt-get update -y
    sudo apt-get upgrade -y
    sudo apt-get autopurge -y
    sudo apt-get autoclean -y
}
function commands_parrot() {
    clear
    sudo apt-get update -y
    sudo parrot-upgrade -y
    sudo apt-get autopurge -y
    sudo apt-get autoclean -y
}
function clear_command_history() {
    sudo echo "" > /home/${username}/.bash_history &>/dev/null
    sudo echo "" > /home/${username}/.zsh_history &>/dev/null
    sudo echo "" > ~/.bash_history &>/dev/null
    sudo echo "" > ~/.zsh_history &>/dev/null
}
function close() {
    echo -e "\n${negrita}${verde}Programa lanzado con exito${reset}"
    exit
}

# Program
root_verification
username
sudoers
question
clear_command_history
close
