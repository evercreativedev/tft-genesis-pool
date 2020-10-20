pragma solidity ^0.5.0;

import "./interface/IERC20.sol";
import "./TFTTokenWrapper.sol";
import "./ERC1155Tradable.sol";
import "./Ownable.sol";

contract GenesisPool is TFTTokenWrapper, Ownable {
    ERC1155Tradable public tfts;

    mapping(address => uint256) public lastUpdateTime;
    mapping(address => uint256) public points;
    mapping(uint256 => uint256) public cards;

    event CardAdded(uint256 card, uint256 points);
    event Staked(address indexed user, uint256 amount);
    event Withdrawn(address indexed user, uint256 amount);
    event Redeemed(address indexed user, uint256 amount);

    modifier updateReward(address account) {
        if (account != address(0)) {
            points[account] = earned(account);
            lastUpdateTime[account] = block.timestamp;
        }
        _;
    }

    constructor(ERC1155Tradable _tftsAddress, IERC20 _tftAddress)
        public
        TFTTokenWrapper(_tftAddress)
    {
        tfts = _tftsAddress;
    }

    function addCard(uint256 cardId, uint256 amount) public onlyOwner {
        cards[cardId] = amount;
        emit CardAdded(cardId, amount);
    }

    function earned(address account) public view returns (uint256) {
        uint256 blockTime = block.timestamp;
        return
            points[account].add(
                blockTime.sub(lastUpdateTime[account]).mul(1e18).div(86400).mul(
                    balanceOf(account).div(1e8)
                )
            );
    }

    // stake visibility is public as overriding TFTTokenWrapper's stake() function
    function stake(uint256 amount) public updateReward(msg.sender) {
        require(
            amount.add(balanceOf(msg.sender)) <= 1000000000,
            "Cannot stake more than 10 TFT"
        );

        super.stake(amount);
        emit Staked(msg.sender, amount);
    }

    function withdraw(uint256 amount) public updateReward(msg.sender) {
        require(amount > 0, "Cannot withdraw 0");

        super.withdraw(amount);
        emit Withdrawn(msg.sender, amount);
    }

    function exit() external {
        withdraw(balanceOf(msg.sender));
    }

    function redeem(uint256 card) public updateReward(msg.sender) {
        require(cards[card] != 0, "Card not found");
        require(
            points[msg.sender] >= cards[card],
            "Not enough points to redeem for card"
        );
        require(
            tfts.totalSupply(card) < tfts.maxSupply(card),
            "Max cards minted"
        );

        points[msg.sender] = points[msg.sender].sub(cards[card]);
        tfts.mint(msg.sender, card, 1, "");
        emit Redeemed(msg.sender, cards[card]);
    }
}
