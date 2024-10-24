// SPDX-License-Identifier: MIT

pragma solidity 0.8.19;

import {Test, console} from "forge-std/Test.sol";
import {ZkSyncChainChecker} from "lib/foundry-devops/src/ZkSyncChainChecker.sol";
/*Este archivo `ZkSyncChainChecker` lleva unas funciones y modficadores diferentes como por ejemplo:
    - skipZkSync: Omite la función si está en una cadena basada en zkSync.
    - onlyZkSync: solo ejecuta la función si está en una cadena basada en zkSync.
    - isZkSyncChain: devuelve verdadero si está en una cadena basada en zkSync.
    - isOnZkSyncPreCompiles(): devuelve verdadero si está en una cadena basada en zkSync usando
      precompilados.
    - isOnZkSyncChainId(): devuelve verdadero si esta en un cadena basada en zkSync usando el chainId.
En definitiva tu puedes usar estos "skips y modificadores" para omitir un test o ejecutar un test
si pasas el flag (--zksync). */

import {FoundryZkSyncChecker} from "lib/foundry-devops/src/FoundryZkSyncChecker.sol";

contract ZkSyncDevOps is Test, ZkSyncChainChecker, FoundryZkSyncChecker {
    // Remove the `skipZkSync`, then run `forge test --mt testZkSyncChainFails --zksync` and this will fail!
    function testZkSyncChainFails()
        public
        skipZkSync //con esta palabra clave lo que haces es omitir el test
    {
        address ripemd = address(uint160(3));

        bool success;
        // Don't worry about what this "assembly" thing is for now
        assembly {
            success := call(gas(), ripemd, 0, 0, 0, 0, 0)
        }
        assert(success);
    }

    // You'll need `ffi=true` in your foundry.toml to run this test
    // // Remove the `onlyVanillaFoundry`, then run `foundryup-zksync` and then
    // // `forge test --mt testZkSyncFoundryFails --zksync`
    // // and this will fail!
    function testZkSyncFoundryFails() public onlyVanillaFoundry {
        bool exists = vm.keyExistsJson('{"hi": "true"}', ".hi");
        assert(exists);
    }
}
