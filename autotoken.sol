pragma ton-solidity >= 0.35.0;
pragma AbiHeader expire;

/// @title Simple wallet
/// @author Tonlabs
contract autotoken {
    /*
     Exception codes:
      100 - message sender is not a wallet owner.
      101 - invalid transfer value.
     */

	 struct Token{
		string name;
		int speed;
		string color;
		int price;
	 }
	 
	 Token[] tokensArr;
	 mapping (uint => uint) tokenToOwner;
	 
    constructor() public {
        require(tvm.pubkey() != 0, 101);
        require(msg.pubkey() == tvm.pubkey(), 102);
        tvm.accept();
    }

    modifier checkOwnerAndAccept {
        require(msg.pubkey() == tvm.pubkey(), 100);
		tvm.accept();
		_;
	}
	
	function createToken(string name, int speed, string color) public checkOwnerAndAccept returns(string) {
		uint estli=0;
		for (uint i=0; i<tokensArr.length; i++){
			if(tokensArr[i].name==name){estli=1;}
		}
		if(estli==0){
			tokensArr.push(Token(name, speed, color, 0));
			tokenToOwner[tokensArr.length-1]=msg.pubkey();
			return "Create token:" + name;
		}else{
			return "NO Create token:" + name;
		}
	}
	
	function pricesaleToken(uint tokenid, int price) public checkOwnerAndAccept returns(string) {
		if(tokenToOwner[tokenid]==msg.pubkey()){
			tokensArr[tokenid].price=price;
			return "Price install";
		}else{
			return "Price NO install";
		}
	}
	
	function getinfoToken(uint tokenid) public checkOwnerAndAccept returns(string tokenname,  int tokenspeed, string tokencolor,  int tokenprice) {
		tokenname=tokensArr[tokenid].name;
		tokenspeed=tokensArr[tokenid].speed;
		tokencolor=tokensArr[tokenid].color;
		tokenprice=tokensArr[tokenid].price;
	}


}