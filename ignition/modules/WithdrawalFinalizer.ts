import { buildModule } from "@nomicfoundation/hardhat-ignition/modules";

const WithdrawalFinalizerModule = buildModule("WithdrawalFinalizerModule", (m) => {
  const chainId = m.getParameter("chainId");
  const l1SharedBridge = m.getParameter("l1SharedBridge");

  const withdrawalFinalizer = m.contract("WithdrawalFinalizer", [chainId, l1SharedBridge]);

  return { withdrawalFinalizer };
});

export default WithdrawalFinalizerModule;
