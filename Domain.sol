//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract ENS {
    /////////////////EVENTS////////////////
    event DomainEvent(string domain, address user);
        
    ////////////////STATE//////////////////
    mapping(address => string) userNames;
    mapping(string => bool) registeredDomainUsers; 
    mapping(address => bool) registered;
    mapping(address => uint256) userDomains; // new mapping to track the index of each user's domain name
   
    string[] AllRegisteredDomains;


    ///////////////ERROR///////////////
    error ZeroAddress();
    error DomainExists();
    

    //function to register user domain
    function registerDomain(string memory _domain) external {
        if(registeredDomainUsers[_domain] == true){
            revert DomainExists();
        }
     
        if(registered[msg.sender] == true){
            revert ("Address has a domain!, update domain");
        }

        userNames[msg.sender] = _domain;
        registeredDomainUsers[_domain] = true;
        registered[msg.sender] = true;
        AllRegisteredDomains.push(_domain);
        userDomains[msg.sender] = AllRegisteredDomains.length - 1; // store the index of the domain name

        emit DomainEvent(_domain, msg.sender);
    }

    //function to reassign user domain
    function reassignDomain(string memory _newDomain, address user) external {
        //check that user is registered
        require(registered[user]==true, "Address don't have a domain");
        if(registeredDomainUsers[_newDomain] == true){
            revert DomainExists();
        }

        require(msg.sender == user, "Not account owner");

        if(user == address(0)){
            revert ZeroAddress();
        }
       
        string memory oldDomain = userNames[user];
        registeredDomainUsers[oldDomain] = false;

        // update the AllRegisteredNames array using the stored index
        uint domainIndex = userDomains[user];
        AllRegisteredDomains[domainIndex] = _newDomain;

        userNames[user] = _newDomain;
        registeredDomainUsers[_newDomain] = true;

        emit DomainEvent(_newDomain, msg.sender);
    }

    //function to get a user's domain
    function getDomain(address _domainAddress) external view returns(string memory){
        return userNames[_domainAddress];
    }

    //function to check if a name already exists
    function isDomainRegistered(string memory domain) external view returns (bool) {
        return registeredDomainUsers[domain];
    }

    function getAllregisteredDomains() external view returns(string[] memory){
        return AllRegisteredDomains;
    }
}