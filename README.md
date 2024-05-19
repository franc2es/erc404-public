# ERC404-Movie

项目基于 `Scaffold-ETH 2` 初始化，我们借鉴了 [`ERC404`](https://github.com/Pandora-Labs-Org/erc404) 及参考了 [`ERC404-Pro`](https://github.com/HelloRWA/ERC404Pro) 的一些逻辑设计思路，打造了我们的基于 ERC404 的电影票售卖、权益分发平台。

## 项目视频介绍

* [项目功能介绍](./project-intro.mp4)
* [智能合约代码介绍](./contract-intro.mp4)

## 项目使用

```sh
yarn chain
yarn deploy
yarn deploy --network scrollSepolia
yarn start
```

## 项目功能

* 可以通过 `launch` 接口发起项目
* 每张电影票就是一个 SBT，只可以付费购买，不能转移，用户可以一次性使用, 则该 SBT 状态变成 `USED`
* 每个电影可以发行 10K 的 NFT，持有 NFT 钱包地址有电影票 SBT 的售卖分红权
* NFT 可以用来和智能合约接口 `swapToFT` 来兑换为 10k 的 ERC20 的 FT
* 同理，集齐 10k 的 ERC20 FT 可以通过接口 `swapToNFT` 兑换为 NFT


## 接口列表

* `launch` 发起新项目
* `buySBT` 购买某个项目的 SBT, 用户支付 eth，并存入项目的国库
* `sbtStatus` 检查某个 SBT 状态：NONE, PAID, USED
* `useSBT` 使用这个 SBT
* `buyFT` 购买某个项目的 FT，需支付费用 `token.ftPrice * amount`
* `buyNFT` 购买某个项目的 NFT，需支付费用 `token.ftSwapAmount * ftPrice`
* `swapToFT` 把某个持有的 NFT 兑换成 FT
* `swapToNFT` 销毁 `token.ftSwapAmount` 个 FT，兑换为一个没有持有人的 NFT
* [TBD] `distributeSBTIncome` 项目所有人分配 SBT 收入
* [TBD] `claimSBTIncome`  NFT 持有者 claim SBT 收入
* [TBD] `withdrawTokenValut` 项目所有人提取项目 NFT 和 FT 的销售收入

# 🏗 Scaffold-ETH 2

<h4 align="center">
  <a href="https://docs.scaffoldeth.io">Documentation</a> |
  <a href="https://scaffoldeth.io">Website</a>
</h4>

🧪 An open-source, up-to-date toolkit for building decentralized applications (dapps) on the Ethereum blockchain. It's designed to make it easier for developers to create and deploy smart contracts and build user interfaces that interact with those contracts.

⚙️ Built using NextJS, RainbowKit, Hardhat, Wagmi, Viem, and Typescript.

- ✅ **Contract Hot Reload**: Your frontend auto-adapts to your smart contract as you edit it.
- 🪝 **[Custom hooks](https://docs.scaffoldeth.io/hooks/)**: Collection of React hooks wrapper around [wagmi](https://wagmi.sh/) to simplify interactions with smart contracts with typescript autocompletion.
- 🧱 [**Components**](https://docs.scaffoldeth.io/components/): Collection of common web3 components to quickly build your frontend.
- 🔥 **Burner Wallet & Local Faucet**: Quickly test your application with a burner wallet and local faucet.
- 🔐 **Integration with Wallet Providers**: Connect to different wallet providers and interact with the Ethereum network.

![Debug Contracts tab](https://github.com/scaffold-eth/scaffold-eth-2/assets/55535804/b237af0c-5027-4849-a5c1-2e31495cccb1)

## Requirements

Before you begin, you need to install the following tools:

- [Node (>= v18.17)](https://nodejs.org/en/download/)
- Yarn ([v1](https://classic.yarnpkg.com/en/docs/install/) or [v2+](https://yarnpkg.com/getting-started/install))
- [Git](https://git-scm.com/downloads)

## Quickstart

To get started with Scaffold-ETH 2, follow the steps below:

1. Install dependencies if it was skipped in CLI:

```
cd my-dapp-example
yarn install
```

2. Run a local network in the first terminal:

```
yarn chain
```

This command starts a local Ethereum network using Hardhat. The network runs on your local machine and can be used for testing and development. You can customize the network configuration in `packages/hardhat/hardhat.config.ts`.

3. On a second terminal, deploy the test contract:

```
yarn deploy
```

This command deploys a test smart contract to the local network. The contract is located in `packages/hardhat/contracts` and can be modified to suit your needs. The `yarn deploy` command uses the deploy script located in `packages/hardhat/deploy` to deploy the contract to the network. You can also customize the deploy script.

4. On a third terminal, start your NextJS app:

```
yarn start
```

Visit your app on: `http://localhost:3000`. You can interact with your smart contract using the `Debug Contracts` page. You can tweak the app config in `packages/nextjs/scaffold.config.ts`.

Run smart contract test with `yarn hardhat:test`

- Edit your smart contract `YourContract.sol` in `packages/hardhat/contracts`
- Edit your frontend homepage at `packages/nextjs/app/page.tsx`. For guidance on [routing](https://nextjs.org/docs/app/building-your-application/routing/defining-routes) and configuring [pages/layouts](https://nextjs.org/docs/app/building-your-application/routing/pages-and-layouts) checkout the Next.js documentation.
- Edit your deployment scripts in `packages/hardhat/deploy`

## Documentation

Visit our [docs](https://docs.scaffoldeth.io) to learn how to start building with Scaffold-ETH 2.

To know more about its features, check out our [website](https://scaffoldeth.io).

## Contributing to Scaffold-ETH 2

We welcome contributions to Scaffold-ETH 2!

Please see [CONTRIBUTING.MD](https://github.com/scaffold-eth/scaffold-eth-2/blob/main/CONTRIBUTING.md) for more information and guidelines for contributing to Scaffold-ETH 2.
