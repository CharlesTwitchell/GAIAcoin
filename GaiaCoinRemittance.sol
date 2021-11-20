pragma solidity ^0.5.0;

contract GaiaCoinRemittance {
    address payable owner;
    bool isNewAccount;
    uint public accountBalance;
    string FirstName;
    string LastName;
    address payable authorizedRecipient;

    function getInfo() view public returns(address, address payable, bool, uint, string memory, string memory) {
        return (owner, authorizedRecipient, isNewAccount, accountBalance, FirstName, LastName);
    }

    function setInfo(address payable newOwner, address payable newAuthorizedRecipient, bool newAccountStatus, uint newAccountBalance, string memory newFirstName, string memory newLastName) public {
        owner = newOwner;
        authorizedRecipient = newAuthorizedRecipient;
        isNewAccount = newAccountStatus;
        accountBalance = newAccountBalance;
        FirstName = newFirstName;
        LastName = newLastName;
    }

    function sendRemittance(uint amount, address payable recipient) public {
        require(recipient == authorizedRecipient, "The recipient address is not authorized!");
        recipient.transfer(amount);
        accountBalance = address(this).balance;
    }

    function deposit() public payable {
        accountBalance = address(this).balance;
    }

    function() external payable {}
}
