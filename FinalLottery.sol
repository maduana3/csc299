pragma solidity ^0.4.20;

contract Lottery {
   
    address public owner;
    address[] public beneficiary;
    uint256 public winning_number;
    uint public startTime;
    uint public endTime;
    uint public revealTime;
    uint public distributeAmount;
    //uint public a;
    //uint public contractBal;
   // modifier onlyAfter(uint _time) { require(now > _time); _; }
    
    constructor(
        uint biddingSeconds,
        uint biddingMins,
        uint biddingHours,
        uint biddingDays
         ) public {
        owner = msg.sender;
        startTime = now; 
        endTime = startTime + biddingSeconds + (biddingMins * 1 minutes) + (biddingHours * 1 hours) + (biddingDays * 1 days);
    }
    
    mapping(address => bytes32) playedNum;

    function play (bytes32 h) external payable {
        require(now <= endTime);
        playedNum[msg.sender] = h;
     

    }

    function winning (uint256 _winning_number, uint revealSec, uint revealMin, uint revealHour) external {
       require (owner == msg.sender && now > endTime);
        winning_number = _winning_number;
        revealTime = now + revealSec + (revealMin * 1 minutes) + (revealHour * 1 hours);
       
    }

    function reveal (uint256 r) external {
        require (now <= revealTime);
            bytes32 h = sha256 (winning_number, r);
            require (playedNum[msg.sender] == h);
            beneficiary.push(msg.sender);
            //a = beneficiary.length;
            //contractBal = address(this).balance;
    }

    function done () external {
        require(now > revealTime);
        //if (beneficiary.length == 0) {
        //    owner.transfer(address(this).balance);
       // }
        if (beneficiary.length > 0){
            distributeAmount = address(this).balance / beneficiary.length;
            //uint a = beneficiary.length;
            for (uint i = 0; i < beneficiary.length; i++)
                beneficiary[i].transfer(distributeAmount);
        }
        //else if (beneficiary.length == 0)
        //    owner.transfer(address(this).balance);
        //}
    }   
}