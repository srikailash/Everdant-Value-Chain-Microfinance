import "../../token/Base.sol";
import "./BaseTerm.sol";

pragma solidity ^0.4.8;
//First Loss Guarantee
contract FirstLossGuarantee is BaseTerm {

  enum Status {
    Pending,
    Approved,
    Finished
  }

  Status public status = Status.Pending;
	address public guarantor;
  address public parentContract;
  uint public guaranteeRate;
  uint public frozenAmount;
  uint public guaranteeAmount;
  BaseToken token;

	function FirstLossGuarantee(
      address _guarantor,
      uint _principal,
      uint _guaranteeRate,
      address _tokenAddress

  ) {
  		guarantor = _guarantor;
      parentContract = msg.sender;
      guaranteeRate = _guaranteeRate;
      token = BaseToken(_tokenAddress);
      uint amount = (_principal / 100) * guaranteeRate;
      guaranteeAmount = amount;
	}

  modifier isParentContract {
    if (msg.sender == parentContract)
    _;
  }

  modifier atStatus(Status _status) {
    require(status == status);
    _;
  }

  function approve() isParentContract atStatus(Status.Pending)
      returns (bool success) {
      freezeAmount(guaranteeAmount);
      status = Status.Approved;
      return true;
  }

  function onContractSuccess() isParentContract atStatus(Status.Approved) {
      endGuarantee();
      status = Status.Finished;
  }

  function onContractFailure(address toPay) isParentContract atStatus(Status.Approved) {
      token.transfer(toPay, frozenAmount);
      status = Status.Finished;
  }

  function endGuarantee() isParentContract atStatus(Status.Approved)
      returns (bool _success) {
      unFreezeAmount();
      status = Status.Finished;
      return true;
  }

  function freezeAmount(uint amount) isParentContract atStatus(Status.Approved)
      returns (bool success) {
      if (token.transferFrom(guarantor, address(this), amount) != true)
      {
          throw;
      }
      frozenAmount = amount;
      return true;
  }

  function unFreezeAmount() isParentContract atStatus(Status.Approved)
      returns (bool success) {
      token.transfer(guarantor, frozenAmount);
      frozenAmount = 0;
      return true;
  }

  function() payable { }

}
