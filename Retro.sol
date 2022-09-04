pragma solidity >=0.5.0;

// Let's write a ERC20Token contract by declaring all our methods

contract RetroToken {  //the 'address' used in all these functions is the  ETH public key of a user
    string public constant name = "RETRO";
    uint8 public constant decimals = 18;
    string public constant symbol = "RTR";


    event Transfer(address indexed _from, address indexed _to, uint256 _value); //emits details of transfer
    event Approval(address indexed _owner, address indexed _spender, uint256 _value); //emits details of approval


    mapping (address => uint256) balances; //this will hold the token balances for each owner account
    mapping (address => mapping (address => uint256)) allowed; // this will include all of the accounts approved to withdraw from a given account together with the withdrawal sum allowed for each
    uint256 totalSupply; //this public integer will hold the amount of tokens in circulation

    using SafeMath for uint256; //  let us add the following statement introducing the library to the Solidity compiler

    // Set the total amount of tokens at contract creation time and initially assign all of them to the “contract owner” i.e. the account that deployed the smart contract:

    constructor(uint256 total) public {
        totalSupply = total;
        balances[msg.sender] = totalSupply;
    }

    function totalSupply() public view returns (uint256) {
        return totalSupply;
    } // the total value of tokens in circulation
    function balanceOf(address _owner) public view returns (uint) { // just return the value stored in the balances array for the address inputted
        return balances[_owner];
    }  
    function transfer(address _to, uint _value) public returns (bool) { //the address to send to and the amount to send and returns a success message
        require(_value <= balances[msg.sender]); // amount to send should be equal to or greater than the ender balance
        
        balances[msg.sender] = balances[msg.sender].sub(_value); //deduct the amount from senders account
        balances[_to] = balances[_to].add(_value); //add the amount to receiver's account
        emit Transfer(msg.sender, _to, _value); //emit transfer details showing from, to and amount
        return true;
    } 

    function approve(address _spender, uint _value) public returns (bool) { 
        allowed[msg.sender][_spender] = _value; //this allows allowances to be added for the sender to withdraw tokens from a certain address.
        emit Approval(msg.sender, _spender, _value); //the allowed method above will call the Approval event to emit approval details
        return true; 
    }

    function allowance(address _owner, address _spender) public view returns (uint) { // return the allowances an address can withdraw from another address
        return allowed[_owner][_spender];

    }

    function transferFrom(address _from, address _to, uint _value) public returns (bool) { //this function is almost similar to the transfer function above
        require(_value <= balances[_from]); // restrictions on sender account balance before initiating transaction
        require(_value <= allowed[_from][msg.sender]); //here we add the restriction of allowed value from the sender.

        balances[_from] = balances[_from].sub(_value);
        allowed[_from][msg.sender] = allowed[from][msg.sender].sub(_value);
        balances[_to] = balances[_to].sub(_value);
        Transfer(_from, _to, _value);
        return true;
    }

    
     
    // The function below approves then calls the receiving contract. It runs when the contract is authorized to transfer an amount of tokens from th senders account. function receiveApproval() is called in the receiving contract.

//     function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
//         allowed[msg.sender][_spender] = _value;
//         Approval(msg.sender, _spender, _value);

//         if(!_spender.call(bytes4(bytes32(sha3("receiveApproval(address, uint256, address, bytes)"))), msg.sender, _value, this, _extraData)) { throw;}
//         return true;
//     }
// }


// Let’s add SafeMath to our code to secure it from hackers

library SafeMath {
    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        assert(b <= a);
        return a - b;
    }
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        assert(c >= a);
        return c;
    }
}

// SafeMath uses assert statements to verify the correctness of the passed parameters. Should assert fail, the function execution will be immediately stopped and all blockchain changes shall be rolled back.






// Now that our contract is done, we can deploy it to the Ethereum testnet 
//  Download Metamast extension and set up an account. go to your prefered faucet and get 1 free test Ether.

// Visit the Ethereum's Solidity IDE remix.ethereum.org to deploy this contract.
// Copy the contract code and click on the run tab up top. Make sure your environment is set to Injected Web3 and then select on your token contract and click create. Metamask will now pop up asking to complete the transaction of paying for fees. Once you click submit, your contract will be published.
// If you go to the "sent" tab on Metamask, you will be able to see that our contract is published.


