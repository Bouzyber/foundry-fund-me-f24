1. La palabra clave 'test' en la funcion, hace compruebe si todo lo que hay dentro de ella es correcto.

2. Que podriamos hacer para poder trabajar con una direccion fuera del sistema?
    Explicaremos 4 formas diferentes de testeo:
    1. Unit:
        - Testear una parte especifica de nuestro codigo.
    2.  Integration:
            -Testear como nuestro codigo trabaja con otras partes de nuestro codigo.
    3. Forked:
            -Testear nuestro codigo en un simulador de ambiente real.
    4. Staging:
            -Testear nuestro codigo en un ambiente real  con una red real (e.g. Mainnet, Sepholia Testnet)

3. CheatCodes: 
  1. expectRevert() es un cheatcode que nos permite devolver, e.g.:
        vm.expectRevert();  todo lo que se escriba despues de esta linea sera revertido
        fundMe.fund(); si el valor es menos eso hara que falle, por lo tanto al pasar 
        por el testnet saldra que ha pasado correctamente. 

  2. prank(); establece 'msg.sender' a una direccion especifica en el proximo call. La función prank() es una función que se utiliza para simular que una transacción es enviada desde una dirección específica, permitiendo que se realicen pruebas en condiciones específicas. Esto es especialmente útil en entornos de pruebas, ya que permite verificar el comportamiento de los contratos al interactuar con diferentes direcciones.eso hara que sepeamos siempre exactamente a quien esta enviando que call.
   
  3. makeAddr: crea una direccion que podemos pasar en un nombre que nos dara devuelta una nueva direccion.
    
  4. deal: nos permite establecer un saldo hacia newBalance (a la fake direccion).
   
  5. modifier: es una función especial que se utiliza para modificar el comportamiento de otras funciones. Se pueden usar para añadir condiciones de verificación antes de la ejecución de la función a la que se aplican. Esto es útil para asegurarse de que ciertas condiciones se cumplan antes de permitir que se ejecute la lógica de la función.
  
  6. Hoax: es un cheatcode que se utiliza para simular una transacción en la que se especifica tanto la dirección del remitente como el valor de Ether que se enviará. En lugar de tener que utilizar vm.prank() y vm.deal() por separado, hoax combina ambas funciones en una sola línea, facilitando la configuración de pruebas.

4. Assert: es una función que se utiliza para verificar que una condición específica sea verdadera. Si la condición evaluada es falsa, assert detiene la ejecución del contrato y revierte todos los cambios realizados en la transacción. Esta función es útil para detectar errores críticos que indican que algo ha salido mal en la lógica del contrato.
     - AssertEq/Assert diferencias:
        1. assert se utiliza en el código del contrato para asegurar condiciones críticas, mientras que assertEq se utiliza en pruebas para verificar la igualdad de valores.
        2. ssert no proporciona mensajes de error específicos, solo revertirá la transacción si la condición es falsa. En cambio, assertEq suele proporcionar información más detallada sobre qué se estaba probando, lo que facilita la identificación de problemas en las pruebas.
        3. ssert es más general y se usa para condiciones invariantes, mientras que assertEq es más específico para comparaciones en pruebas unitarias.

5. tx.gasprice: es un cheatcode el cual su funcion hace que establezca el gas por el resto de la transaccion.
     -  gasleft(): esta funcion esta contruida dentro de la funcion de solidity, te dira cuanto gas a salido en la transaccion de call. Para ello debemos escribirlo al princio de la funcion y en su final, finalmente calculara todo lo que hay dentro de ella.
     -  Para concluir deberemos escribir un tipo uint256 para que pueda hacer resta del gas principo y gas final (e.g.: )

6. console.log: se utiliza con frameworks de pruebas como Foundry, se emplea para imprimir mensajes y valores en la consola durante la ejecución de pruebas. Esto es útil para depurar y entender el estado del contrato o de las variables en momentos específicos.


 