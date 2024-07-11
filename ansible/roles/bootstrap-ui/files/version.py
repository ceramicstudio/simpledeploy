import subprocess
import re


def get_ceramic_one_version():
    try:
        # Execute the command and capture the output
        result = subprocess.run(['ceramic-one', '--version'], capture_output=True, text=True, check=True)

        # Parse the output
        match = re.search(r'ceramic-one (\d+\.\d+\.\d+)', result.stdout)

        if match:
            version = match.group(1)
            return version
        else:
            raise ValueError("Unable to parse version from output")

    except subprocess.CalledProcessError as e:
        print(f"Error executing command: {e}")
        return None
    except FileNotFoundError:
        print("ceramic-one command not found. Make sure it's installed and in your PATH.")
        return None
    except ValueError as e:
        print(f"Error parsing version: {e}")
        return None


if __name__ == "__main__":

    # Call the function and store the result
    ceramic_one_version = get_ceramic_one_version()

    if ceramic_one_version:
        print(f"Ceramic One version: {ceramic_one_version}")
    else:
        print("Failed to retrieve Ceramic One version.")
