
pragma solidity >=0.7.0 <0.9.0;


// bi-weekly paySchedule smart contract for employers
contract paySchedule {
   
   struct employee {
    
    address employer;
    address worker;
    uint amount;
    uint timestamp;
    bool employed;
       
   }
   
   struct employer {
       
       uint deposit;
       
   }
   
   
   mapping(address => employer) public employers; 
   
   mapping(address => employee) public payroll;
   
   
   function updatePayroll(address worker, uint amount) public {
       
       payroll[worker].employer = msg.sender;
       
       payroll[worker].worker = worker;
       payroll[worker].amount = amount;
       payroll[worker].timestamp = block.timestamp;
       payroll[worker].employed = true;
       
   }
   
   function withdraw(address boss) public {
        require(payroll[msg.sender].amount > 0, "Address not on payroll");
        //require(block.timestamp >= payments[msg.sender].timestamp + 1210000);
        require(payroll[msg.sender].employed == true, "address was removed from payroll");
        
        require(employers[boss].deposit >= payroll[msg.sender].amount, "Not enough balance in contract");
        
        uint payment;
        
        payroll[msg.sender].timestamp = block.timestamp;
        
        payment = payroll[msg.sender].amount;
        
        payable(msg.sender).transfer(payment);
   }
   
   function deposit() public payable {
       
       employers[msg.sender].deposit += msg.value;
       
   }
   
   
   
   function fireEmployee(address worker) public {
       require(msg.sender == payroll[worker].employer);
       
       // employer can't fire employee less than one week before payday
       require(block.timestamp <= payroll[msg.sender].timestamp + 604800, "You can't fire employee less than one week before payday");
       payroll[worker].employed = false;
       
   }
   
   
   
    function getContractBalance() public view returns(uint){
        return address(this).balance;
    }
    
    function getEmployerBalance(address boss) public view returns(uint) {
        
        return employers[boss].deposit;
    }

   
}
   

    
