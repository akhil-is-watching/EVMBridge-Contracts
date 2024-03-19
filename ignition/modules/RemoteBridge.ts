import { buildModule } from "@nomicfoundation/hardhat-ignition/modules";



const RemoteBridge = buildModule("RemoteBridge", (m) => {

  const usdt = m.contract("TetherUSD", ["0x48d321d15E846cA351aCDFa7445aA57Bfe59b398"])

  const remoteBridge = m.contract("RemoteBridge", [
    "0x48d321d15E846cA351aCDFa7445aA57Bfe59b398",
    usdt,
    2
  ]);

  return { usdt, remoteBridge };
});

export default RemoteBridge;
