# Proyecto de fin de curso de ASIR

El proyecto será un "Centro de administración avanzada de Virtual Box", todo hecho con archivos .bat donde se pondrán crear y gestionar máquinas virtuales para realizar operaciones de forma masiva o que solo se puedan hacer por comandos.  

En este Centro de administración de avanzada se podrá:  
1. Crear ovas independientes de varias máquinas.
2. Crear instantáneas de varias máquinas.
3. Modificar de la configuración de una o varias máquinas de forma masiva.
4. Crear de máquinas con instalación desatendida.
5. Registrar VM en caso de llevarlas en un disco externo.
6. Desregistrar las máquinas que se deseen.
7. Desregistrar máquinas en estado inaccesible.

-----

## Estructura

El único archivo del que consta el proyecto recibe el nombre de **CAAVB.bat** (de las siglas del nombre), en el cual todas las funcionalidades que se nombraron están implementadas en forma de funciones al inicio del archivo a continuación del ```@ECHO OFF```. Todas estas funciones son llamadas desde la función principal a medida que se van llamando con un ```CHOICE```.  

El programa inicia mostrando un título, unas instrucciones y las opciones de que funcionalidad queramos usar, y se ejecutará la que seleccionemos.  

### Exportar a OVA

En VirtualBox por interfaz gráfica se pueden exportar varias máquinas a la vez, pero estas estarán comprimidas en un único ova. Por lo que si hay problemas con una VM y debemos rescatarla, tendríamos que hacerlo rescatando todas las máquinas comprimidas en ese OVA. Esta funcionalidad, permite exportar las máquinas que se deseen a un OVA exclusivo para cada máquina, además los comprimidos que se generarán se moverán a una carpeta para tener estas copias de seguridad ordenadas.  

[Vídeo de creación de ovas independientes](https://www.youtube.com/watch?v=Tq9ULu8pqoU&list=PLiBaBAbzo-JFW_wGCsT9UPUl9I9ZMFgju&index=9)  

-----

### Creación de instantánea o snapshots

Esta funcionalidad, permite la captura de instantáneas o snapshots a las VM que se deseen, podemos escoger el nombre que queramos o si el nombre lo dejamos en blanco pondrá la fecha en la que se tomó la instantánea. Esta cualidad permite que se se pone en una archivo .bat a parte y con unas pequeñas modificaciones, podremos usarlo junto con el programador de tareas para que se use de forma automática cada el tiempo que se programe.  

[Vídeo de creación de instantáneas o snapshots de varias máquinas ](https://www.youtube.com/watch?v=H1vgEjWjz6c&list=PLiBaBAbzo-JFW_wGCsT9UPUl9I9ZMFgju&index=7)  

-----



[Vídeo de modificación de la configuración de VM](https://www.youtube.com/watch?v=F-uV9ZoRekg&list=PLiBaBAbzo-JFW_wGCsT9UPUl9I9ZMFgju&index=6)  

[Vídeo de creación de máquinas con instalación desatendida ](https://www.youtube.com/watch?v=FWbabs2YDjQ&list=PLiBaBAbzo-JFW_wGCsT9UPUl9I9ZMFgju&index=8) 

[Vídeo del registrado de VM](https://www.youtube.com/watch?v=UFgeti-_gP4&list=PLiBaBAbzo-JFW_wGCsT9UPUl9I9ZMFgju&index=3)  

[Vídeo del desregistrado de máquinas virtuales ](https://www.youtube.com/watch?v=b0B9TUtgIDw&list=PLiBaBAbzo-JFW_wGCsT9UPUl9I9ZMFgju&index=4)  

[Vídeo del desregistrado de máquinas en estado inaccesible](https://www.youtube.com/watch?v=Pp2zRKARiLs&list=PLiBaBAbzo-JFW_wGCsT9UPUl9I9ZMFgju&index=10)  



