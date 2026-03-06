#!/usr/bin/env python
import os
import argparse
import sys

sys.path.append(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

from dotenv import load_dotenv
from ingestion.supabase_importer import SupabaseImporter
from ingestion.cover_handler import CoverHandler

def main():
    parser = argparse.ArgumentParser(description="Batch fix missing covers in Supabase books table")
    parser.add_argument('--limit', type=int, default=10, help="Maximum number of books to process")
    parser.add_argument('--all', action='store_true', help="Process all books missing a cover")
    
    args = parser.parse_args()

    load_dotenv()
    supa_url = os.getenv("SUPABASE_URL")
    supa_key = os.getenv("SUPABASE_KEY")
    
    if not supa_url or not supa_key:
        print("Error: SUPABASE_URL and SUPABASE_KEY must be set.")
        sys.exit(1)

    importer = SupabaseImporter(supa_url, supa_key)
    cover_handler = CoverHandler(importer.client)

    if not importer.has_cover_source:
        print("\n[Notice] 'cover_source' column not found in 'books' table.")
        print("Run this SQL to track where covers come from:")
        print("  ALTER TABLE books ADD COLUMN IF NOT EXISTS cover_source text;")
        print("Proceeding anyway, but won't save source info.\n")

    # Fetch books without a cover or with a broken cover
    print("Fetching books with missing covers...")
    
    # query books where cover_url is null or empty
    res = importer.client.table('books').select('id, title, author, cover_url').execute()
    books = res.data

    # Filter books that actually need a cover
    # e.g., cover_url is empty, or doesn't have supabase storage link, or maybe we want to regenerate?
    # Let's just fix those with empty or very short strings.
    needs_cover = [b for b in books if not b.get('cover_url') or len(b.get('cover_url', '')) < 10]
    
    if not needs_cover:
        print("All books seem to have a cover_url! Exiting.")
        return
        
    print(f"Found {len(needs_cover)} book(s) missing covers.")
    
    to_process = needs_cover if args.all else needs_cover[:args.limit]
    
    for b in to_process:
        book_id = b['id']
        title = b['title']
        author = b['author']
        
        print(f"\n--- Processing: {title} by {author} ---")
        
        # We don't have gutendex source_url here, so it relies on OpenLibrary -> AutoGenerate
        new_url, source = cover_handler.process_cover(title, author, source_url=None)
        
        if new_url:
            print(f"  -> Cover generated/fetched successfully (Source: {source})")
            update_data = {"cover_url": new_url}
            if importer.has_cover_source:
                update_data["cover_source"] = source
                
            importer.client.table('books').update(update_data).eq('id', book_id).execute()
            print("  -> Database updated.")
        else:
            print("  -> Failed to generate/fetch cover.")

if __name__ == "__main__":
    main()
