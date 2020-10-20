pragma solidity ^0.5.0;

import "./library/SafeMath.sol";
import "./interface/IERC20.sol";

contract TFTTokenWrapper {
    using SafeMath for uint256;
    IERC20 public tft;

    constructor(IERC20 _tftAddress) public {
        tft = IERC20(_tftAddress);
    }

    uint256 private _totalSupply;
    mapping(address => uint256) private _balances;

    function totalSupply() public view returns (uint256) {
        return _totalSupply;
    }

    function balanceOf(address account) public view returns (uint256) {
        return _balances[account];
    }

    function stake(uint256 amount) public {
        _totalSupply = _totalSupply.add(amount);
        _balances[msg.sender] = _balances[msg.sender].add(amount);
        tft.transferFrom(msg.sender, address(this), amount);
    }

    function withdraw(uint256 amount) public {
        _totalSupply = _totalSupply.sub(amount);
        _balances[msg.sender] = _balances[msg.sender].sub(amount);
        tft.transfer(msg.sender, amount);
    }
}
