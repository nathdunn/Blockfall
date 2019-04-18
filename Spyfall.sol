pragma solidity ^0.4.25; //we can change this

contract Spyfall {
    // Data Types

    // Remember: simple variables can be viewed with a CALL without having to define a getter function
    string[] public players;
    string public questioner;
    string private spy;
    string private location;
    string[] public locations = {'Autoshop', 'Gas Station', 'Police Station', 'Fire Station', 'Film Studio', 'Beach'}
    
    function nameSpy(string[] players) private{
           //pickspy
           spy = player[i]
    }
    
    function nameQuestioner(string[] players) public{
           //pick questioner
           questioner = player[i]
    }
    
    function pickLocation(string[] locations) public{
    
    
    }
    
    function sendQuestion(sender, recipient){
        //is sender=recipient?
            //if so, accept question
        //set receiver as new recipient
    }
    
    function answerQuestion(recipient){
        //answer question
    
    }

    
    function putForthGuessOfWhoSpyIs(){
    
    }

    function putForthGuessOfWhatPlaceIs() //requirement - must be spy{
    
    }

}
