// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.5.0 <0.9.0;

contract Event_org{

    struct _event{
        address organizer;
        string name;
        uint date;
        uint price;
        uint totalTickets;
        uint remainTickets;
    }

    mapping(uint => _event) public eventsList;   //mapping IDs to event
    uint eventID;

    mapping(address => mapping(uint=>uint)) public tickets;    //ticket buyer add => (event id => quantity

    function createEvent(string memory name, uint date, uint price, uint totalTickets) external
    {
        require(date>block.timestamp, "invalid date");
        require(totalTickets>0, "no. of tickets must be greater than 0");
        eventsList[eventID] = _event(msg.sender, name, date, price, totalTickets, totalTickets);
        eventID++;
    }

    function buyTicket(uint id, uint quantity) external payable
    {   
        require(eventsList[id].date != 0, "invalid event id");
        require(eventsList[id].date > block.timestamp, "event has already occured");
        
        _event memory reqEvent =  eventsList[id];   //for easy access
        require(quantity <= reqEvent.remainTickets, "not enough tickets left");       
        require(msg.value == reqEvent.price * quantity, "not enough payment");

        tickets[msg.sender][id]+=quantity;  //alloting tickets
        reqEvent.remainTickets-=quantity;   //reducing remian tickets
    }

    function transfer(uint id, uint quantity, address to) external
    {   
        require(eventsList[id].date != 0, "invalid event id");
        require(eventsList[id].date > block.timestamp, "event has already occured");
        require(quantity <= tickets[msg.sender][id], "you don't have enough tickets");

        tickets[msg.sender][id]-=quantity;
        tickets[to][id]+=quantity;

    }
}
