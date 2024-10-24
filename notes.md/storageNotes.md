Storage es la area especifica de la blockchain donde los datos asociados al smart contract esta permanentemente guardados. Estos datos son las variables definidas en el cabezal del contrato y se llaman variables de estado o variables globales. 

Imaginate estar en un vesturario enorme, y cada taquilla solo tienes espacio de 32 bytes. Cada taquilla (storage space) esta numerada/etiquetada y su numero/etiqueta actua como clave, en la par clave-valor, por lo que utilizando este número/etiqueta podemos acceder a lo que está almacenado en la taquilla.

Piensa en las variables de estado como las etiquetas que das a estos armarios, que te permiten recuperar fácilmente la información que has almacenado. Pero recuerda, el espacio en esta estantería no es ilimitado, y cada vez que añades o quitas algo, tiene un coste computacional. En las lecciones anteriores aprendimos que este coste computacional lleva el nombre de `gas`.

Los aspectos importantes son los siguientes:

* Cada slot tiene 32 bytes y representa la version de los bytes del objeto 
* La numeración de los slots empieza por 0;
* Los datos se almacenan de forma contigua empezando por la primera variable colocada en el pirmer slot.
  - E.g. :   uint256 favoriteNumber;
                favoriteNumber = 25;
            bool someBool;
                someBool = true;
            uint256 [] myArray;
                myArray.push(222);

El uint256 25 es 0x00...019, es decir [0] 0x00...19 es su representacion y los uints acaban en 19.
En cambio el bool es `true` su representacion es la siguiente, [1] (segundo slot) 0x...01 ya que los bools acaban en 01.
* Los valores dinamicos como las matrices (Array) y los mappings, los elementos estan almacenados (stored) usando una funcion hash ([keccak256(2)] 0x00...0de). El uint256 [] myArray; ya crea en si un slot en el almacinamiento ([2] 0x00..01) pero no sera el array entero. 
En el caso del mapping crea un slot en blanco ya que asi da a entender a solidity que este espacio en blanco es para el mapping ([3]...). 
* Las matrices y mapeos de tamaño dinámico se tratan de forma diferente (hablaremos de ellos más adelante);
* El tamaño de cada variable, en bytes, viene dado por su tipo;
* Si es posible, las variables múltiples < 32 bytes se empaquetan juntas;
* Si no es posible, se iniciará un nuevo slot;
* Las variables inmutables y constantes están integradas en el código de bytes del contrato, por lo que no utilizan espacios de almacenamiento.