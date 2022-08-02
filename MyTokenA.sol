// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract MyTokenA is ERC20, Ownable {
    constructor() ERC20("TokenA", "ToA") {}

    function mint(address to) public onlyOwner {
        _mint(to, 100000000000000000000000);
    }
}