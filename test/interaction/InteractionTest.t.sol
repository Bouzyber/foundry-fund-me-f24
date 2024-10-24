// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

/*Para hacerlo mas facil nuestro contrato de prueba, importaremos un archivo
llamado "test-std/test.sol" de nuestra libreria ya que tiene unos comandos
especificos para testear*/
/*Console.log: es un metodo (que esta en nuestra libereria) imprime un argumento
para cada especificador (e.g. unint256/int256) por un valor correspondiente ha 
nuestro archivo de testeo o en smart contracts*/
import {Test, console} from "forge-std/Test.sol";

/*Para desplegar nuestra 'function setUp' debemos de importar el contrato de FundMe para poder desplegar */
import {FundMe} from /*utilizando '..' da a entender que estas importando algo de la misma carpeta
o proyecto */ "../../src/FundMe.sol";

/*Para que podamos hacer funcionar nuestro contrato deploy sin que tener que ir a actualizar
en nuestro contrato de testeo, deberemos de importar nuestro contrato deploy para que despliegue 
de la misma forma en nuestro contrato de testeo  */
import {DeployFundMe} from "../../script/DeployFundMe.s.sol";
import {FundFundMe, WithdrawFundMe} from "../../script/Interaction.s.sol";

contract InteractionTest is Test{
      FundMe fundMe; /*esto es una variable de estado, que se puede u   sar en otras funciones
    y modificarlas dentro de ellas.*/ 
    //makeAddr  es una funcion que se utiliza para crear una direccion
    address USER = makeAddr ("user");
    uint256 constant SEND_VALUE = 0.1 ether;
    uint256 constant STARTING_BALANCE = 10 ether;
    uint256 constant GAS_PRICE = 1;

    function setUp() external{
        DeployFundMe deploy = new DeployFundMe();
        fundMe = deploy.run();
        vm.deal(USER, STARTING_BALANCE);

    }

    function testUserCanFundInteractions() public {
        FundFundMe fundFundMe = new FundFundMe();
        fundFundMe.fundFundMe(address(fundMe));

        WithdrawFundMe withdrawFundMe = new WithdrawFundMe();
        withdrawFundMe.withdrawFundMe(address(fundMe));
        
        assert(address(fundMe).balance == 0);
    }
    
}