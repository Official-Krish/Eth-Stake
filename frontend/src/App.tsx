import { WagmiProvider } from 'wagmi'
import { QueryClient, QueryClientProvider } from '@tanstack/react-query'

import './App.css'
import { config } from './config'
import { Appbar } from './components/Appbar'

function App() {

  return (
    <>
      <WagmiProvider config={config}>
        <QueryClientProvider client={QueryClient}>
          <Appbar />
        </QueryClientProvider>
      </WagmiProvider>
    </>
  )
}

export default App
