pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol";
import "@openzeppelin/contracts/token/ERC721/utils/ERC721Enumerable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract SwapPool is Ownable, ERC721Enumerable {
    IERC20 public erc20Token;
    IERC721 public erc721Token;
    uint256 public erc20PerErc721; // 每个 ERC721 兑换多少 ERC20
    uint256 public constant MAX_NFT_SUPPLY = 10;
    uint256 public constant NFT_SUPPLY_CAP = MAX_NFT_SUPPLY * 1000;
    uint256 public nftCount;

    // 事件
    event SwapToERC20(address indexed user, uint256 tokenId, uint256 amount);
    event SwapToERC721(address indexed user, uint256 tokenId, uint256 amount);
    event TokenPurchase(address indexed buyer, uint256 amountPaid);

    // 构造函数
    constructor(IERC20 _erc20Token, IERC721 _erc721Token, uint256 _erc20PerErc721) {
        erc20Token = _erc20Token;
        erc721Token = _erc721Token;
        erc20PerErc721 = _erc20PerErc721;
    }

    // 允许合约接收以太币
    receive() external payable {}

    // 购买合约代币
    function buyTokens(uint256 amount) external {
        // Transfer ERC20 tokens from user to contract
        require(erc20Token.transferFrom(msg.sender, address(this), amount), "Token purchase failed");

        // Emit event
        emit TokenPurchase(msg.sender, amount);
    }

    // 将 ERC721 代币交换为 ERC20 代币
    function swapToERC20(uint256 tokenId) external {
        // 将 ERC721 代币从用户转移到合约
        erc721Token.safeTransferFrom(msg.sender, address(this), tokenId);

        // 计算用户应得的 ERC20 代币数量
        uint256 erc20Amount = erc20PerErc721;

        // 将 ERC20 代币转移到用户
        require(erc20Token.transfer(msg.sender, erc20Amount), "ERC20 transfer failed");

        // 触发事件
        emit SwapToERC20(msg.sender, tokenId, erc20Amount);

        // Mint ERC721 token to user
        _mint(msg.sender, tokenId);

        // Increment NFT count
        nftCount++;

        // Require NFT supply not to exceed the cap
        require(nftCount <= MAX_NFT_SUPPLY, "Maximum NFT supply reached");
    }

    // 将 ERC20 代币交换为 ERC721 代币
    function swapToERC721(uint256 tokenId) external {
        // 计算需要的 ERC20 代币数量
        uint256 erc20Amount = erc20PerErc721;

        // 从用户转移 ERC20 代币到合约
        require(erc20Token.transferFrom(msg.sender, address(this), erc20Amount), "ERC20 transfer failed");

        // 将 ERC721 代币转移到用户
        erc721Token.safeTransferFrom(address(this), msg.sender, tokenId);

        // 触发事件
        emit SwapToERC721(msg.sender, tokenId, erc20Amount);

        // Burn ERC721 token
        _burn(tokenId);
        
        // Decrement NFT count
        nftCount--;
    }

    // 管理员可以设置每个 ERC721 对应的 ERC20 代币数量
    function setERC20PerERC721(uint256 _erc20PerErc721) external onlyOwner {
        erc20PerErc721 = _erc20PerErc721;
    }

    // Override _baseURI to return the base URI for NFT metadata
    function _baseURI() internal pure override returns (string memory) {
        return "https://example.com/token/";
    }
}
