// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {CommonBase} from "../../../lib/forge-std/src/Base.sol";
import {StdCheats} from "../../../lib/forge-std/src/StdCheats.sol";
import {StdUtils} from "../../../lib/forge-std/src/StdUtils.sol";
// /home/paul/Security/Contest/Sherlock/vVv/vvv-platform-smart-contracts/lib/forge-std/src/StdUtils.sol

import {VVVETHStaking} from "../../../contracts/staking/VVVETHStaking.sol";


contract Handler is CommonBase, StdCheats, StdUtils {

    VVVETHStaking staking;
    
    constructor(address payable _stakingAddress) {
        staking = VVVETHStaking(_stakingAddress);
    }

    function test_FunctionWillBeStatefullFuzz() public {
        
    }
}
