#!/usr/bin/env python
import os
import argparse
import sys

# Add parent directory to path so we can import 'ingestion' module
sys.path.append(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

from dotenv import load_dotenv
from ingestion.gutendex_client import GutendexClient
from ingestion.downloader import download_text
from ingestion.text_cleaner import clean_gutenberg_text
from ingestion.chapter_parser import parse_chapters
from ingestion.supabase_importer import SupabaseImporter
from ingestion.cover_handler import CoverHandler

def main():
    parser = argparse.ArgumentParser(description="Automated book importer from Gutendex to Supabase")
    parser.add_argument('--query', type=str, help="Search query (e.g. 'Sherlock Holmes')")
    parser.add_argument('--language', type=str, default='en', help="Language filter (default: 'en')")
    parser.add_argument('--limit', type=int, default=5, help="Maximum number of books to process (default: 5)")
    parser.add_argument('--skip-existing', action='store_true', help="Skip books that are already in the database")
    parser.add_argument('--dry-run', action='store_true', help="Fetch and parse books, but do not write to the database")
    
    args = parser.parse_args()

    # Load env vars
    load_dotenv()
    supa_url = os.getenv("SUPABASE_URL")
    supa_key = os.getenv("SUPABASE_KEY")
    
    if not args.dry_run and (not supa_url or not supa_key):
        print("Error: SUPABASE_URL and SUPABASE_KEY must be set in environment or .env file.")
        sys.exit(1)

    # Initialize components
    gutendex = GutendexClient()
    importer = SupabaseImporter(supa_url, supa_key) if not args.dry_run else None
    cover_handler = CoverHandler(importer.client) if not args.dry_run else None

    if not args.dry_run and not importer.has_schema_updates:
        print("\n[Notice] It is highly recommended to add 'source' and 'external_id' columns to your 'books' table for better deduplication.")
        print("You can run this SQL in Supabase:")
        print("  ALTER TABLE books ADD COLUMN IF NOT EXISTS source text DEFAULT 'gutendex';")
        print("  ALTER TABLE books ADD COLUMN IF NOT EXISTS external_id text;")
        print("Falling back to Title + Author matching for duplicates.\n")

    print(f"Searching Gutendex (query='{args.query}', lang='{args.language}', limit={args.limit})...")
    books = gutendex.search_books(query=args.query, language=args.language, limit=args.limit)
    
    if not books:
        print("No books found matching the criteria.")
        return

    print(f"Found {len(books)} book(s). Starting processing...\n")

    success_count = 0
    
    for b in books:
        title = b.get('title', 'Unknown Title')
        authors = b.get('authors', [])
        author_name = authors[0]['name'] if authors else 'Unknown Author'
        external_id = str(b.get('id', ''))
        text_url = b.get('text_url')
        cover_url = b.get('cover_url') or ""
        subjects = b.get('subjects', [])
        
        print(f"--- Processing: {title} by {author_name} (ID: {external_id}) ---")
        
        if not text_url:
            print(f"  -> Skipping: No suitable plain text format found.")
            continue
            
        if not args.dry_run and args.skip_existing:
            if importer.book_exists(title=title, author=author_name, source="gutendex", external_id=external_id):
                print(f"  -> Skipping: Book already exists in database.")
                continue

        print(f"  -> Downloading text from {text_url}...")
        try:
            raw_text = download_text(text_url)
        except Exception as e:
            print(f"  -> Error downloading: {e}")
            continue
            
        print("  -> Cleaning text and removing boilerplate...")
        clean_text = clean_gutenberg_text(raw_text)
        
        print("  -> Parsing chapters...")
        chapters = parse_chapters(clean_text)
        print(f"  -> Identified {len(chapters)} chapters/sections.")
        
        if args.dry_run:
            print("  -> [DRY RUN] Skipping database import.")
            print(f"  -> Summary: {len(clean_text)} characters cleaned, {len(chapters)} chapters parsed.")
            success_count += 1
            continue
            
        print("  -> Processing cover image...")
        final_cover_url, final_cover_source = cover_handler.process_cover(title, author_name, cover_url)

        # Import to DB
        book_data = {
            "title": title,
            "author": author_name,
            "cover_url": final_cover_url,
            "cover_source": final_cover_source,
            "difficulty_level": "C1", # Default fallback
            "description": ", ".join(subjects[:3]) if subjects else f"A classic book: {title}",
            "source": "gutendex",
            "external_id": external_id
        }
        
        print("  -> Importing to Supabase...")
        success = importer.import_book(book_data, chapters)
        if success:
            print(f"  -> Success!")
            success_count += 1
        else:
            print(f"  -> Failed to import.")

    print(f"\nFinished! Successfully processed {success_count} out of {len(books)} books.")

if __name__ == "__main__":
    main()
