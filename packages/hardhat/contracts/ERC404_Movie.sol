// SPDX-License-Identifier: MIT
// Compatible with OpenZeppelin Contracts ^5.0.0
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/token/ERC1155/extensions/ERC1155Pausable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract ERC404_Movie is ERC1155Pausable, Ownable {
	constructor() ERC1155("https://erc404-movie.com/api/token/") Ownable() {}

	function updateMeta(string memory uri_) public onlyOwner {
		_setURI(uri_);
	}

	function pause() public onlyOwner {
		_pause();
	}

	function unpause() public onlyOwner {
		_unpause();
	}
}
