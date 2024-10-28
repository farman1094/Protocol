// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

import {Test, console} from "forge-std/Test.sol";
import {Protocol2} from "src/Protocol2.sol";

import {IERC4626} from "@openzeppelin/contracts/interfaces/IERC4626.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {Vault} from "src/Vault.sol";
import {PrepToken} from "src/PrepToken.sol";

import {Script} from "forge-std/Script.sol";
import {console} from "forge-std/console.sol";
import {MockERC20} from "test/mocks/MockERC20.sol";
import {MockPriceFeed} from "test/mocks/MockPriceFeed.sol";

contract ProtocolTest is Test {
Protocol2 protocol;
PrepToken token;
Vault vault;
MockPriceFeed feed;
address user = makeAddr("user");
address user2 = makeAddr("user2");
    function setUp() public {
        vm.startBroadcast(msg.sender);
        feed = new MockPriceFeed();
        token = new PrepToken();
        protocol = new Protocol2(address(token), msg.sender, address(feed));
        vault = new Vault(address(token), protocol);
        protocol.updateVaultAddress(address(vault));
        vm.stopBroadcast();
            
    }

    function testCheckBasicMath() public view {
        address vaultAddr = protocol.getVaultAddress();
        assert (vaultAddr == address(vault));
    }

    function testDepositCollateralAndOpenPosition() public {
        vm.startPrank(msg.sender);
        token.mint();
        token.approve(address(protocol), 100 ether);
        protocol.depositCollateral(100 ether);
        assert(protocol.getCollateralBalance(msg.sender) == 100 ether);
        // protocol.withdrawCollateral(100 ether);

        // Opening Positions ------------------------------------
        protocol.openPosition(1500 ether, true);
        assert(protocol.getNumOfOpenPositions() == 1);

        (uint256 size, uint256 sizeOfToken, bool isLong) = protocol.getPositionDetails(msg.sender);
        console.log("size:", size);
        console.log("sizeOfToken:", sizeOfToken);
        if(isLong) console.log("isLong: TRUE");
    
        (uint256 totalSize, uint256 totalSizeOfToken) = protocol.getTotalLongPositions();   
        console.log(totalSize,"totalSize");
        console.log(totalSizeOfToken, "totalSizeOfToken");

        // Closing Positions -----------------------------------
        protocol.closePosition();
        vm.stopPrank();
        }







//    function testtingERC4626() public view {
//        uint256 totalAssets = vault.totalAssets();
//         address coll = vault.asset();
//         uint256 bal = token.balanceOf(msg.sender);
//         console.log("totalAssets",totalAssets);
//         console.log("coll",coll);
//         console.log("Msg.sender bal:",bal);
//    }

//    function testUsageOfVault() public {
//     // msg sender ------------------------------------------
//     vm.startPrank(msg.sender);

//     token.transfer(user2,2e18);
//     token.transfer(user,5e18);
//     assert(token.balanceOf(msg.sender) == token.balanceOf(user));
//     token.approve(address(vault), 5e18);
//     vault.deposit(5e18, msg.sender);
//     consoleTotalAssets();

//     uint256 maxShare = vault.maxMint(msg.sender);
//     console.log("maxShare",maxShare);

//     uint256 num = vault.previewDeposit(5e18);
//     console.log("shares get",num);

//     uint256 balanceOfshare = vault.balanceOf(msg.sender);
//     console.log("balanceOfshare",balanceOfshare);
//     vm.stopPrank();

//     //USER -------------------------------------------
//     vm.startPrank(user);
//     token.approve(address(vault), 5e18);
//     vault.deposit(5e18, user);
//     console.log("AFTER 2 shareholder -----------------------");
//     uint256 UserbalanceOfshare = vault.balanceOf(user);
//     uint256 UserbalanceOfshare1 = vault.balanceOf(msg.sender);
//     console.log(UserbalanceOfshare, "UserbalanceOfshare");
//     console.log(UserbalanceOfshare1, "UserbalanceOfshare1");
//     vm.stopPrank();

//     //USER2  -------------------------------------------

//     vm.startPrank(user2);
//     token.approve(address(vault), 2e18);
//     vault.deposit(2e18, user2);
//     console.log("AFTER 3 shareholder -----------------------");
//     uint256 UserbalanceOfshare3 = vault.balanceOf(user);
//     uint256 User2balanceOfshare3 = vault.balanceOf(user2);
//     uint256 MsgbalanceOfshare3 = vault.balanceOf(msg.sender);
//     uint256 total = vault.totalSupply();
//     console.log(UserbalanceOfshare3, "UserbalanceOfshare3");
//     console.log(User2balanceOfshare3, "User2balanceOfshare3");
//     console.log(MsgbalanceOfshare3, "MsgbalanceOfshare3");
//     console.log(total, "total");

//     console.log("Redeem shares -----------------------");
//     //  withdraw(uint256 assets, address receiver, address owner)
//     console.log("balanceBeforeWithdraw", vault.balanceOf(user2));
//     console.log("balanceBeforeWithdraw Collateral:", token.balanceOf(user2));
//     uint256 redeemShared = vault.withdraw(2e18, user2, user2);
//     assert(2e18 == redeemShared);
//     console.log("balanceAfterWithdraw", vault.balanceOf(user2));
//     console.log("balanceAfterWithdraw Collateral:", token.balanceOf(user2));
//     vm.stopPrank();
//    }
//     function testUsageOfTransferingVault() public {
//     vm.startPrank(msg.sender);
//     token.approve(address(vault), 5e18);
//     vault.deposit(5e18, user);
//     token.balanceOf(address(vault));
//     vm.stopPrank();


//     vm.startPrank(address(vault));
//     token.approve(user, type(uint256).max);
//     vm.stopPrank();


//     vm.startPrank(address(user));
//     console.log("USER:", token.balanceOf(address(vault)));
//     token.transferFrom(address(vault), user, token.balanceOf(address(vault)));
//     console.log("USER:", token.balanceOf(user));


//     }



    function consoleTotalAssets() internal view {
       uint256 totalAssets = vault.totalAssets();
        console.log("totalAssets",totalAssets);
   }


}