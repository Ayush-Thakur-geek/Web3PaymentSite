const { ethers, run, network } = require("hardhat")
const { env } = require("dotenv")

async function main() {
    const payPalFactory = await ethers.getContractFactory("PayPal")
    const payPal = await payPalFactory.deploy()
    console.log("Deploying contracts...")
    console.log(`Deploying contract to: ${payPal.target}`)
    console.log(network.config)
    if (network.config.chainId === 11155111 && process.env.ETHERSCAN_API_KEY) {
        console.log("Waiting for block configurations...")
        await payPal.deploymentTransaction().wait(6)
        await verify(payPal.target, [])
    }
}

const verify = async (contractAddress, args) => {
    console.log("Verifying contract...")
    try {
        await run("verify:verify", {
            address: contractAddress,
            constructorArgument: args,
        })
    } catch (error) {
        if (error.message.toLowerCase().includes("already verified")) {
            console.log("Already Verified")
        } else {
            console.error(error)
        }
    }
}

main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error)
        process.exit(1)
    })
