var BaseToken = artifacts.require("BaseToken");
var SimpleLoan = artifacts.require("SimpleLoan");



contract('BaseToken', function(accounts) {
  it("Testing token transfer and Approve Loan", function() {
    
        return BaseToken.deployed().then(function(instance) 
        {
        //console.log(instance);
        var token = instance;
        var loan;        
        instance.balanceOf.call(accounts[0]).then(function(balance) {
          console.log(accounts[0]);
          console.log(balance.valueOf());
          console.log(instance.address);

        }).then(function() {

          return instance.transfer(accounts[1], 100, { from: accounts[0] });

        }).then(function(balance){

            return instance.balanceOf.call(accounts[1]);

        }).then(function(balance){

            assert.equal(balance.valueOf(), 100, "100 wasn't in the second account");
            return SimpleLoan.new(token.address, { from: accounts[0] });

        }).then(function(instance) {
          loan = instance;
          return instance.createLoan(accounts[0], accounts[1], 1000, 10);

        }).then(function(instance) {
          console.log(loan.address);
          return token.approveAndCall(loan.address, 1000, 0, { from: accounts[0] });

        }).then(function(instanced) {
          return token.balanceOf.call(accounts[1]);

        }).then(function(balance) {

          assert.equal(balance.valueOf(), 1100, "1100 wasn't in the second account");

        });
    });
  });
  

});