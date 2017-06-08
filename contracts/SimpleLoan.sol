import "../token/Base.sol";
pragma solidity ^0.4.11;

//Very Basic Loan Contract
contract SimpleLoan {

	enum Status { Pending, Approved, Finished }

	struct Loan {
			address lender;
		  address borrower;
		  //uint constant precision=10000; Precision as no decimals in Solidity TODO
		  uint amount;
		  uint balance;
		  uint interestRate; //Annualized
		  uint interest;
		  uint issuedAt;
			Status status;
	}

  BaseToken token;
  address public tokenAddress;
	address public moderator;
	uint public loanNumber;
	mapping (uint => Loan) public loans;

	event Approval(
			address sender,
			uint256 value,
			uint id
	);

	function SimpleLoan(address _tokenAddress) {

			loanNumber = 0;
			tokenAddress = _tokenAddress;
			token = BaseToken(tokenAddress);
			moderator = msg.sender;
			//status = Status.Pending;
	}

	function approveLoan(uint _id)

	public payable isLender(_id) {

		Loan loan = loans[_id];
		if (token.transferFrom(msg.sender, loan.borrower, loan.amount) != true)
		{
				throw;
		}
		loan.status = Status.Approved;
		loan.issuedAt = block.timestamp;
	}


	function receiveApproval(address _sender, uint256 _value, address _token, uint _id) {
			Loan loan = loans[_id];
			Approval(_sender, _value, _id);
			if (_token != tokenAddress) throw;

			if (_value == loan.amount && _sender == loan.lender) {

					if (token.transferFrom(_sender, loan.borrower, _value) != true)
					{
							throw;
					}
					loan.status = Status.Approved;
					loan.issuedAt = block.timestamp;
			}
	}

	function createLoan(address _lender, address _borrower, uint _amount, uint _interest) {
			uint _id = loanNumber; // campaignID is return variable
			Loan loan = loans[_id];
			loan.lender = _lender;
			loan.borrower = _borrower;
			loan.amount = _amount;
			loan.interest = _interest;
			loanNumber++;
	}

  modifier isLender(uint _id) {
	    if (msg.sender == loans[_id].lender)
	    _;
  }

  modifier isBorrower(uint _id) {
	    if (msg.sender == loans[_id].borrower)
	    _;
  }

	function calculateInterest(uint _id, uint numberOfDays) public returns(uint) {
			Loan loan = loans[_id];
			return loan.balance * (loan.interestRate / 365) * numberOfDays;
	}

	function payLoan(uint _id) public payable isBorrower(_id) {

			Loan loan = loans[_id];
      if (token.transferFrom(msg.sender, loan.lender, loan.amount) != true)
      {
          throw;
      }

      uint difference = (block.timestamp - loan.issuedAt) / 1 days;
      uint interestAccrued = calculateInterest(_id, difference);
      loan.balance -= loan.amount - interestAccrued;
      if (loan.balance <= 0) {
          loan.status = Status.Finished;
      }
	}

  function forgiveLoan(uint _id) isLender(_id) {
     	loans[_id].status = Status.Finished;
  }
}
