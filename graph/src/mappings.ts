import { BigInt, Bytes } from "@graphprotocol/graph-ts";
import {
  TokenLaunched,
  SBTBought,
  SBTUsed,
  NFTBought,
  NFTTransferred,
  ERC404_Movie
} from "../generated/ERC404_Movie/ERC404_Movie";
import { Token, SBTStatus, NFT } from "../generated/schema";

export function handleTokenLaunched(event: TokenLaunched): void {
  let token = new Token(event.params.tokenId.toString());
  token.name = event.params.name;
  token.sbtPrice = event.params.sbtPrice;
  token.ftPrice = event.params.ftPrice;
  token.ftSwapAmount = event.params.ftSwapAmount;
  token.owner = event.params.owner;
  token.ftAmount = BigInt.fromI32(0);
  token.nftAmount = BigInt.fromI32(0);
  token.save();
}

export function handleSBTBought(event: SBTBought): void {
  let id = event.params.tokenId.toString() + "-" + event.params.buyer.toHexString();
  let sbtStatus = new SBTStatus(id);
  sbtStatus.token = event.params.tokenId.toString();
  sbtStatus.user = event.params.buyer;
  sbtStatus.status = 1; // PAID
  sbtStatus.save();
}

export function handleSBTUsed(event: SBTUsed): void {
  let id = event.params.tokenId.toString() + "-" + event.params.user.toHexString();
  let sbtStatus = SBTStatus.load(id);
  if (sbtStatus) {
    sbtStatus.status = 2; // USED
    sbtStatus.save();
  }
}

export function handleNFTBought(event: NFTBought): void {
  let nftId = event.params.tokenId.toString() + "-" + event.params.subTokenId.toString();
  let nft = new NFT(nftId);
  nft.token = event.params.tokenId.toString();
  nft.owner = event.params.buyer;
  nft.save();

  // 更新token的 nftAmount
  let token = Token.load(event.params.tokenId.toString());
  if (token) {
    token.nftAmount = token.nftAmount.plus(BigInt.fromI32(1));
    token.save();
  }
}

export function handleNFTTransferred(event: NFTTransferred): void {
  let nftId = event.params.tokenId.toString() + "-" + event.params.subTokenId.toString();
  let nft = NFT.load(nftId);
  if (nft) {
    nft.owner = event.params.to;
    nft.save();
  }
}
