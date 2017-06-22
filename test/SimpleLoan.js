const BaseToken = artifacts.require("BaseToken");
const SimpleLoan = artifacts.require("SimpleLoan");

contract('SimpleLoan', (accounts) => {

  let token = {}
  let loanContract = {}

  beforeEach(async () => {
    token = await BaseToken.new(10000 , 'BaseToken', 3, 'sx');
    loanContract = await SimpleLoan.new(token.address);
  })

  it('Create Loan and Transfer', async () => {
      let loan = await loanContract.createLoan(accounts[0], accounts[1], 1000, 10, { from: accounts[0] });
      await token.approveAndCall(loanContract.address, 1000, 0, { from: accounts[0] });
      let balance = await token.balanceOf.call(accounts[0]);
      assert.equal(balance.valueOf(), 9000);
  });

  it('Forgive Loan by Non Lender and Lender', async () => {
      let loan = await loanContract.createLoan(accounts[0], accounts[1], 1000, 10, { from: accounts[0] });

      try {
          await loanContract.forgiveLoan(0, { from: accounts[1] });
          assert(false, "Should throw Exception");
      }
      catch (error) {}

      try {
          await loanContract.forgiveLoan(0, { from: accounts[0] });
      }
      catch (error) {assert(false, "Not Lender");}
  });


});
