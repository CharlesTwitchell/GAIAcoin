pragma solidity ^0.5.0;

import "./GaiaCoin.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/crowdsale/Crowdsale.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/crowdsale/emission/MintedCrowdsale.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/crowdsale/validation/CappedCrowdsale.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/crowdsale/price/IncreasingPriceCrowdsale.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/crowdsale/validation/TimedCrowdsale.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/crowdsale/distribution/RefundablePostDeliveryCrowdsale.sol";


// Have the KaseiCoinCrowdsale contract inherit the following OpenZeppelin:
// * Crowdsale
// * MintedCrowdsale
// UPDATED THE CONTRACT SIGNATURE TO ADD THE ABOVE INHERITANCE
contract GaiaCoinCrowdsale is Crowdsale, MintedCrowdsale, CappedCrowdsale, TimedCrowdsale, RefundableCrowdsale{
    uint256 public currentRate = 1;
    // Provide parameters for all of the features of your crowdsale, such as the `rate`, `wallet` for fundraising, and `token`.
    constructor(
        uint256 rate,  // rate in TKNbits
        address payable wallet, // sale beneficiary
        GaiaCoin token, // GaiaCoin itself that the GaiaCoinCrowdsale will work with
        uint goal, // the crowdsale goal
        uint open, // the crowdsale opening time
        uint close // the crowdsale closing time
    ) public 

    Crowdsale(rate, wallet, token)
    CappedCrowdsale(goal)
    TimedCrowdsale(open, close)
    RefundableCrowdsale(goal)
    {
    
        // constructor can stay empty
        
        
    }
}

    contract GaiaCoinCrowdsaleDeployer {
    // Create an `address public` variable called `kaseiTokenAddress`.
    address public GaiaTokenAddress;
    // Create an `address public` variable called `kaseiCrowdsaleAddress`.
    address public GaiaCrowdsaleAddress;

    // Add the constructor.
    constructor(
       string memory name,
       string memory symbol,
       address payable wallet,
       uint initialSupply,
       uint goal
    ) public {
        // Create a new instance of the GaiaCoin contract.
        GaiaCoin token  = new GaiaCoin(name, symbol, initialSupply);
        
        // Assign the token contract’s address to the `kasei_token_address` variable.
        GaiaTokenAddress = address(token);

        // Create a new instance of the `KaseiCoinCrowdsale` contract
        GaiaCoinCrowdsale gaiaCrowdsale = new GaiaCoinCrowdsale(1, wallet, token, goal, now, now + 30 minutes);
            
        // Aassign the `KaseiCoinCrowdsale` contract’s address to the `kaseiCrowdsaleAddress` variable.
        GaiaCrowdsaleAddress = address(gaiaCrowdsale);

        // Set the `KaseiCoinCrowdsale` contract as a minter
        token.addMinter(GaiaCrowdsaleAddress);
        
        // Have the `KaseiCoinCrowdsaleDeployer` renounce its minter role.
        token.renounceMinter();
    }
}