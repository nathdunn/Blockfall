pragma solidity ^0.4.25; //we can change this

contract Spyfall {
    // Data Types

    // Remember: simple variables can be viewed with a CALL without having to define a getter function
    string[] public players;
    bool questionSent;
    uint gameState = 0; //game state 0 means the game has not started
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
    
    
    // Register a new Player account
    function registerPlayer(string name) public {
        // throw exception if user name is null or already registered
        require( !compareStrings(name, "") && Trojans[name] == address(0) && players.length<=10 );
        players.push(name);
        Trojans[name] = msg.sender;
    }

    // Delete a user account
    function unregisterPlayer(string name) public {
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

    function startGame(string name) public{
        require(gameState == 0 && Trojans[name] == msg.sender && players.length>=3);
        // nameSpy();
        // nameQuestioner();
        // pickLocation();
        gameState = 1; //game state 1 means the game has started
        
        
    }

    function nameSpy() public view returns(string){
        //pickspy
        spy = players[players.length-1 - random(players.length-1)];
        return spy;
    }
    
    function nameQuestioner() public view returns(string){
        //pick questioner
        questioner = players[random(players.length-1)];
        return questioner;
    }
    
    function pickLocation() public view returns(string){
        //pick location
        location = locations[random(locations.length -1)];
        return location;
    }
    
    function sendQuestion(string sender, string recipient, string question){
        require(compareStrings(sender, questioner) && Trojans[sender] == msg.sender && questionSent ==false && gameState == 1);
        questionSent = true;
        //say question
        //switch who can ask the next question
        questioner = recipient;
        
    }
    
    function answerQuestion(string name, string recipient, string answer){
        require(compareStrings(name,questioner) && Trojans[name] == msg.sender && questionSent == true && gameState ==1);
        questionSent = false;
        //answer question
        //send answer
    }

    
    function putForthGuessOfWhoSpyIs(string guess){
        if(compareStrings(guess, spy)){
            //non-spies win
            gameState ==2;
        }
    }

    function putForthGuessOfWhatPlaceIs(string guess){
        if(compareStrings(guess, location)){
            gameState ==2;
            //spy wins
        }
    }
}
