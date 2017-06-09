import "../token/Base.sol";
pragma solidity ^0.4.11;
contract prePurchase{
    
    mapping (bytes32  => bytes32[]) public suppliersOf;
    mapping (address => bool ) addressSupplier;
    
    
    address tokenAddress;
    address purchaser;
    address supplier;
    BaseToken token;
    uint quantity;
    string cat;
    
    bytes32[] suppliers;
        
      struct order{
        address purchaser;
        address supplier;
        uint quantity;
        string category;
        uint firstInstallment;
        uint totalCharge;
        //add required date here
        //quality specs
    }
    
    modifier isSupplier(address supplier){
        if(addressSupplier[supplier]!= true)
            _;
    }
    
    function stringToBytes32(string memory source) returns (bytes32 result) {
        assembly {
            result := mload(add(source, 32))
        }
    }
    
    
    function prePurchase(address tokenAddress , uint _quant , string _cat)
    {
            //token = BaseToken(1000 , 'test' , 4 , 'test');
            token = BaseToken(tokenAddress);
            purchaser = msg.sender;
            cat = _cat;
            quantity = _quant;
            //dummy data
            //adding data for test
            bytes32 temp = stringToBytes32("1");
            suppliers.push(temp);
            temp = stringToBytes32("2");
            suppliers.push(temp);
            temp = stringToBytes32("3");
            suppliers.push(temp);
            temp = stringToBytes32("4");
            suppliers.push(temp);
            temp = stringToBytes32("5");
            suppliers.push(temp);
            temp = stringToBytes32("6");
            suppliers.push(temp);
            temp = stringToBytes32("7");
            suppliers.push(temp);
            temp = stringToBytes32("8");
            suppliers.push(temp);
            suppliersOf[stringToBytes32("cat1")] = suppliers;   
            //need a global table(mapping) for suppliersof each category            
            
    }
    
    //returns according to requirement in html page
    function getSuppliers(string category) returns(bytes32[] supp){
        return suppliersOf[stringToBytes32(category)];
    }
    

    //called on click in webpage
    function chooseSupplier(address _supplier){
        //price and terms are discussed
        //negotiations
        supplier = _supplier;
    }
    
    function negotiate(address supplier) internal  returns(order finalised){
        order storage or;
        //negotiations here
        finalised = or;
    }
    
    //called from webpage
    function acceptOrder(order ord) isSupplier(ord.supplier) internal returns(bool success) 
    {
        return true;
    }
        
    
    
    function placeOrder(order  ord , address supplier) internal{
        // sendOrder(negotiate(supplier) , supplier);
        // uint intialPayment;
        if(acceptOrder(ord) == true)
            token.transferFrom(ord.purchaser , ord.supplier ,  ord.firstInstallment);
    }

    
}


