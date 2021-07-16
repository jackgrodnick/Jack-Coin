pragma solidity ^0.8.6;

contract jackToken {


    mapping (address => uint256) public balance;
    address public minter;
    
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Reward(address indexed to, uint256 value);

    string public name = "Jack Token";
    string public symbol = "Jack";
    uint256 public max_supply = 21000000.000000000;
    uint256 public circulating_supply = 0.000000000;
    uint256 public reward = 10.000000000;
    uint public decimals = 9;
    uint public timeOfLastHalving;
    uint public timeOfLastIncrease;
    uint internal creatorReward;
 

	constructor() {
        timeOfLastHalving = block.timestamp;
        timeOfLastIncrease = block.timestamp;
        minter = msg.sender;
        giveCreatorReward();
        creatorReward = 1;
    }
    
    function updateSupply() public {

        if (block.timestamp - timeOfLastHalving >= 2103797 minutes) {
            require(circulating_supply <= max_supply);
            reward /= 2;
            timeOfLastHalving = block.timestamp;
        }

        if (block.timestamp - timeOfLastIncrease >= 150 seconds) {
            require(circulating_supply+reward <= max_supply);
            balance[msg.sender] += reward;
            circulating_supply += reward;
            timeOfLastIncrease = block.timestamp;
            emit Reward(msg.sender, reward);
        }
        
    }
    
    function giveCreatorReward() internal {
        require(msg.sender == minter && creatorReward != 1);
        
        balance[minter] += max_supply/10;
        circulating_supply += max_supply/10;
    }

    function transfer(address _to, uint256 _value) public {
        require(balance[msg.sender] >= _value); 
        require(balance[_to] + _value >= balance[_to]);
        balance[msg.sender] -= _value;
        balance[_to] += _value;



        emit Transfer(msg.sender, _to, _value);
    }

}