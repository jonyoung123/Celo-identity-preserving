// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

contract Accounts {
    // Mapping from hashed phone numbers to array of addresses
    mapping (string => address[]) private accounts;

    // Event emitted when a new address is added
    event AddressAdded(string hashedPhoneNumber, address account);

    // Add a new address to a phone number
    function addAddress(string memory hashedPhoneNumber, address account) public {
        // Ensure the address isn't null
        require(account != address(0), "Invalid address");

        // Check that the address isn't already added
        address[] memory associatedAddresses = accounts[hashedPhoneNumber];
        for (uint256 i = 0; i < associatedAddresses.length; i++) {
            require(associatedAddresses[i] != account, "Address already added");
        }

        // Add the address
        accounts[hashedPhoneNumber].push(account);

        // Emit an event
        emit AddressAdded(hashedPhoneNumber, account);
    }

    // Get the addresses associated with a phone number
    function lookupAccounts(string memory hashedPhoneNumber) public view returns (address[] memory) {
        return accounts[hashedPhoneNumber];
    }
}