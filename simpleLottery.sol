pragma solidity ^0.4.19;

contract Ownable {
    address public owner;

    function Ownable() public {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }

    function transferOwnership(address newOwner) public onlyOwner {
        require(newOwner != address(0));
        owner = newOwner;
    }
}

contract Lottery is Ownable {
    address public drawer;
    uint public numbersCount;
    uint public gameIndexToBuy;
    uint public ticketCountMax;
    
    uint public numbersCountMax;
    struct Game{
        uint startTime;
        bytes winNumbers;
        Ticket[] tickets;
    }
    struct Ticket{
        address user;
        bytes numbers;
    }
    
    mapping(address => uint[2][]) playerTickets;
    function Lottery() public {
        
    }
    modifier onlyDrawer() {
        require(msg.sender == drawer);
        _;
    }
    function setDrawer(address _drawer) public onlyOwner{
        drawer = _drawer;
    }
    function buyTicket(uint[] numbers) public payable {
        require(numbers.length % numbersCount == 0);
        Game storage game = games[gameIndexToBuy];
        uint buyTicketCount = numbers.length / numbersCount;
        require(msg.value == game.price * buyTicketCount);
        require(game.tickets.length + buyTicketCount <= ticketCountMax);
        while (i < numbers.length) {

            bytes memory bet = new bytes(numbersCount);

            for (uint j = 0; j < numbersCount; j++) {
                bet[j] = byte(numbers[i++]);
            }

            require(noDuplicates(bet));

            playerTickets[msg.sender].push([gameIndexToBuy, game.tickets.length]);

            game.tickets.push(Ticket(msg.sender, bet));

        }
    }
}