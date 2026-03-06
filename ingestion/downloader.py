import requests

def download_text(url: str) -> str:
    """
    Downloads text from a URL.
    Returns the decoded string content.
    """
    response = requests.get(url)
    response.raise_for_status()
    
    # Try to decode safely
    try:
        return response.content.decode('utf-8')
    except UnicodeDecodeError:
        return response.content.decode('iso-8859-1', errors='replace')
