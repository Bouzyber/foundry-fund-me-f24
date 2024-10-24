1. `Pure`: significa que no puede modificar ni leer las variable del contrato
2. `Returns/return`: returns define el tipo de retorno de una función, mientras que return se utiliza para proporcionar el valor real que se devuelve cuando la función se ejecuta.
3. `Memory`: se utiliza para definir la ubicación de  almacenamiento de variables temporales que se crean durante 
la ejecución de una función.
1. Todos los storages variables deberian ir con una `s_` antes del nombre.
2. `Address`: es un tipo que se utiliza para almacenar direcciones de cuentas en la blockchain de Ethereum. Tiene varias funciones y propiedades asociadas:
    1. transfer(uint256 amount): 
        - Envía una cantidad específica de Ether a la dirección. 
        - Lanza un error si la transferencia falla. 
        - Ejemplo: 
            address payable destinatario = ...;
            destinatario.transfer(1 ether); .

    2. send(uint256 amount): 
        - También envía Ether, pero devuelve un booleano que indica si la transferencia fue exitosa o no. 
        - No lanza una excepción automáticamente, por lo que es necesario manejar el retorno. E.g.: 
            bool exito = destinatario.send(1 ether);
            require(exito, "La transferencia falló"); .

    3. call(): 
        - Permite realizar una llamada a una función de un contrato y puede enviar Ether al mismo tiempo
        - Es más flexible que "transfer y send", pero también más complejo, ya que requiere manejo de datos de retorno y puede ser susceptible a ataques.
        - Ejemplo:
            (bool exito, ) = destinatario.call{value: 1 ether}("");
            require(exito, "La llamada falló"); . 

    4. balance:
        - La propiedad 'balance' permite obtener el saldo de Ether de la dirección.
        - Ejemplo: 
            uint256 saldo = destinatario.balance;.
    
    5. isContract() (no es una función del tipo address, pero se usa comúnmente):
        - Se puede implementar una función para verificar si una dirección es un contrato. Esto se hace revisando el tamaño del código en la dirección: 
            function esContrato(address _direccion) internal view returns (bool) {
            uint32 size;
            assembly { size := extcodesize(_direccion) }
            return (size > 0);.
    6. `.lenght`: 
3. `Private`: declarar una función como 'private' significa que solo puede ser llamada desde dentro del mismo contrato en el que fue definida. Esto limita el acceso a la función y protege su lógica de ser invocada por otros contratos o cuentas externas.
4. `External`: Las funciones declaradas como external pueden ser llamadas desde fuera del contrato, pero no se pueden llamar internamente desde otras funciones del mismo contrato.
5. `Modifier`: son funciones que pueden cambiar el comportamiento de otras funciones, y se utilizan a menudo para aplicar condiciones previas o configuraciones.
6. For: se utiliza para crear un bucle (o ciclo). Los bucles permiten ejecutar un bloque de código repetidamente un número específico de veces o mientras se cumpla una condición determinada.
    - for (inicialización; condición; incremento) {
    // Código a ejecutar en cada iteración
    }.

7. `Constant`: se utiliza para declarar que una función o una variable no cambiará su valor después de ser inicializada.
    - gasleft(): esta funcion esta contruida dentro de la funcion de solidity, te dira cuanto gas a salido en la transaccion de call. Para ello debemos escribirlo al princio de la funcion y en su final, finalmente calculara todo lo que hay dentro de ella.

8. `loop`: es una estructura que permite ejecutar un bloque de código repetidamente mientras se cumpla una determinada condición. 
    - for loop: Permite iterar un número determinado de veces; 
    'for (uint256 i = 0; i < 10; i++) {
    // Hacer algo, por ejemplo, incrementar un contador
    }
    - while loop: Repite el bloque de código mientras una condición sea verdadera;
    uint256 i = 0;
    while (i < 10) {
    // Hacer algo
    i++;
    }
   - do-while loop: Similar al while, pero garantiza que el bloque de código se ejecute al menos una vez.
    uint256 i = 0;
    do {
    // Hacer algo
    i++;
    } while (i < 10);

9. `modifier`: es una función especial que se utiliza para modificar el comportamiento de otras funciones. Se pueden usar para añadir condiciones de verificación antes de la ejecución de la función a la que se aplican. Esto es útil para asegurarse de que ciertas condiciones se cumplan antes de permitir que se ejecute la lógica de la función.
10. `new`: se utiliza para crear una instancia de un contrato.
11. 

  
     
  
 
