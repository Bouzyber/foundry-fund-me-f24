// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

// Hemos hecho un ajuste en el default llamado 'remappings' simplemente es redireccionar una direccion
import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";
import {PriceConverter} from "./PriceConverter.sol";

error FundMe_NotOwner();

contract FundMe {
    using PriceConverter for uint256;

    mapping(address => uint256) /*lo ideal es usar este tipo de variables en private por el conusmo de gas.*/
        private s_addressToAmountFunded;
    address[] private s_funders;

    // Could we make this constant?  /* hint: no! We should make it immutable! */
    address private immutable i_owner;
    uint256 public constant MINIMUM_USD = 5 * 10 ** 18;
    AggregatorV3Interface private s_priceFeed;

    /*Para poder hacer nuestro contratos mas modular sin tener que rehacer nada deberemos de ponerle
    una direccion a nuestro 'constructor'. Pasaremos nuestro contructor una direecion 'price feed' como parametro
    'constructor'*/
    constructor(address priceFeed) {
        i_owner = msg.sender;
        s_priceFeed = AggregatorV3Interface(priceFeed);
    } /* 1. Ahora cuando despleguemos este contrato vamos a coger como 'input parametre'(address priceFeed)
    ya que este priceFeed dependera en que cadena trabajara  */

    function fund() public payable {
        require(
            msg.value.getConversionRate(s_priceFeed) >= MINIMUM_USD,
            "You need to spend more ETH!"
        );
        // require(PriceConverter.getConversionRate(msg.value) >= MINIMUM_USD, "You need to spend more ETH!");
        s_addressToAmountFunded[msg.sender] += msg.value;
        s_funders.push(msg.sender);
    }

    function getVersion() public view returns (uint256) {
        return s_priceFeed.version();
    }

    modifier onlyOwner() {
        // require(msg.sender == owner);
        if (msg.sender != i_owner) revert FundMe_NotOwner();
        _;
    }

    // Functions Order:
    //// constructor
    //// receive
    //// fallback
    //// external
    //// public
    //// internal
    //// private
    //// view / pure

    function cheaperWithdraw() public onlyOwner {
        uint256 fundersLength = s_funders.length; // gas optimization
        /*De esta manera haremos que solo lea desde el storage una vez y 
        cada momento que vayamos atraves de loop (for) lo leeremos solamente
        una vez mas */
        for (
            uint256 funderIndex = 0;
            funderIndex < fundersLength;
            funderIndex++
        ) {
            address funder = s_funders[funderIndex];
            s_addressToAmountFunded[funder] = 0;
            /* 1*resumen: aqui leeremos el "s_funders.length" en memory de "uint256 fundersLength
        ya que es una variable temporal, opuestamente en la funcion de 'withdraw' que leeria
        el length desde el storage (almacemaniento) otra y otra vez */
        }
        s_funders = new address[](0);
        (bool callSuccess, ) = payable(msg.sender).call{
            value: address(this).balance
        }("");
        require(callSuccess, "Call failed");
    }

    function withdraw() public onlyOwner {
        for (
            uint256 funderIndex = 0;
            funderIndex < s_funders.length;
            funderIndex++
        ) {
            address funder = s_funders[funderIndex];
            s_addressToAmountFunded[funder] = 0;
        }
        s_funders = new address[](0);
        // // transfer
        // payable(msg.sender).transfer(address(this).balance);

        // // send
        // bool sendSuccess = payable(msg.sender).send(address(this).balance);
        // require(sendSuccess, "Send failed");

        // call
        (bool callSuccess, ) = payable(msg.sender).call{
            value: address(this).balance
        }("");
        require(callSuccess, "Call failed");
    }

    // Explainer from: https://solidity-by-example.org/fallback/
    // Ether is sent to contract
    //      is msg.data empty?
    //          /   \
    //         yes  no
    //         /     \
    //    receive()?  fallback()
    //     /   \
    //   yes   no
    //  /        \
    //receive()  fallback()

    fallback() external payable {
        fund();
    }

    receive() external payable {
        fund();
    }

    /**
     *View/Pure function seran nuestro (Getter)
     */

    /*Crearemos funciones para actualizar las funciona 'privadas' */
    function getAddressToAmountFunded(
        address fundingaddress
    ) external view returns (uint256) {
        return s_addressToAmountFunded[fundingaddress];
        /*Hacemos esto por varias razones:
    1. Hacer un codigo mas leible usando 'getters' en vez de usar 's_'
    (e.g. s_addressToAmountFuded)
    2. Hacer mas eficientes en gas y usar las funciones publicas cuando
    queramos.
     */
    }

    function getFunder(uint256 index) external view returns (address) {
        return s_funders[index];
    }

    function getOwner() external view returns (address) {
        return i_owner;
    }
}

// Concepts we didn't cover yet (will cover in later sections)
// 1. Enum
// 2. Events
// 3. Try / Catch
// 4. Function Selector
// 5. abi.encode / decode
// 6. Hash with keccak256
// 7. Yul / Assembly
