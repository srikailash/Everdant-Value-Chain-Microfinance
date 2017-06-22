const BaseToken = artifacts.require("BaseToken");

contract('BaseToken', (accounts) => {

  let token = {}

  beforeEach(async () => {
    token = await BaseToken.new(10000 , 'BaseToken', 3, 'sx');
  })

  it('Name Verification', async () => {
      let name = await token.name.call();
      assert.equal(name, 'BaseToken');
  });

  it('transfer Verification', async () => {
      await token.transfer(accounts[1], 100, { from: accounts[0] });
      let balance = await token.balanceOf.call(accounts[1]);
      assert.equal(balance, 100);
  });

});
