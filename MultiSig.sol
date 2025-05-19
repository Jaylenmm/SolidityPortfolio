// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// Develop a multi signature wallet contract
contract SecureSpend{
// create a wallet that will only transfer funds when two or more authorized 
// signers confirm

    address public admin;
    uint walletBalance;
    address[] public signers; // create list of signers
    address payable public beneficiary;// create a beneficiary
    mapping(address => bool) public isSigner; // create mapping of signers used to validate the signer

    constructor() {
        admin = msg.sender; 
    }

    function setSigners(address _signer) external {
        require(msg.sender == admin, "Sorry, only admins can set signers");
        signers.push(_signer);
    }

    function getSigners() public view returns(address[] memory) {  
        return signers;
    }

    function sendFunds(uint _amount, address _signer1, address _signer2, address _beneficiary) external payable returns(bool) {
        require(isSigner[_signer1] && isSigner[_signer2], "You need two signers to authorize this transaction.");
        require(_signer1 != _signer2, "Signers must be different.");
        require(address(this).balance >= _amount, "Insufficient funds");
        require(_beneficiary != address(0), "No beneficiary.");

        beneficiary.transfer(_amount);
        return true;

    }

}
