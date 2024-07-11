import asyncio
import signal
from datetime import datetime
from version import get_ceramic_one_version
from peers import get_swarm_peers
from fastapi import FastAPI
from fastapi.responses import JSONResponse, HTMLResponse
import uvicorn
import aiohttp

# Add configuration option for sleep interval (in seconds)
CACHE_UPDATE_INTERVAL = 60  # Default: 30 seconds

# Create a global event to signal shutdown
shutdown_event = asyncio.Event()

# Create a global dictionary to store the cache state
cache_state = {}

app = FastAPI()


def handle_shutdown_signal():
    print("Shutdown signal received. Exiting gracefully...")
    shutdown_event.set()


async def get_ceramic_id():
    async with aiohttp.ClientSession() as session:
        try:
            async with session.post('http://localhost:5101/api/v0/id') as response:
                if response.status == 200:
                    data = await response.json()
                    return {
                        "ID": data.get("ID"),
                        "Addresses": data.get("Addresses", [])
                    }
                else:
                    return {"error": f"Failed to get Ceramic ID. Status: {response.status}"}
        except aiohttp.ClientError as e:
            return {"error": f"Failed to connect to Ceramic node: {str(e)}"}


async def update_cache():
    while not shutdown_event.is_set():
        timestamp = datetime.now().isoformat()

        # Get Ceramic version
        ceramic_version = get_ceramic_one_version()

        # Get swarm peers
        swarm_peers = get_swarm_peers()

        # Get Ceramic ID
        ceramic_id = await get_ceramic_id()

        # Create cache entry
        cache_entry = {
            "timestamp": timestamp,
            "ceramic_version": ceramic_version,
            "swarm_peers": swarm_peers,
            "ceramic_id": ceramic_id
        }
        # Save cache entry to global dictionary
        cache_state[timestamp] = cache_entry
        print(f"Cache updated at {timestamp}")

        # Use the configured interval
        await asyncio.sleep(CACHE_UPDATE_INTERVAL)


@app.get("/latest")
async def get_latest_cache():
    if not cache_state:
        return JSONResponse(content={"error": "Cache is empty"}, status_code=404)
    latest_timestamp = max(cache_state.keys())
    return JSONResponse(content=cache_state[latest_timestamp])


@app.get("/", response_class=HTMLResponse)
async def get_root():
    html_content = """
    <!DOCTYPE html>
    <html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Ceramic bootstrap node</title>
        <script>
            async function fetchLatestCache() {
                try {
                    const response = await fetch('/latest');
                    const data = await response.json();
                    const formattedTimestamp = new Date(data.timestamp).toLocaleString();
                    const formattedData = `
                        <h2>Latest Cache Data</h2>
                        <p><strong>Timestamp:</strong> ${formattedTimestamp}</p>
                        <p><strong>Ceramic Version:</strong> ${data.ceramic_version}</p>
                        <h3>Ceramic ID:</h3>
                        <p><strong>ID:</strong> ${data.ceramic_id.ID}</p>
                        <h4>Addresses:</h4>
                        <ul>
                            ${data.ceramic_id.Addresses ?
                                data.ceramic_id.Addresses.map(address => `<li>${address}</li>`).join('') :
                                '<li>No addresses available</li>'
                            }
                        </ul>
                        <h3>Swarm Peers:</h3>
                        <ul>
                            ${data.swarm_peers.Peers ?
                                data.swarm_peers.Peers.map(peer => `
                                    <li>
                                        <strong>Peer:</strong> ${peer.Peer}<br>
                                        <strong>Addr:</strong> ${peer.Addr}<br>
                                        <strong>Direction:</strong> ${peer.Direction}
                                    </li>
                                `).join('') :
                                '<li>No peers available</li>'
                            }
                        </ul>
                    `;
                    document.getElementById('cacheData').innerHTML = formattedData;
                } catch (error) {
                    console.error('Error fetching cache data:', error);
                    document.getElementById('cacheData').innerHTML = '<p>Error fetching cache data</p>';
                }
            }

            // Fetch data immediately and then every 30 seconds
            fetchLatestCache();
            setInterval(fetchLatestCache, 30000);
        </script>
    </head>
    <body>
        <h1>Ceramic bootstrap node Cache Status</h1>
        <div id="cacheData">Loading...</div>
    </body>
    </html>
    """
    return HTMLResponse(content=html_content)


async def run_fastapi():
    config = uvicorn.Config(app, host="127.0.0.1", port=8000, loop="asyncio")
    server = uvicorn.Server(config)
    await server.serve()


async def main():
    update_task = asyncio.create_task(update_cache())
    fastapi_task = asyncio.create_task(run_fastapi())
    await asyncio.gather(update_task, fastapi_task)

if __name__ == "__main__":
    print("Starting cache updater and FastAPI server...")
    print(f"Cache update interval: {CACHE_UPDATE_INTERVAL} seconds")

    # Register signal handlers
    signal.signal(signal.SIGTERM, lambda s, f: handle_shutdown_signal())
    signal.signal(signal.SIGINT, lambda s, f: handle_shutdown_signal())

    try:
        asyncio.run(main())
    except KeyboardInterrupt:
        print("Keyboard interrupt received. Exiting gracefully...")
