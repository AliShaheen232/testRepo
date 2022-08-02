// SPDX-License-Identifier: MIT

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@uniswap/v2-core/contracts/interfaces/IUniswapV2Factory.sol";
import "@uniswap/v2-core/contracts/interfaces/IUniswapV2Pair.sol";
import "@uniswap/v2-periphery/contracts/interfaces/IUniswapV2Router02.sol";
import "./Console.sol";

pragma solidity ^0.8.0;

contract Bridge{
    IERC20 private ERC20Token1;
    IERC20 private ERC20Token2;
    IUniswapV2Factory private factory;
    IUniswapV2Router02 private router;
    IUniswapV2Pair private v2Pair;
    address private pair1;
    address private pair2;
    address private pair;
    address private tokenERC1;
    address private tokenERC2;
    address private Weth;
    uint256 public liquidity;
    uint256 public liquidity2;

    uint256 public removedETH;
    uint256 public removedToken;
    uint256  public  amounts;
    mapping (address => uint256) public amountEth;

    constructor(address tokenA, address tokenB){
        tokenERC1 = tokenA;
        tokenERC2 = tokenB;

      ERC20Token1=  IERC20(tokenERC1);
      ERC20Token2=  IERC20(tokenERC2);

      router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
      Weth = router.WETH();
      factory = IUniswapV2Factory(router.factory());
      pair1 = factory.createPair(Weth, address(ERC20Token1));
      pair2 = factory.createPair(Weth, address(ERC20Token2));

    }

    function addLiquidity(address tokenERC, uint256 tokenAmount) public payable {
        IERC20(tokenERC).transferFrom(msg.sender,address(this),tokenAmount);
        IERC20(tokenERC).approve(address(router),tokenAmount);
        (,,liquidity)=router.addLiquidityETH{value:msg.value}(tokenERC,tokenAmount,0,0,address(this),block.timestamp);
        v2Pair=IUniswapV2Pair(pair);
    }
    function reciveEthforTokenB() public payable{
        amountEth[msg.sender] += msg.value;
        console.log(amountEth[msg.sender]);
    }
    function removeAndSwap(address _pair,address tokenERC,address _tokenERC2, uint256 _liquidity) public payable{
       (removedToken,removedETH) = removeLiquidity(_pair, tokenERC,_liquidity );
       amounts = swapTokenToETH(tokenERC, removedToken);
       uint256 fullAmountToken = removedETH+amounts;
       uint256 fullAmountCur = removedETH+amounts;

        amountEth[msg.sender] -= fullAmountCur;
        console.log(amountEth[msg.sender] -= fullAmountCur);



        IERC20(_tokenERC2).transferFrom(msg.sender,address(this),fullAmountToken);
        IERC20(_tokenERC2).approve(address(router),fullAmountToken);
        (,,liquidity2)=router.addLiquidityETH{value:fullAmountCur}(_tokenERC2,fullAmountToken,0,0,msg.sender,block.timestamp);

    }
    function removeLiquidity(address _pair,address tokenERC, uint256 _liquidity) public returns(uint256, uint256){
        // IUniswapV2Pair(_pair).transferFrom(msg.sender,address(this),_liquidity);
        IUniswapV2Pair(_pair).approve(address(router),liquidity);
       (removedToken,removedETH)=router.removeLiquidityETH(tokenERC,_liquidity,0,0,address(this),block.timestamp);
        return (removedToken,removedETH);
    }
    function swapTokenToETH(address tokenERC, uint256 amountToSwap) public returns(uint256) {
        // IERC20(tokenERC).transferFrom(msg.sender,address(this),amountToSwap);
        IERC20(tokenERC).approve(address(router),amountToSwap);
        address[] memory pathForPair;
        pathForPair = new address[](2);
        pathForPair [0] = tokenERC;
        pathForPair [1] = Weth;
        uint256[] memory amountsArr;
        (amountsArr) = router.swapExactTokensForETH(amountToSwap,0,pathForPair,address(this),block.timestamp);
        amounts = amountsArr[0];
        return amounts;
    }
    function getPair1() public view returns(address){
        return pair1;
    }
    function getPair2() public view returns(address){
        return pair2;
    }
    function getPair() public view returns(address){
        return pair;
    }
    function setPair(address pair_) public{
        pair = pair_;
    }
}