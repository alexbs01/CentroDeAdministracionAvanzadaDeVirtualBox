# Proyecto de fin de curso de ASIR

## Índice

1. [Resumen del proyecto](#Resumen-del-proyecto).
2. [Recomendaciones de uso.](#Recomendaciones-de-uso)
3. [Estructura.](#Estructura)

-----

## Resumen del proyecto

El proyecto será un "Centro de administración avanzada de Virtual Box", todo hecho con archivos .bat donde se pondrán realizar tareas y gestionar máquinas virtuales para realizar operaciones de forma masiva o que solo se puedan hacer por comandos.  

En este Centro de administración de avanzada se podrá:  
1. [Crear ovas independientes de VM](#Exportar-a-OVA)
2. [Crear instantáneas de varias máquinas.](#Creación-de-instantánea-o-snapshots)
3. [Modificar la configuración de una o varias máquinas de forma masiva.](#Modificación-de-configuración)
4. [Crear máquinas con instalación desatendida.](#Instalación-desatendida)
5. [Registrar VM en caso de llevarlas en un disco externo.](#Registrado-de-máquinas)
6. [Desregistrar las máquinas que se deseen.](#Desregistrado-de-VM)
7. [Desregistrar máquinas en estado inaccesible.](#Desregistrado-de-máquinas-en-estado-inaccesible)

-----

## Recomendaciones de uso

Para usar el CAAVB hay que cumplir una serie de requisitos:

- Situar el archivo del programa en la ruta de las carpetas de las máquinas virtuales.
- En toda la ruta de las VM **NO** puede haber ni espacios ni caracteres extraños.

## Estructura

El único archivo del que consta el proyecto recibe el nombre de **CAAVB.bat** (de las siglas del nombre), en el cual todas las funcionalidades que se nombraron están implementadas en forma de funciones al inicio del archivo, a continuación del ```@ECHO OFF```. Todas estas funciones son llamadas desde la función principal a medida que se van seleccionando en el ```CHOICE```.  

El programa inicia mostrando un título, unas instrucciones y las opciones de que funcionalidad queramos usar, y se ejecutará la que seleccionemos.  

### Exportar a OVA

En VirtualBox por interfaz gráfica se pueden exportar varias máquinas a la vez, pero estas estarán comprimidas en un único ova. Por lo que si hay problemas con una VM y debemos rescatarla, tendríamos que hacerlo rescatando todas las máquinas comprimidas en ese OVA. Esta funcionalidad, permite exportar las máquinas que se deseen a un OVA exclusivo para cada máquina, además los comprimidos que se generarán se moverán a una carpeta para tener estas copias de seguridad ordenadas por fecha.  

[Vídeo de creación de ovas independientes](https://www.youtube.com/watch?v=Tq9ULu8pqoU&list=PLiBaBAbzo-JFW_wGCsT9UPUl9I9ZMFgju&index=9)  

-----

### Creación de instantánea o snapshots

Esta funcionalidad, permite la captura de instantáneas o snapshots a las VM que se deseen, podemos escoger el nombre que queramos o si el nombre lo dejamos en blanco pondrá la fecha en la que se tomó la instantánea. Esta cualidad permite que si se pone en un archivo .bat a parte y con unas pequeñas modificaciones, podremos usarlo junto con el Programador de tareas para que se use de forma automática cada el tiempo que se programe.  

[Vídeo de creación de instantáneas o snapshots de varias máquinas ](https://www.youtube.com/watch?v=H1vgEjWjz6c&list=PLiBaBAbzo-JFW_wGCsT9UPUl9I9ZMFgju&index=7)  

-----

### Modificación de configuración
Tienen cada una su configuración, pero por diversos motivos debemos modificar las características de cada máquina, para que vaya más rápido o nuestro ordenador no se ahogue si pusimos demasiados recursos a disposición de las VM. Por este motivo, esta característica del CAAVB permite modificar la RAM, el número de núcleos virtuales, cambiar la memoria gráfica por encima de lo permitido, y aumentar la capacidad de los discos virtuales para que no nos quedemos sin capacidad.  

[Vídeo de modificación de la configuración de VM](https://www.youtube.com/watch?v=F-uV9ZoRekg&list=PLiBaBAbzo-JFW_wGCsT9UPUl9I9ZMFgju&index=6)  

-----
### Instalación desatendida
Con esta funcionalidad podremos instalar de forma desatendida el SO de una máquina que aun no se inicio, útil para ahorrar tiempo. Esto generará un archivo con formato de xml con toda la configuración que le asignemos.  

[Vídeo de creación de máquinas con instalación desatendida](https://www.youtube.com/watch?v=FWbabs2YDjQ&list=PLiBaBAbzo-JFW_wGCsT9UPUl9I9ZMFgju&index=8) 

-----
### Registrado de máquinas
Si llevamos máquinas virtuales en un disco externo es muy probable que en el equipo haya que registrarlas en VirtualBox para poder usarlas. Para esta tarea, el programa busca las máquinas .vbox que hay a partir del mismo y agrega las que seleccionemos, respetando los grupos y las configuraciones de cada máquina.  

[Vídeo del registrado de VM](https://www.youtube.com/watch?v=UFgeti-_gP4&list=PLiBaBAbzo-JFW_wGCsT9UPUl9I9ZMFgju&index=3)  

-----
### Desregistrado de VM
Como funcionalidad a mayores y para facilitar su uso junto a otras características, decidí añadir la de desregistrar de VirtualBox las máquinas que se seleccionen.  

[Vídeo del desregistrado de máquinas virtuales](https://www.youtube.com/watch?v=b0B9TUtgIDw&list=PLiBaBAbzo-JFW_wGCsT9UPUl9I9ZMFgju&index=4)  

-----
### Desregistrado de máquinas en estado inaccesible
Esta funcionalidad, muy similar a la anterior, permite desregistrar la máquinas en estado inaccesibe cuando el programa no las detecta. Esto pasa cuando abrimos VirtualBox, y no se detectan las máquinas de un disco externo.  

[Vídeo del desregistrado de máquinas en estado inaccesible](https://www.youtube.com/watch?v=Pp2zRKARiLs&list=PLiBaBAbzo-JFW_wGCsT9UPUl9I9ZMFgju&index=10)  



