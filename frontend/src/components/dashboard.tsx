import { useWriteContract, useReadContract } from 'wagmi'
import { abi } from '../abi'

export function Dashboard() {
    const { writeContract } = useWriteContract()

    return <div className="h-screen w-scren flex justify-center items-center">
        <div>
            <button className='mx-2 border rounded p-2 text-2xl' onClick={() => {
                writeContract({
                    address: '0x51fac1b64f2329519e68595937ea58eb83803c91',
                    abi,
                    functionName: 'stake',
                    args: [BigInt(1000000000000000000)],
                    value: BigInt(1000000000000000000)
                })
            }}>
                Stake
            </button>
            <div>
                <ShowStake />
            </div>
        </div>
    </div>
}

function ShowStake() {
    const { 
        data: balance,
      } = useReadContract({
        address: '0x51fac1b64f2329519e68595937ea58eb83803c91',
        abi,
        functionName: 'stakedBalances',
        args: ['0x2966473D85A76A190697B5b9b66b769436EFE8e5'],
    })
    return <div>
        You have staked {(balance?.toString())} ETH
    </div>
}