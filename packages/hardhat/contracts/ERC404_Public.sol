// SPDX-License-Identifier: MIT
// Compatible with OpenZeppelin Contracts ^5.0.0
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Pausable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract ERC404_Public is ERC721, ERC721Pausable, Ownable {
	constructor(
		address initialOwner
	) ERC721("ERC404_Public", "ERC404_Public") Ownable() {}

	function pause() public onlyOwner {
		_pause();
	}

	function unpause() public onlyOwner {
		_unpause();
	}

	// The following functions are overrides required by Solidity.

	function _beforeTokenTransfer(
		address from,
		address to,
		uint256 firstTokenId,
		uint256 batchSize
	) internal virtual override(ERC721, ERC721Pausable) {
		super._beforeTokenTransfer(from, to, firstTokenId, batchSize);
	}
}
