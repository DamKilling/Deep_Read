import requests
from typing import List, Dict, Any, Optional

class GutendexClient:
    BASE_URL = "https://gutendex.com/books"

    def search_books(self, query: Optional[str] = None, language: str = 'en', limit: int = 10) -> List[Dict[Any, Any]]:
        """
        Search for books on Gutendex.
        """
        params = {
            'languages': language,
        }
        if query:
            params['search'] = query

        results = []
        next_url = self.BASE_URL
        
        while next_url and len(results) < limit:
            try:
                response = requests.get(next_url, params=params if next_url == self.BASE_URL else None)
                response.raise_for_status()
                data = response.json()
                
                books = data.get('results', [])
                if not books:
                    break
                    
                for book in books:
                    if len(results) >= limit:
                        break
                        
                    # Find a text/plain URL
                    text_url = None
                    for mime_type, url in book.get('formats', {}).items():
                        if mime_type.startswith('text/plain') and 'zip' not in mime_type:
                            text_url = url
                            # Prefer utf-8 if available, else take the first plain text
                            if 'utf-8' in mime_type.lower():
                                break
                    
                    if text_url:
                        book['text_url'] = text_url
                        
                        # Extract a cover image if available
                        cover_url = None
                        for mime_type, url in book.get('formats', {}).items():
                            if mime_type.startswith('image/jpeg'):
                                cover_url = url
                                break
                        book['cover_url'] = cover_url
                        
                        results.append(book)
                
                next_url = data.get('next')
            except Exception as e:
                print(f"Error fetching from Gutendex: {e}")
                break
                
        return results
