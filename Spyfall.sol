pragma solidity ^0.4.25; //we can change this
contract Spyfall {
    // Data Types
    // Remember: simple variables can be viewed with a CALL without having to define a getter function
    string[] private players;
    bool questionSent;
    bool answerSent;
    uint gameState = 0; //game state 0 means the game has not started
    string public questioner;
    string serialize = "";
    string private spy;
    uint256 private game_start;
    uint256 private game_end;
    string private location;
    string private question;
    string private answer;
    string public winners;
    string[] private locations = ['Autoshop', 'Gas Station', 'Police Station', 'Fire Station', 'Film Studio', 'Beach'];

    mapping (string => address)Trojans;
    mapping (string => uint)Votes;
    mapping (address => bool)addresses;

    constructor()public{

    }

    modifier an_ongoing_game(){
        require(now <= game_end, "The game is over!");
        require(gameState == 1, "The game is over!");
        _;
    }

    function numVotes(string name) public view returns(uint) {
        return Votes[name];
    }

    function compareStrings (string a, string b) private view returns (bool){
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

    function listLocations() public view returns(string){
        serialize="";
        for(uint i=0; i<locations.length; i++) {
            if (i>0){
                serialize = string(abi.encodePacked(serialize, ", ")); //the idea for abi.encodedPacked comes from
                //https://ethereum.stackexchange.com/questions/729/how-to-concatenate-strings-in-solidity
            }
            serialize = string(abi.encodePacked(serialize, locations[i]));
        }
        return serialize;
    }

    // Register a new Player account
    function registerPlayer(string name) public {
        // throw exception if user name is null or already registered
        require(now>game_end, "The game has already started.");
        require(!compareStrings(name, ""), "Please enter your name.");
        require(Trojans[name] == address(0), "There is a duplicate name.");
        require(addresses[msg.sender] != true, "You have already registered");
        require(players.length<=10, "There cannot be more than 10 players, take turns and play multiple rounds :)" );
        players.push(name);
        Trojans[name] = msg.sender;
        addresses[msg.sender] = true;
    }
    // Delete a user account
    function unregisterPlayer(string name) public an_ongoing_game(){
        uint index=0;
        // ensure that the account exists and belongs to the sender
        require(Trojans[name] != address(0), "You are not registered to begin with!");
        require(Trojans[name] == msg.sender);
        for (uint i=0; i<players.length;i++){
            if(compareStrings(players[i], name)==true){
                index = i;
            }
        }
        Trojans[name] = address(0);
        addresses[msg.sender] = false;
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

    function startGame(string name) public returns(string){
        require(gameState == 0, "The game has already started");
        require(Trojans[name] == msg.sender && players.length>=3, "You must have 3 registered players before starting the game, get some friends!");
        game_start = now;
        game_end = now + 15 minutes;
        spy = players[players.length-1 - random(players.length-1)];
        questioner = players[random(players.length-1)];
        location = locations[random(locations.length-1)];
        gameState = 1; //game state 1 means the game has started
        return questioner;

    }

    function sendQuestion(string sender, string recipient, string quest) public an_ongoing_game(){
        require(compareStrings(sender, questioner), "You are not the questioner.");
        require(Trojans[sender] == msg.sender && questionSent ==false, "Nice try, the question has already been asked");
        require(gameState == 1, "The game is not active.");
        questionSent = true;
        //say question
        //switch who can ask the next question
        question = quest;
        questioner = recipient;
        answerSent = false;

    }

    function answerQuestion(string name, string answ) public  an_ongoing_game(){
        require(compareStrings(name, questioner), "You are not the recipient.");
        require(Trojans[name] == msg.sender && questionSent == true, "What are you trying to answer? The question has not been asked yet.");
        require(gameState ==1, "The game is not active.");
        questionSent = false;
        answer = answ;
        answerSent = true;

        //send answer
    }

    function guessLocation(string guess) public view an_ongoing_game() returns(string){
        if(compareStrings(guess, location)){
            game_end = now;
            gameState = 2;
            winners = "spy";
            return("The spy has won!!");
        }
        else{
            game_end = now;
            gameState = 2;
            winners = "non-spies";
            return("The non-spies have won!!");
        }
    }

    function whatAmI(string name) public view an_ongoing_game() returns(string){
        require(Trojans[name] == msg.sender);
        if(compareStrings(spy, name)){
            return ("You are the spy! Shhh");
        }
        else{
            return ("You are not the spy. Check the location.");
        }
    }

    function checkLocation(string name) public view an_ongoing_game() returns(string){
        require(Trojans[name] == msg.sender);
        if(compareStrings(spy, name)){
            return ("You don't get to know the location! You're the spy!");
        }
        else
            return location;
    }

    function vote(string name) public returns (string){
        Votes[name] = Votes[name] + 1;
        if(Votes[name] == players.length-1 && compareStrings(name, spy)){
            game_end = now;
            gameState = 2;
            winners = "non-spies";
            return("The non-spies have won!!");
        }
        else{
            return("Your vote has been cast.");
        }
    }

    function viewQuestion() public view an_ongoing_game() returns(string){
        if(questionSent){
            return question;
        }
        else{
            return ("The question has not been asked yet");
        }
    }

    function viewAnswer() public view an_ongoing_game() returns(string){
        if(answerSent){
            return answer;
        }
        else{
            return ("The question has not been answered yet");
        }
    }
}
