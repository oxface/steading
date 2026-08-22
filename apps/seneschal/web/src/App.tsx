import { useQuery } from '@tanstack/react-query'

type HealthResponse = {
  status: 'ok'
  description: string
}

function isHealthResponse(value: unknown): value is HealthResponse {
  if (typeof value !== 'object' || value === null) {
    return false
  }

  const candidate = value as Record<string, unknown>

  return candidate.status === 'ok' && typeof candidate.description === 'string'
}

async function fetchHealth(): Promise<HealthResponse> {
  const response = await fetch('/api/health')

  if (!response.ok) {
    throw new Error(`Health request failed: ${response.status}`)
  }

  const payload: unknown = await response.json()

  if (!isHealthResponse(payload)) {
    throw new Error('Invalid health response')
  }

  return payload
}

function App() {
  const healthQuery = useQuery({
    queryKey: ['api', 'health'],
    queryFn: fetchHealth,
    staleTime: 30_000,
    retry: 1,
    refetchOnWindowFocus: true,
  })

  let apiLabel: string
  let apiIndicatorClass: string

  if (healthQuery.isPending) {
    apiLabel = 'api: loading'
    apiIndicatorClass = 'bg-yellow-500'
  } else if (healthQuery.isError) {
    apiLabel = 'api: unavailable'
    apiIndicatorClass = 'bg-red-500'
  } else {
    apiLabel = `api: ${healthQuery.data.status}`
    apiIndicatorClass = 'bg-emerald-500'
  }

  return (
    <div className="flex h-dvh flex-col">
      <header className="flex h-14 items-center justify-between border-b px-4">
        <div className="flex">Seneschal</div>
        <span
          className="flex items-center gap-2 text-sm text-zinc-500"
          aria-live="polite"
        >
          <span
            className={`size-2 rounded-full ${apiIndicatorClass}`}
            aria-hidden="true"
          />
          {apiLabel}
        </span>
      </header>
      <main className="flex-1 p-6">
        <h1 className="mb-2 text-2xl font-bold">Seneschal</h1>
        <p className="text-zinc-600">{apiLabel}</p>
      </main>
    </div>
  )
}

export default App
