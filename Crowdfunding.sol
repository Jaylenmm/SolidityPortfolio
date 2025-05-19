//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// Create a crowdfunding smart contract

contract CrowdFunding {
    // create a Campaign struct to define and group together 
    // all essential details we will need for campaign creation 
    // and manipulation later on.
    struct Campaign{
        address owner; // creator of the campaign
        string title; // name of the campaign
        string description; // description/purpose of the campaign
        uint256 target; // campaign profit target
        uint256 deadline; // donation deadline
        uint256 amountCollected; // amount of currency collected toward campaign target
        string image; // customizable image for campaign decoration in app
        address[] donators; // establish an array/list of donators
        uint256[] donations; // establish an array/list of donations made
    }

    // create a mapping of the "Campaign" struct and call it campaigns 
    mapping(uint256 => Campaign) public campaigns;

    // create a global variable initially set to zero that will 
    // keep track of the number of campaigns created so that we can 
    // assign campaign IDs
    uint256 public numberOfCampaigns = 0;

    // establish essential functions and their relevant parameters of the contract

    // the createCampaign function is going to require a majority of the variables described
    // in the Campaign struct established above. This is a client side function so it will 
    // need a public descriptor so users can actually perform this function and receive the 
    // return from this function, the new campaign ID#
    function createCampaign(address _owner, string memory _title, string memory _description, uint256 _target) public returns (uint256 /*new campaign ID*/) {
        // create a new campaign and add it to the campaigns array
        Campaign storage campaign = campaigns[numberOfCampaigns];

        // require statement checks if deadline parameter is a logical future date from the current block timestamp
        // require(_deadline > block.timestamp, "The deadline should be a date in the future.");

        // build out campaign with the given parameters
        campaign.owner = _owner;
        campaign.title = _title; 
        campaign.description = _description;
        campaign.target = _target;
        // campaign.deadline = _deadline;
        campaign.amountCollected = 0;
        // campaign.image = _image;

        // add the new campaign to the numberOfCampaigns variable 
        numberOfCampaigns++;

        // return the index of the newest campaign w/ the new campaign ID
        return numberOfCampaigns - 1;


    }

    // donateToCampaign is going to require the id of a valid campaign the user would like to 
    // donate to
    function donateToCampaign(uint256 _id) public payable {
        // create an amount variable that will take in the desired amount 
        // to be donated.
        uint256 amount = msg.value;

        // get the campaign we want to donate to
        Campaign storage campaign = campaigns[_id];

        // push the address of the person that donated and their amount
        campaign.donators.push(msg.sender);
        campaign.donations.push(amount);

        // establish a boolean variable that will verify the donation was sent
        (bool sent,) = payable(campaign.owner).call{value: amount}(""); 

        // if the sent variable is true we will add the donation amount to the 
        // total amount collected
        if(sent) {
            campaign.amountCollected = campaign.amountCollected + amount;
        }
    }

    // a straightforward view function that will pass in the campaign id and return the associated array
    // of donators and donations 
    function getDonators(uint256 _id) view public returns(address[] memory, uint256[] memory ) {
        return (campaigns[_id].donators, campaigns[_id].donations);
    } 

    // again a straightforward get function that will pass in the campaign id and return the associated
    // array of campaigns and 
    function getCampaigns() view public returns(Campaign[] memory) {
        // create a new array variable
        Campaign[] memory allCampaigns = new Campaign[](numberOfCampaigns); // creating an array that passes in the numberOfCampaigns created

        for(uint i = 0; i < numberOfCampaigns; i++) {
            Campaign storage item = campaigns[i];

            allCampaigns[i] = item;
        }

        return allCampaigns;
    }
}
