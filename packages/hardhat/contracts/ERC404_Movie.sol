// SPDX-License-Identifier: MIT
// Compatible with OpenZeppelin Contracts ^5.0.0
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/token/ERC1155/extensions/ERC1155Pausable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

struct Token {
	string name;
	uint256 sbtPrice;
	uint256 ftPrice;
	uint256 ftSwapAmount;
	address owner;
}

enum SBTStatus {
	NONE,
	PAID,
	USED
}

contract ERC404_Movie is ERC1155Pausable, Ownable {
	uint256 private _nextTokenId = 1;

	mapping(uint256 => Token) _tokenMap;

	mapping(uint256 => mapping(address => SBTStatus)) _sbtStatusMap;

	mapping(uint256 => uint256) _tokenSBTVault;
	mapping(uint256 => uint256) _tokenVault;
	mapping(uint256 => uint256) _tokenFTAmount;
	mapping(uint256 => uint256) _tokenNFTAmount;
	mapping(uint256 => mapping(uint256 => address)) _tokenNFTOwnerMap;
	mapping(uint256 => mapping(address => uint256[])) _tokenNFTOwnedMap;

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
		_tokenMap[tokenId] = Token(
			name_,
			sbtPrice_,
			ftPrice_,
			ftSwapAmount_,
			msg.sender
		);

		return tokenId;
	}

	receive() external payable {}

	modifier tokenHasLaunched(uint256 tokenId_) {
		require(tokenId_ < _nextTokenId, "tokenId not exist");
		_;
	}

	function buySBT(
		uint256 tokenId_
	) public payable tokenHasLaunched(tokenId_) {
		Token memory token = _tokenMap[tokenId_];
		require(msg.value >= token.sbtPrice, "payment not enough");
		require(
			_sbtStatusMap[tokenId_][msg.sender] == SBTStatus.NONE,
			"You have buy the SBT"
		);
		_sbtStatusMap[tokenId_][msg.sender] = SBTStatus.PAID;
		_tokenSBTVault[tokenId_] += msg.value;
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

	function getCurrentSupply(uint256 tokenId_) public view returns (uint256) {
		return
			_tokenFTAmount[tokenId_] +
			_tokenNFTAmount[tokenId_] *
			_tokenMap[tokenId_].ftSwapAmount;
	}

	function _checkBeforeMint(
		uint256 tokenId_,
		uint256 userPayment_,
		uint256 ftAmount_,
		uint256 nftAmount_
	) internal view {
		Token memory token = _tokenMap[tokenId_];
		uint256 requiredPayment = token.ftPrice *
			ftAmount_ +
			token.ftSwapAmount *
			10000 *
			nftAmount_;
		require(userPayment_ >= requiredPayment, "payment not enough");

		uint256 maxSupplyAmount = token.ftSwapAmount * 10000;
		uint256 currentSupply = getCurrentSupply(tokenId_);
		uint256 newSupplyAmount = currentSupply +
			ftAmount_ +
			nftAmount_ *
			10000;
		require(newSupplyAmount <= maxSupplyAmount, "exceed max supply amount");
	}

	function buyFT(
		uint256 tokenId_,
		uint256 amount_
	) public payable tokenHasLaunched(tokenId_) {
		_checkBeforeMint(tokenId_, msg.value, amount_, 0);

		_mint(msg.sender, tokenId_, amount_, "");
		_tokenFTAmount[tokenId_] += amount_;
		_tokenVault[tokenId_] += msg.value;
	}

	function buyNFT(
		uint256 tokenId_,
		uint256 subTokenId_
	) public payable tokenHasLaunched(tokenId_) {
		require(
			_tokenNFTOwnerMap[tokenId_][subTokenId_] == address(0),
			"Token already have owner"
		);
		require(
			subTokenId_ > 0 && subTokenId_ <= 10000,
			"sub tokenId should between 1 and 10000"
		);
		_checkBeforeMint(tokenId_, msg.value, 0, 1);

		_tokenNFTOwnerMap[tokenId_][subTokenId_] = msg.sender;
		_tokenNFTOwnedMap[tokenId_][msg.sender].push(subTokenId_);
		_tokenNFTAmount[tokenId_] += 1;
		_tokenVault[tokenId_] += msg.value;
	}

	function swapToFT(uint256 tokenId_, uint256 subTokenId_) public {
		require(
			_tokenNFTOwnerMap[tokenId_][subTokenId_] == msg.sender,
			"You are not the owner"
		);

		uint256 amount = _tokenMap[tokenId_].ftSwapAmount;
		_mint(msg.sender, tokenId_, amount, "");
		_tokenFTAmount[tokenId_] += amount;
		_tokenNFTOwnerMap[tokenId_][subTokenId_] = address(0);
		_tokenNFTAmount[tokenId_] -= 1;

		// remove ownership from msg.sender
		uint256 len = _tokenNFTOwnedMap[tokenId_][msg.sender].length;
		for (uint256 i = 0; i < len; i++) {
			if (_tokenNFTOwnedMap[tokenId_][msg.sender][i] != subTokenId_) {
				continue;
			}
			if (i != len - 1) {
				_tokenNFTOwnedMap[tokenId_][msg.sender][i] = _tokenNFTOwnedMap[
					tokenId_
				][msg.sender][len - 1];
			}
			_tokenNFTOwnedMap[tokenId_][msg.sender].pop();
		}
	}

	function swapToNFT(uint256 tokenId_, uint256 subTokenId_) public {
		require(
			_tokenNFTOwnerMap[tokenId_][subTokenId_] == address(0),
			"Token already have owner"
		);
		require(
			balanceOf(msg.sender, tokenId_) >= _tokenMap[tokenId_].ftSwapAmount,
			"You do not have enough FT"
		);

		_burn(msg.sender, tokenId_, _tokenMap[tokenId_].ftSwapAmount);
		_tokenNFTOwnerMap[tokenId_][subTokenId_] = msg.sender;
		_tokenNFTOwnedMap[tokenId_][msg.sender].push(subTokenId_);
		_tokenNFTAmount[tokenId_] += 1;
	}

	function distributeSBTIncome(uint256 tokenId_) public view {
		require(_tokenSBTVault[tokenId_] > 0, "SBT Value is zero");
		require(
			_tokenMap[tokenId_].owner == msg.sender,
			"Your are not the token owner"
		);
		// TBD
	}

	function claimSBTIncome(uint256 tokenId_, uint256 seasonId_) public view {
		require(
			_tokenNFTOwnedMap[tokenId_][msg.sender].length > 0,
			"You do not have NFT"
		);
		// TBD
	}

	function withdrawTokenValut(uint256 tokenId_) public view {
		require(
			_tokenMap[tokenId_].owner == msg.sender,
			"Your are not the token owner"
		);
		// TBD
	}
}
