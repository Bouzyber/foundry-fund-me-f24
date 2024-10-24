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

contract FundMeTest is Test {
    /****** MUY IMPORTANTE, CADA VEZ QUE TESTEA UNA FUNCION VUELVE A LA CONFIGURACION DE ESTADO Y VA A LA
    SIGUIENTE ******/

    FundMe fundMe; /*esto es una variable de estado, que se puede usar en otras funciones
    y modificarlas dentro de ellas.*/ 
    //makeAddr  es una funcion que se utiliza para crear una direccion
    address USER = makeAddr ("user");
    uint256 constant SEND_VALUE = 0.1 ether;
    uint256 constant STARTING_BALANCE = 10 ether;
    uint256 constant GAS_PRICE = 1;

    /*setup es un keyword que este se ejecutara para comprobar si todo 
    esta correcto antes de ir a otra funcion. */
    function setUp() external {
        //fundMe = new FundMe(0x694AA1769357215DE4FAC081bf1f309aDC325306);
        /*Lo que da a entender aqui es que estas creando una variable llamada 'fundMe'
        del tipo de contrato 'FundMe' y le estas asignando un nuevo contrato llamado 'FundMe'
        de esta manera no hace falta copiar y pegar ese contrato */
        DeployFundMe deployFundMe = new DeployFundMe();
        fundMe = deployFundMe.run();
        vm.deal(USER, STARTING_BALANCE);
        
    }

    function testMinimumDolarIsFive() public {
        assertEq(fundMe.MINIMUM_USD(), 5e18);  
        /*assertEQ es una función utilizada para comprobar si dos valores son iguales.
    Es parte de las pruebas unitarias y se utiliza para validar que el resultado de una operación 
    coincide con un valor esperado.*/
        
    }

    function testOwnerIsMsgSender() public {
        assertEq(fundMe.getOwner(), msg.sender);     
        /*me sale un error y para querer averiguarlo voy a usar la funcion 'console.log'*/
    }

    /*Que podriamos hacer para poder trabajar con una direccion fuera del sistema?
    Explicaremos 4 formas diferentes de testeo:
    1. Unit:
        - Testear una parte especifica de nuestro codigo.
    2.  Integration:
            -Testear como nuestro codigo trabaja con otras partes de nuestro codigo.
    3. Forked:
            -Testear nuestro codigo en un simulador de ambiente real.
    4. Staging:
            -Testear nuestro codigo en un ambiente real  con una red real (e.g. Mainnet, Sepholia Testnet) */
    

    function testPriceFeedVersionIsAccurate() public {
        uint256 version = fundMe.getVersion();
        assertEq(version, 4);   
    }
    
    /*La creacion de de este tesnet que haga un revertido al remitente si
    la cantidad no supera el minimo. */
    function testFundFailWithOutEnoughEth() public{
     
        /*expectRevert() es un cheatcode que nos permite devolver, e.g.:*/
        vm.expectRevert(); // todo lo que se escriba despues de esta linea sera revertido
        fundMe.fund(); /*si el valor es menos eso hara que falle, por lo tanto al pasar 
        por el testnet saldra que ha pasado correctamente.*/ 
        }

    /*Esta funciona servira para testear si supera la cantidad minimo. */
    function testFundUpdatesFundDataStructure() public {
        vm.prank(USER); //Es decir que despues de esta linea la tx sera enviada a USER
        fundMe.fund{value: SEND_VALUE}();
        uint256 amountFunded = fundMe.getAddressToAmountFunded(USER);  
        assertEq(amountFunded, SEND_VALUE);
    }

    function testAddsFounderToArrayOfFounders() public{
        vm.prank(USER);
        fundMe.fund{value:SEND_VALUE}();
        address funder = fundMe.getFunder(0);
        assertEq(funder, USER);


    }

    function testFunderToArrayOfFunders() public {
        vm.prank(USER);
        fundMe.fund{value:SEND_VALUE}();
        address funder = fundMe.getFunder(0);
        assertEq(funder, USER);   
    }

    
    modifier funded() {
         vm.prank(USER);
        fundMe.fund{value:SEND_VALUE}();
        _;

        /*Esta funcion sirve para evitar que cada vez que queramos dar saldo 
        a cada uno de nuestros test tengamos que escribir tantos codigos, esto
        se activa todo lo que se escribra despues de esta funcion*/
    }

    function testOnlyOwnerCanWithdraw() public funded {
        vm.prank(USER);
        vm.expectRevert();
        fundMe.withdraw();
    }

    function testWithdrawWithASingleFunder() public funded {
    /*Cada vez que trabajamos con los testeos se tiene que mentalizar los
    patrones siguiente:*/
        // Arrange: configurar nuestro test.
        /*para que podamos probar que la retirada de dinero funciona (withdraw),
        debemos de comprobar cual es nuestro saldo antes de llamar a "withdraw",
        de manera que podamos comprobar cual es nuestro saldo al final.*/
        uint256 startingOwnerBalance = fundMe.getOwner().balance;
        uint256 startingFundMeBalance = address(fundMe).balance;

        // Act: ejecutar nuestro test.
        /*De manera para ver cuanto gas gastamos, debemos primero primero calcular 
        el gas que a salido en esta funcion call antes y despues. Para hace esto:*/
        //accessesuint256 gasStart = gasleft();
        //vm.txGasPrice(GAS_PRICE);       
        vm.prank(fundMe.getOwner());
        fundMe.withdraw();
        //uint256 gasEnd = gasleft();
        /*uint256 gasUsed = (gasStart - gasEnd) * tx.gasprice; //calcular el gas que hemos gastado
        console.log(gasUsed); //para poderlo ver en la terminal el gas que hemos gastado*/
       
        // Assert: verificar que el test paso correctamente.
        uint256 endingOwnerBalance = fundMe.getOwner().balance;
        uint256 endingFundMeBalance = address(fundMe).balance;
        assertEq(endingFundMeBalance, 0);//retiraremos todo el dinero de FundMe por eso el '0'
        assert(startingOwnerBalance + startingFundMeBalance == fundMe.getOwner().balance );
    }

     function testWithdrawFromMultipleFunders() public funded {
        // *Arrange*
        //si quieres usar numeros para generar direcciones, estos deben de ser con el tipo **uint160**. 
        uint160 numbersOfFunders = 10;
        uint160 startingFunderIndex = 0;
        for(uint160 i = startingFunderIndex; i < numbersOfFunders; i++) {
            /*Ahora ejecutaremos un codigo que esta situada en la libreria llamado hoax: En lugar 
            de tener que utilizar vm.prank() y vm.deal() por separado, hoax combina ambas funciones
            en una sola línea, facilitando la configuración de pruebas. */
            hoax(address(i), SEND_VALUE);/* esta linea quiere decir que vamos a crear direccion de (i) 
            en blanco, en el cual empieza por 1 que daremos una cantidad de valor.*/
            fundMe.fund{value: SEND_VALUE}();
        }
        
        // *Act*
        uint256 startingOwnerBalance = fundMe.getOwner().balance;
        uint256 startingFundMeBalance = address(fundMe).balance;
        vm.startPrank(fundMe.getOwner());
        fundMe.withdraw();
        vm.stopPrank();

        // *Assert*
        assert(address(fundMe).balance == 0);
        assert(fundMe.getOwner().balance == startingOwnerBalance + startingFundMeBalance);  

    }

    function testWithdrawFromMultipleFundersCheaper() public funded {
        // *Arrange*
        //si quieres usar numeros para generar direcciones, estos deben de ser con el tipo **uint160**. 
        uint160 numbersOfFunders = 10;
        uint160 startingFunderIndex = 0;
        for(uint160 i = startingFunderIndex; i < numbersOfFunders; i++) {
            /*Ahora ejecutaremos un codigo que esta situada en la libreria llamado hoax: En lugar 
            de tener que utilizar vm.prank() y vm.deal() por separado, hoax combina ambas funciones
            en una sola línea, facilitando la configuración de pruebas. */
            hoax(address(i), SEND_VALUE);/* esta linea quiere decir que vamos a crear direccion de (i) 
            en blanco, en el cual empieza por 1 que daremos una cantidad de valor.*/
            fundMe.fund{value: SEND_VALUE}();
        }
        
        // *Act*
        uint256 startingOwnerBalance = fundMe.getOwner().balance;
        uint256 startingFundMeBalance = address(fundMe).balance;
        vm.startPrank(fundMe.getOwner());
        fundMe.cheaperWithdraw();
        vm.stopPrank();

        // *Assert*
        assert(address(fundMe).balance == 0);
        assert(fundMe.getOwner().balance == startingOwnerBalance + startingFundMeBalance);  

    }



}