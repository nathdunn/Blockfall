pragma solidity ^0.4.25; //we can change this

contract Spyfall {
    // Data Types

    // Remember: simple variables can be viewed with a CALL without having to define a getter function
    string[] public players;
    bool questionSent;
    string public questioner;
    string serialize = "";
    string private spy;
    string private location;
    string[] public locations = ['Autoshop', 'Gas Station', 'Police Station', 'Fire Station', 'Film Studio', 'Beach'];
   
    mapping (string => address)Trojans;
    
    constructor()public{
    
    
    }

    function compareStrings (string a, string b) view returns (bool){
        return keccak256(a) == keccak256(b);
    }

    function listPlayers() public view returns(string) {
        serialize="";
        for(uint i=0; i<players.length; i++) {
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
        require( !compareStrings(name, "") && Trojans[name] == address(0) && players.length<=10 );
        players.push(name);
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
// a lot of the modified code in this function comes from the following link
//https://ethereum.stackexchange.com/questions/1527/how-to-delete-an-element-at-a-certain-index-in-an-array
    }

    function random(uint256 numPeopleOrLocations) private view returns (uint8) {
        return uint8(uint256(keccak256(block.timestamp, block.difficulty))%numPeopleOrLocations);
    }


    function nameSpy() private{
        //pickspy
        spy = players[random(players.length-1)];
    }
    
    function nameQuestioner() public{
        //pick questioner
        questioner = players[random(players.length-1)];
    }
    
    function pickLocation() public{
        //pick location
        location = locations[random(locations.length -1)];
    
    }
    
    function sendQuestion(string recipient, string question){
        require(compareStrings(msg.sender, questioner) && questionSent ==false);
        questionSent = true;
        //say question
        //switch who can ask the next question
        questioner = recipient;
        
    }
    
    function answerQuestion(string recipient, string answer){
        require(compareStrings(msg.sender,questioner) && questionSent == true);
        questionSent = false;
        //answer question
        //send answer
    }

    
    function putForthGuessOfWhoSpyIs(string guess){
        //if(compareStrings(guess, spy)){
            //end game; non-spies win
        //}
    }

    function putForthGuessOfWhatPlaceIs(string guess){
        //if(compareStrings(guess, location)){
              //end game
              //spy wins
        }
}
