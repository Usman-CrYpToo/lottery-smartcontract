// SPDX-License-Identifier: UNLICENSED

pragma solidity >= 0.7.0;

contract participants{
    address public manager;
    address payable[] public participant;
   
    constructor(){
        manager = msg.sender;
    }

    event takingpart(address indexed sender, address indexed ToContract,uint amount);
    
    receive() external payable {
       
      if (msg.value != 100000000 gwei){
          revert("100000000 gwei is requird to participate");
      }
        else if(msg.sender == manager){
            revert("Manager cannot take part in the lottery");
        }
       else{
        participant.push(payable(msg.sender));
        emit takingpart(msg.sender, address(this), msg.value);
    }}
}

contract getwinner is participants(){
    modifier check{
        require(participant.length >= 3 && msg.sender == manager);
        _;
    }
    event winnerParticipant(address indexed fromContract,address indexed Towinner,uint value);
    
    function random() internal view returns(uint){
        uint hash = uint(sha256(abi.encode(block.timestamp,participant.length)));
        return hash % participant.length;
    }

    function winner() payable public check{
         uint index = random();
         participant[index].transfer(address(this).balance);
         emit winnerParticipant(address(this),participant[index],address(this).balance);
    } 

    function reset() public {
        require(msg.sender == manager);
        participant = new address payable [](0);
    }
}