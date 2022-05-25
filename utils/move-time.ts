import { network } from "hardhat";

export async function moveTime(amount: number) {
  console.log("moving Time....");
  await network.provider.send("evm_increasetime", [amount]);
  console.log(`Moved forward ${amount} seconds`);
}
