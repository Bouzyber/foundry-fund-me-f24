// SPDX-License-Identifier: MIT

/*EL principal objetivo de este contrato va ser que se pueda despliegar nuestros contratos
en otras cadenas. Para ello haremos dos cosas:
1. Desplegaremos el contrato 'mocks' cuando estemos en una cadena locas (e.g. anvil)
2. Matener segumiento a las direcciones de nuestros contratos por diferentes cadenas */

pragma solidity ^0.8.18;

import {Script} from "forge-std/Script.sol";
import {MockV3Aggregator} from "../test/mocks/MockV3Aggregator.sol";

contract HelperConfig is Script {
    NetworkConfig public activeNetWorkConfig;

    /*Para hacer evitar los famosos "magic numbers" vamos a crear una estructura de datos
    que especifica el el valor numerico e.g.:*/
    uint8 /*uint8 es para numeros decimales*/ public constant DECIMALS = 8;
    int256 /*int256 es para numeros enteros*/ public constant INITIAL_PRICE =
        2000e8;

    /*En Solidity, la palabra clave 'struct' se utiliza para definir una estructura
    de datos personalizada. Permite agrupar diferentes tipos de datos bajo un mismo nombre,
    facilitando la organización y manipulación de datos complejos. */
    struct NetworkConfig {
        address priceFeed; //USD/ETH price feed address
    }

    constructor() {
        /*block.chainid: es la identificacion de la red que vas a utilizar*/
        if (block.chainid == 11155111) {
            activeNetWorkConfig = getSepoliaEthConfig();
        } else if (block.chainid == 1) {
            activeNetWorkConfig = getMainnetEthConfig();
        } else {
            activeNetWorkConfig = getOrCreateAnvilEthConfig();
        }
        /*Lo que quiere va hacer esta funcion es que cada vez que estemos en 
        la cadena de sepolia usa esta configuracion:'activeNetWorkConfig = getSepoliaEthConfig()' */
    }

    function getSepoliaEthConfig()
        public
        pure
        returns (NetworkConfig memory)
    /*pure significa que no puede modificarni leer las variable del contrato */
    /*returns define el tipo de retorno de una función, mientras que return se 
    utiliza para proporcionar el valor real que se devuelve cuando la función se ejecuta. */
    /*Memory: memory se utiliza para definir la ubicación de almacenamiento de variables
    temporales que se crean durante la ejecución de una función.*/ {
        NetworkConfig memory sepoliaconfig = NetworkConfig({
            priceFeed: 0x694AA1769357215DE4FAC081bf1f309aDC325306
        });
        return sepoliaconfig;
    }

    function getMainnetEthConfig() public pure returns (NetworkConfig memory) {
        NetworkConfig memory ethConfig = NetworkConfig({
            priceFeed: 0x5f4eC3Df9cbd43714FE2740f5E3616155c5b8419
        });
        return ethConfig;
    }

    function getOrCreateAnvilEthConfig() public returns (NetworkConfig memory) {
        //Vamos a crear un mock contract que es como un contrato falso

        if (activeNetWorkConfig.priceFeed != address(0)) {
            return activeNetWorkConfig;
            /*Esto lo que hace si nosotros llamamos getOrCreateAnvilEthConfig sin 
            la funcion anterior crearia un nuevo priceFeed, pero si ya hemos despliegado 
            uno, no querremos depliegar otro nuevo.*/
        }

        vm.startBroadcast();
        MockV3Aggregator mockPriceFeed = new MockV3Aggregator(
            DECIMALS,
            INITIAL_PRICE
        );
        vm.stopBroadcast();

        NetworkConfig memory anvilConfig = NetworkConfig({
            priceFeed: address(mockPriceFeed)
        });
        return anvilConfig;
    }
}
