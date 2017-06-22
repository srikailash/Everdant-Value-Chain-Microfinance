import "./SimpleLoan.sol";
pragma solidity ^0.4.11;

contract RestrictedCashFlow is SimpleLoan {

    function RestrictedCashFlow(address _tokenAddress) SimpleLoan(_tokenAddress) {
    }

    function createLoan(address _lender, address _borrower, uint _amount, uint _interest, address[] _payees, uint[] _payeeAmounts) {
  			uint _id = loanNumber; // campaignID is return variable
  			Loan loan = loans[_id];
  			loan.lender = _lender;
  			loan.borrower = _borrower;
  			loan.amount = _amount;
  			loan.interest = _interest;
        uint totalAmount = 0;

        if (_payees.length != _payeeAmounts.length) throw;

        for (uint i = 0; i < _payees.length; i++) {
            Payee payee = loan.payees[i];
            payee.payee = _payees[i];
            payee.amount = _payeeAmounts[i];
            totalAmount += payee.amount;
        }

        if (totalAmount > loan.amount) throw;
  			loanNumber++;
  	}

    function receiveApproval(address _sender, uint256 _value, address _token, uint _id) {
  			Loan loan = loans[_id];
  			Approval(_sender, _value, _id);
  			if (_token != tokenAddress) throw;

  			if (_value == loan.amount && _sender == loan.lender) {

            uint totalAmount = 0;
            //Disemburse to all payees and remaining to the borrower
            //Need to add Rollback when transfer is unsuccessful
            for (uint i = 0; i < loan.payees.length; i++) {
                Payee payee = loan.payees[i];
                if (token.transferFrom(_sender, payee.payee, payee.amount) != true)
      					{
      							throw;
      					}
                totalAmount += payee.amount;

            }
            uint remainingAmount = loan.amount - totalAmount;
            if (remainingAmount > 0) {
                if (token.transferFrom(_sender, loan.borrower, remainingAmount) != true)
                {
                    throw;
                }
            }
  					loan.status = Status.Approved;
  					loan.issuedAt = block.timestamp;
  			}
  	}
}
