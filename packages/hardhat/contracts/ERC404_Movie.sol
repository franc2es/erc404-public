// SPDX-License-Identifier: MIT
// Compatible with OpenZeppelin Contracts ^5.0.0
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/token/ERC1155/extensions/ERC1155Pausable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

import "hardhat/console.sol";

contract ERC404_Movie is ERC1155Pausable, Ownable {
	uint256 private _nextTokenId;
	struct Token {
		string name;
		uint256 sbtPrice;
		uint256 ftPrice;
		uint256 ftSwapAmount;
	}

	mapping(uint256 => Token) _tokenMap;

	enum SBTStatus {
		NONE,
		PAID,
		USED
	}
	mapping(uint256 => mapping(address => SBTStatus)) _sbtStatusMap;

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

	function launch(
		string memory name_,
		uint256 sbtPrice_,
		uint256 ftPrice_,
		uint256 ftSwapAmount_
	) public returns (uint256) {
		// TODO: use pay token to launch new token?
		uint256 tokenId = _nextTokenId++;
		_tokenMap[tokenId] = Token(name_, sbtPrice_, ftPrice_, ftSwapAmount_);

		return tokenId;
	}

	receive() external payable {}

	function buySBT(uint256 tokenId_) public payable {
		require(tokenId_ < _nextTokenId, "tokenId not exist");

		Token memory token = _tokenMap[tokenId_];
		require(msg.value >= token.sbtPrice, "payment not enough");
		require(
			_sbtStatusMap[tokenId_][msg.sender] == SBTStatus.NONE,
			"You have buy the SBT"
		);
		_sbtStatusMap[tokenId_][msg.sender] = SBTStatus.PAID;
	}

	function sbtStatus(
		uint256 tokenId_,
		address user
	) public view returns (SBTStatus) {
		return _sbtStatusMap[tokenId_][user];
	}

	function useSBT(uint256 tokenId_) public {
		require(
			_sbtStatusMap[tokenId_][msg.sender] == SBTStatus.PAID,
			"Your SBT is not in PAID status"
		);
		_sbtStatusMap[tokenId_][msg.sender] = SBTStatus.USED;
	}
}
