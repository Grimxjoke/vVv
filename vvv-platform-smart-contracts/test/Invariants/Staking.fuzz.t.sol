// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;


//Original Contract to Test
import {VVVETHStaking} from "../../contracts/staking/VVVETHStaking.sol";
import { VVVAuthorizationRegistry } from "contracts/auth/VVVAuthorizationRegistry.sol";
import { VVVToken } from "contracts/tokens/VvvToken.sol";

//Test Contract for Team testing
import {VVVETHStakingTestBase} from "../staking/VVVETHStakingTestBase.sol";

//Handler Contract
import {Handler} from "./Handlers/Staking.h.t.sol";



contract StakingInvariant is VVVETHStakingTestBase {
    
    //Instantiate Contract Declaration
    VVVETHStaking public staking;
    Handler public handler;
    VVVToken public vvvToken;

    function setUp() public {
        vm.startPrank(deployer);

        AuthRegistry = new VVVAuthorizationRegistry(defaultAdminTransferDelay, deployer);
        staking = new VVVETHStaking(address(AuthRegistry));
        vvvToken = new VVVToken(type(uint256).max, 0, address(AuthRegistry));

        //Deploy Handler Last with the address of the newly deploy Contract to test
        //If the Contract has a "receive payable" function, have to set the address as "payable"
        handler = new Handler(payable(address(staking)));

        { //This part is just copied from the Original Test Setup Function.
        AuthRegistry.grantRole(ethStakingManagerRole, ethStakingManager);
        bytes4 setDurationMultipliersSelector = staking.setDurationMultipliers.selector;
        bytes4 setNewStakesPermittedSelector = staking.setNewStakesPermitted.selector;
        bytes4 setVvvTokenSelector = staking.setVvvToken.selector;
        bytes4 withdrawEthSelector = staking.withdrawEth.selector;


        AuthRegistry.setPermission(
            address(staking),
            setDurationMultipliersSelector,
            ethStakingManagerRole
        );
        AuthRegistry.setPermission(
            address(staking),
            setNewStakesPermittedSelector,
            ethStakingManagerRole
        );
        AuthRegistry.setPermission(
            address(staking),
            setVvvTokenSelector,
            ethStakingManagerRole
        );
        AuthRegistry.setPermission(
            address(staking),
            withdrawEthSelector,
            ethStakingManagerRole
        );

        //mint 1,000,000 $VVV tokens to the staking contract
        //audit-info I don't know why the deployer can mint some token , they didn't grant + setPermission to themselves first
        VvvTokenInstance.mint(address(staking), 1_000_000 * 1e18);

        vm.deal(sampleUser, 10 ether);
        vm.stopPrank();

        //now that ethStakingManager has been granted the ETH_STAKING_MANAGER_ROLE, it can call setVvvToken and setNewStakesPermitted
        vm.startPrank(ethStakingManager, ethStakingManager);
        staking.setVvvToken(address(VvvTokenInstance));
        staking.setNewStakesPermitted(true);
        vm.stopPrank();
        }
    }

    function invariant_testFunction() public {

    }


}

 