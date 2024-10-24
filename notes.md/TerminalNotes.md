1. forge -v...(o mas depende de cuantos log tengas) en la terminal: especifica la visibilidad del logging (almacen/registro)
2. Cuando hay mas de una funcion de testeo y solo quieres ver solo una funcion especifica hay que poner: forge test -mt"nombre de la funcion de testeo" -v...." .
3.  Que podriamos hacer para poder trabajar con una direccion fuera del sistema?
    Explicaremos 4 formas diferentes de testeo:
    1. Unit:
        - Testear una parte especifica de nuestro codigo.
    2.  Integration:
            -Testear como nuestro codigo trabaja con otras partes de nuestro codigo.
    3. Forked:
            -Testear nuestro codigo en un simulador de ambiente real.
    4. Staging:
            -Testear nuestro codigo en un ambiente real  con una red real (e.g. Mainnet, Sepholia Testnet)
4. Si queremos testear con una direccion de anvil conectada con otra fuera del sistema lo que deberia de hacer es: forge test --mt "nom bre de la funcion de testeo" -vvv --fork-url "el https//: de la red". Esto hara que simule que estamos trabajando con la red Sepholia  
5. Lo malo de usar 'forkeds' que es que vas a usar muchos API calls en el nodo de alchemy y eso repercute ya que tiene un limite establecido gratuito, por esa misma razon es importante hacer los maximos testeos aqui sin forking, esa opcion se llama 'coverage' que basicamente saber cuantas lineas o porcentaeje de codigo hemos testeado, para saber eso hay que poner los keywords siguiente: 
   - forge coverage --fork-url "su https".
   - Lo idea siempre es subirlo al maximo porcentaje posible.

6. chisel: es otra forma de debug pero en la terminal por si algun dia pasa algo, su funcion es comprobar si es correcta lo que escribres e identifica el problema 
7. forge snapshot --mt: este tool en la terminal sirve para averigurar el gas que cotiene cada parte de tu contrato y te crea un archivo de para porder ver los gases de cada parte sin tener que hacer operaciones.
8. Estan son las formas que puedes comprobar el fundme contract storage:
     - `forge inspect FundMe (nombre del contrato) storageLayout`
     - `cast storage "contract address" "number slot"` 
     - 