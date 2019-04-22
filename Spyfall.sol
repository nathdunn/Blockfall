pragma solidity ^0.4.25; //we can change this

contract Spyfall {
    // Data Types

    // Remember: simple variables can be viewed with a CALL without having to define a getter function
    string[] public players;
    boolean questionSent;
    string public questioner;
    string private spy;
    string private location;
    string[] public locations = {'Autoshop', 'Gas Station', 'Police Station', 'Fire Station', 'Film Studio', 'Beach'}
   
    mapping (string => address)Trojans;
    
    constructor()public{
    
    
    }

    function compareStrings (string a, string b) view returns (bool){
        return keccak256(a) == keccak256(b);
    }

    function listPlayers() public view returns(string) {
        serialize="";
        for(uint i=0; i<memberCount; i++) {
            if (i>0){
                serialize = string(abi.encodePacked(serialize, ", ")); //the idea for abi.encodedPacked comes from
                //https://ethereum.stackexchange.com/questions/729/how-to-concatenate-strings-in-solidity
            }
                serialize = string(abi.encodePacked(serialize, players[i]));    
        }
        return serialize;
    }
    
    
     // Register a new Trojan account
    function registerTrojan(string name) public {
        // throw exception if user name is null or already registered
        require( !compareStrings(name, "") && Trojans[name] == address(0) && memberCount<=10 );
        players.push(name);
        memberCount ++;
        Trojans[name] = msg.sender;
    }

    // Delete a user account
    function unregisterTrojan(string name) public {
        uint index=0;
        // ensure that the account exists and belongs to the sender
        require( Trojans[name] != address(0) && Trojans[name] == msg.sender );
        for (uint i=0; i<players.length;i++){
            if(compareStrings(players[i], name)==true){
                index = i;
            }
        }
        Trojans[name] = address(0);    
        if (index >= players.length) return;

        for (uint j = index; j<players.length-1; j++){
            players[j] = players[j+1];
        }
        delete players[players.length-1];
        players.length--;
        memberCount --;
// a lot of the modified code in this function comes from the following link
//https://ethereum.stackexchange.com/questions/1527/how-to-delete-an-element-at-a-certain-index-in-an-array
    }

    function random(uint256 numPeopleOrLocations) private view returns (uint8) {
        return uint8(uint256(keccak256(block.timestamp, block.difficulty))%numPeopleOrLocations);
    }


    function nameSpy(string[] players) private{
        //pickspy
        spy = player[random(players.length-1)];
    }
    
    function nameQuestioner(string[] players) public{
        //pick questioner
        questioner = player[random(players.length-1)];
    }
    
    function pickLocation(string[] locations) public{
        //pick location
        location = locations[random(locations.length -1)];
    
    }
    
    function sendQuestion(recipient, question){
        require(msg.sender ==questioner & questionSent ==false);
        questionSent = True
        //say question
        //switch who can ask the next question
        questioner = recipient;
        
    }
    
    function answerQuestion(recipient, answer){
        require(msg.sender == questioner & questionSent == True);
        questionSent = False
        //answer question
        //send answer
    }

    
    function putForthGuessOfWhoSpyIs(string guess){
        //if(compareStrings(guess, spy)){
            //end game; non-spies win
        //}
    }

    function putForthGuessOfWhatPlaceIs(string guess) //requirement - must be spy{
        //if(compareStrings(guess, location)){
              //end game
              //spy wins
        //}
    }
    
    

}
