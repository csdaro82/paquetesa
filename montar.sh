#!/bin/bash
if [ "$(id -u)" != "0" ]; then
        echo "Los sentimos, Tiene que ser root."
        exit 1
fi

echo "Ingresra la ip del servidor"
read NEW_IP
if
  ping -c3 $NEW_IP >/dev/null &>/dev/null;
 then
    show_menu(){
    normal=`echo "\033[m"`
    menu=`echo "\033[36m"` #Blue
    number=`echo "\033[33m"` #yellow
    bgred=`echo "\033[41m"`
    fgred=`echo "\033[31m"`
    echo "#####################################################################################################################"
    echo "##                     Montar carpeta compartida en máquinas Linux version 1.0                                     ##" 
    echo "##   Para ejecutar este script se debe tener en cuenta que el usuario, ip del servidor y la carpeta compartida     ##"
    echo "##                                  Se deben pedir a operaciones                                                   ##"
    echo "#####################################################################################################################"
    printf "\n${menu}*********************************************${normal}\n"
    printf "${menu}**${number} 1)${menu} Comprobar si existe otra carpeta compartida montada ${normal}\n"
    printf "${menu}**${number} 2)${menu} Montar una carpeta compartida existe ${normal}\n"
    #printf "${menu}**${number} 3)${menu} Restart Apache ${normal}\n"
    printf "${menu}**${number} 3)${menu} Montar una nueva carpeta compartida ${normal}\n"
    printf "${menu}*********************************************${normal}\n"
    #printf "Please enter a menu option and enter or ${fgred}x to exit. ${normal}"
    printf "Ingrear un número del menú o ${fgred}x para salir. ${normal}"
    read opt

}

option_picked(){
    msgcolor=`echo "\033[01;31m"` # bold red
    normal=`echo "\033[00;00m"` # normal white
    message=${@:-"${normal}Error: No message passed"}
    printf "${msgcolor}${message}${normal}\n"
}
clear
show_menu
while [ $opt != '' ]
    do
    if [ $opt = '' ]; then
      exit;
    else
      case $opt in
        1) clear;
            echo "Comprobar si existe otra carpeta compartida montada"
            echo "Ingrear el nombre del usuario de la carpeta compartida"
            read NEW_USER < /dev/tty
            p=$(grep -r "$NEW_USER" /etc/fstab | wc -l )
            if [ $p -gt 0 ]; then
                p=$(grep -r "$NEW_USER" /etc/fstab)
                echo $p     
                echo "El usuario $NEW_USER ya existe"
                echo "Desea cambiar la contraseña si/no"
                    read v
                        if [ "$v" = si ]; then
                                echo "Escribiste -si-"
                                echo "Contraseña Anterior"
                                read ca
                                echo "Contraseña nueva"
                                read cn
                                sed -i "s/$ca/$cn/g" /etc/fstab
                                echo "Contraseña Anterior: $ca"
                                echo "Contraseña nueva: $cn"
                            elif [ "$v" = no ]; then
                                echo "Escribiste -no-"
                            elif [ "$v" = " " ]; then
                                echo "No puede dejar en blanco"
                        else
                            echo "No se acepta lo que se escribio"
                        fi
                        ##############################
                echo "Desea cambiar el usuario Existente si/no"
                    read var
            if [ "$var" = si ]; then
                echo "Escribiste -si-"
                echo "Nombre usuario Nuevo"
                read usn
                echo "Cambio de usuario Nuevo: $usn"
                echo "Cambio de usuario Anterior: $NEW_USER"
                sed -i "s/$NEW_USER/$usn/g" /etc/fstab
                /bin/mount -a
                ####################################contraseña####
                echo "Desea cambiar la contraseña si/no"
                read v
                    if [ "$v" = si ]; then
                        echo "Escribiste -si-"
                        echo "Contraseña Anterior"
                        read ca
                        echo "Contraseña nueva"
                        read cn
                        sed -i "s/$ca/$cn/g" /etc/fstab
                        echo "Contraseña Anterior: $ca"
                        echo "Contraseña nueva: $cn"
                            elif [ "$v" = no ]; then
                                echo "Escribiste -no-"
                            elif [ "$v" = " " ]; then
                                echo "No puede dejar en blanco"
                        else
                            echo "No se acepta lo que se escribio"
                    fi
            ###############################Fin contraseña#####
                elif [ "$var" = no ]; then
                    echo "Escribiste -no-"
                elif [ "$var" = " " ]; then
                    echo "No puede dejar en blanco"
            else
                echo "Lo se acepta lo que se escribio"
            fi                                              
        else
            echo "El usuario no existe debe crear una nueva carpeta compartida"
        fi
        show_menu;
        ;;
        2) clear;
            echo "Montar una carpeta compartida existe"
            /bin/mount -a
            echo "Carpeta compartida montada con exito"
            show_menu;
        ;;
        3) clear;
            echo "Montar una nueva carpeta compartida"
            printf "Ingrear nombre del ${fgred}Usuario  para la carpeta Compartida. ${normal}"
            read NEW_USER < /dev/tty
            p=$(grep -r "$NEW_USER" /etc/fstab | wc -l )
                if [ $p -gt 0 ];
                  then
                    echo "El usuario ya existe pruebe la opcion 2"
                else
                    printf "Ingrear nombre Carpeta ${fgred}Compartida.  ${normal}"
                    read NEW_RUTA < /dev/tty
                    echo "Ingresar la contraseña del usuario de la carpeta compartida"
                    read NEW_CONTRA < /dev/tty
                    echo "Crear una carpeta local donde se va motar la carpeta compartida"
                    read NEW_CARPETA
                        for ureal in $( who | cut -f1 -d ' ' | sort | sed 's/^ *//g');
                            do
                                echo "$ureal"
                            done
                    c=/home/$ureal/Escritorio
                        for i in $c/$NEW_CARPETA; do
                            if [ -d $c/$NEW_CARPETA ]
                            then
                                echo “La capeta $c/$NEW_CARPETA ya existe, tiene que crear otra carpeta.
                                show_menu;
                                break
                            else
                                mkdir $c/$NEW_CARPETA
                                /bin/chown $ureal:$ureal $c/$NEW_CARPETA
                                    if [ -e $c/$NEW_CARPETA ]
                                    then
                                        echo “$c/$NEW_CARPETA se ha creaco con éxito”
                                    else
                                        echo “Ups! Algo ha fallado al crear $c/$NEW_CARPETA”
                                        show_menu;
                                        break
                                    fi
                            fi
                        done
            echo "Montando la carpeta compartida"
            #echo  "//$NEW_IP/$NEW_RUTA $c/$NEW_CARPETA  cifs vers=1.0,user=$NEW_USER,password=$NEW_CONTRA,iocharset=utf8,sec=ntlm 0 0" >> /etc/fstab
            echo  "//$NEW_IP/$NEW_RUTA $c/$NEW_CARPETA  cifs username=$NEW_USER,password=$NEW_CONTRA,noexec,user,rw,nounix,iocharset=utf8 0 0" >> /etc/fstab
            /bin/mount -a
            fi
          show_menu;
        ;;
        x)exit;
        ;;
        \n)exit;
        ;;
        *)clear;
            option_picked "Ponga una opción del Menú";
            show_menu;
        ;;
      esac
    fi
done
 else
        echo "No hay conexion revise la red"
fi

