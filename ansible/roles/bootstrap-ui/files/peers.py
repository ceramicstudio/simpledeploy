import requests
import json


def get_swarm_peers():
    url = "http://localhost:5101/api/v0/swarm/peers"

    try:
        # Send POST request
        response = requests.post(url, timeout=10)

        # Raise an exception for bad status codes
        response.raise_for_status()

        # Parse JSON response
        json_response = response.json()

        return json_response

    except requests.exceptions.RequestException as e:
        print(f"An error occurred while making the request: {e}")
        return None

    except json.JSONDecodeError as e:
        print(f"Error decoding JSON response: {e}")
        return None


if __name__ == "__main__":
    result = get_swarm_peers()

    if result is not None:
        print("Response received:")
        print(json.dumps(result, indent=2))
    else:
        print("Failed to get a valid response.")
