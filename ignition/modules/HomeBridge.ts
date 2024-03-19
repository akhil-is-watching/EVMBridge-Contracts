import { buildModule } from "@nomicfoundation/hardhat-ignition/modules";
import { ethers } from "hardhat";



const HomeBridge = buildModule("HomeBridge", (m) => {

  const usdt = m.contract("TetherUSD", ["0x48d321d15E846cA351aCDFa7445aA57Bfe59b398"])

  const homeBridge = m.contract("HomeBridge", [
    "0x48d321d15E846cA351aCDFa7445aA57Bfe59b398",
    usdt,
    2
  ]);

  return { usdt, homeBridge };
});

export default HomeBridge;
