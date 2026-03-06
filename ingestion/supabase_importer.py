import os
from supabase import create_client, Client
from typing import List, Tuple

class SupabaseImporter:
    def __init__(self, url: str, key: str):
        self.client: Client = create_client(url, key)
        self.has_schema_updates = self._check_schema()
        self.has_cover_source = self.check_cover_source_column()

    def _check_schema(self) -> bool:
        """
        Check if the 'books' table has 'source' and 'external_id' columns.
        """
        try:
            # Query just to see if the columns exist
            self.client.table("books").select("source, external_id").limit(1).execute()
            return True
        except Exception:
            return False


    def check_cover_source_column(self) -> bool:
        try:
            self.client.table("books").select("cover_source").limit(1).execute()
            return True
        except Exception:
            return False

    def book_exists(self, title: str, author: str, source: str = "gutendex", external_id: str = None) -> bool:
        """
        Checks if a book already exists in the database.
        """
        try:
            if self.has_schema_updates and external_id:
                res = self.client.table("books").select("id").eq("source", source).eq("external_id", str(external_id)).execute()
                if res.data:
                    return True
                    
            # Fallback check by title and author
            res = self.client.table("books").select("id").eq("title", title).eq("author", author).execute()
            return len(res.data) > 0
        except Exception as e:
            print(f"Warning: Error checking book existence: {e}")
            return False

    def import_book(self, book_data: dict, chapters: List[Tuple[str, str]]) -> bool:
        """
        Imports book and its chapters into Supabase.
        book_data should contain: title, author, cover_url, difficulty_level, description, (optional: source, external_id)
        chapters is a list of (title, content)
        """
        # Prepare insert payload
        payload = {
            "title": book_data.get("title"),
            "author": book_data.get("author", "Unknown"),
            "cover_url": book_data.get("cover_url", ""),
            "difficulty_level": book_data.get("difficulty_level", "B2"),
            "description": book_data.get("description", ""),
            "total_chapters": 0
        }
        

        if "cover_source" in book_data and getattr(self, 'has_cover_source', False):
            payload["cover_source"] = book_data["cover_source"]

        if self.has_schema_updates:
            if "source" in book_data:
                payload["source"] = book_data["source"]
            if "external_id" in book_data:
                payload["external_id"] = str(book_data["external_id"])

        try:
            book_res = self.client.table("books").insert(payload).execute()
            if not book_res.data:
                print("Error: No data returned after book insertion.")
                return False
                
            book_id = book_res.data[0]['id']
            
            # Insert chapters
            chapter_number = 1
            inserted_chapters = 0
            
            for ch_title, text_block in chapters:
                if not text_block.strip() or len(text_block) < 100:
                    continue
                    
                word_count = len(text_block.split())
                
                chapter_payload = {
                    "book_id": book_id,
                    "chapter_number": chapter_number,
                    "title": ch_title[:50],  # Limit title length
                    "content": text_block,
                    "word_count": word_count
                }
                
                self.client.table("chapters").insert(chapter_payload).execute()
                chapter_number += 1
                inserted_chapters += 1
                
            # Update total chapters count
            self.client.table("books").update({"total_chapters": inserted_chapters}).eq("id", book_id).execute()
            
            return True
            
        except Exception as e:
            print(f"Error importing book '{book_data.get('title')}': {e}")
            return False
