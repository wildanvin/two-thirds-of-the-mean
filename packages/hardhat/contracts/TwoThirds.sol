//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract TwoThirds {

    uint256 public constant BOUNTY = 100*10**18;

    uint16 public mean;
    uint16 public numOfPlayers;
    uint16 public sum;
    mapping(address => bool) public isPlaying;
    mapping(address => uint16) public playerValue;
    //mapping(address => bool) public isWinner;
    mapping(address => uint256) public balances;
    address[] public winners;
    address[] public players;
    bool public calculateWinnersExecuted = false;


    modifier only50Players {
        require (numOfPlayers <= 50, "No more players");
        _;
    }

   
    function play (uint16 _value) public only50Players {
        require (_value <= 100, "Value out of range");
        require (!isPlaying[msg.sender], "Already playing");
        
        isPlaying[msg.sender] = true;
        playerValue[msg.sender] = _value;
        players.push(msg.sender);

        numOfPlayers += 1;
        sum += _value;
        mean = sum / numOfPlayers;
    }



    function testCalculateWinners () public {
        //require(numOfPlayers == 50, "Game is not over")
        require(!calculateWinnersExecuted, "Alredy executed");
        uint256 countWinners;
        for (uint i = 0; i < numOfPlayers; i++) {
            if (playerValue[players[i]] == mean) {
                //isWinner[players[i]] = true;
                winners.push(players[i]);
                countWinners += 1;
            }
            
        }

        if (countWinners == 0){
            return;
        } else {
            uint256 reward = BOUNTY / countWinners;
            for (uint j = 0; j < countWinners; j++){
                balances[winners[j]] = reward;
            }
        }
        calculateWinnersExecuted = true;
    }

    function testPlay (uint16 _value) public {
        
        isPlaying[msg.sender] = true;
        playerValue[msg.sender] = _value;
        players.push(msg.sender);

        numOfPlayers += 1;
        sum += _value;
        mean = sum / numOfPlayers;
    }

    function testDivision (uint16 _num1, uint16 _num2) public pure returns(uint16) {
        return _num1 / _num2;

    }
}