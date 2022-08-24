// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;
import "./resumeNft.sol";
import "./resumeToken.sol";
contract TokenFarm {
    string public name = "Resume nFT Farm";
    address public owner;
    uint public price = 1000 * 10 ** 18;  // stake 1000 tokens
    uint public duration = 60;          // for 60 seconds to redeem NFT
    uint public stakefees= price/100;
    uint public unstakefees= price/200;
    resume public bacon;
    Resumee public zcupToken;

address Charity=0xcC6BB7befd7927E76F48132cE28EbF5020B46b59;
address Creator=0xA1d9722dF01138907c6b1ef0A1b96D66eB35D10f;

    address[] public stakers;
    mapping(address => uint) public userStakingStart;
    mapping(address => uint) public stakingBalance;
    mapping(address => bool) public hasStaked;
    mapping(address => bool) public isStaking;
    constructor( resume _bacon, Resumee _zcupToken){
        bacon = _bacon;
        zcupToken = _zcupToken;
        owner = msg.sender;
    }
    function stakeTokens() public {
        require(!isStaking[msg.sender]);    // cannot stake more if price is already staked

        // Update staking balance
        stakingBalance[msg.sender] = stakingBalance[msg.sender] + price;
        // Add user to stakers array *only* if they haven't staked already
        if(!hasStaked[msg.sender]) {
            stakers.push(msg.sender);
        }
        // Update staking status
        isStaking[msg.sender] = true;
        hasStaked[msg.sender] = true;
        userStakingStart[msg.sender] = block.timestamp;

                //transfer to charity wallet 
        zcupToken.transferFrom(msg.sender, address(Charity), stakefees);
        // Trasnfer ZCUP tokens to this contract for staking
        zcupToken.transferFrom(msg.sender, address(this), price);
    }
    // Unstaking Tokens (Withdraw)
    function unstakeTokens() public {
        // Fetch staking balance
        uint balance = stakingBalance[msg.sender];
        // Require amount greater than 0
        require(balance > 0, "staking balance cannot be 0");

        // Reset staking balance
        stakingBalance[msg.sender] = 0;
        
        // Reset timer
        userStakingStart[msg.sender] = 0;
        // Update staking status
        isStaking[msg.sender] = false;
                //transfer tokens to creator wallet
        zcupToken.transferFrom(msg.sender, address(Creator), unstakefees);
        // Transfer ZCUP tokens to this contract for staking
        zcupToken.transfer(msg.sender, balance);

         // Mint nft
        if(block.timestamp - userStakingStart[msg.sender] >= duration)bacon.safeMint(msg.sender);
        
    }
}