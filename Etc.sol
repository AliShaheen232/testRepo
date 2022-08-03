// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;
import "./Console.sol";


contract Etc{
    struct Data{
        address Addr;
        uint256 price;
    }
    mapping (string => Data) public data;
    mapping (address => string[]) public addrToStr;
            address[] addrArr;
        uint256[] priceArr;

    function setData(uint256 _pri, string memory _str) external {
        data[_str].Addr = msg.sender;
        data[_str].price = _pri;
        addrToStr[msg.sender].push(_str);
    }

    function getData(string memory _str) public view returns(address _Addr, uint256 _price ){
        return (data[_str].Addr,data[_str].price);
    }

    function setaddrToStr() public  returns(address[] memory _Addr, uint256[] memory _price){
        uint256 length = addrToStr[msg.sender].length;
        console.log("length: " ,length);
        addrArr = new address[](length);
        priceArr = new uint256[](length);
       
        string[] memory strArr;
        strArr = addrToStr[msg.sender];
        uint256 length1 = strArr.length;
        // strArr = new string [](length);

        console.log("length1: ",length1);

        for (uint i = 0; i<strArr.length;i++){
           (address AddrOf, uint256 priceOf)= getData(strArr[i]);
           addrArr.push(AddrOf);
           priceArr.push(priceOf);
        }

        // console.log("addrArrAft: " ,addrArr);
        // console.log("priceArrAft: " ,priceArr);

        return(addrArr, priceArr);

    }
    function getaddrToStr() public view returns(address[] memory _Addr, uint256[] memory _price){

        return(addrArr, priceArr);

    }
    
}