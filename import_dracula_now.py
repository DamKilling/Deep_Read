import os
import sys
from dotenv import load_dotenv

sys.path.append(os.path.dirname(os.path.abspath(__file__)))
from ingestion.text_cleaner import clean_gutenberg_text
from ingestion.chapter_parser import parse_chapters
from ingestion.supabase_importer import SupabaseImporter

def run_import():
    load_dotenv()
    supa_url = os.getenv("SUPABASE_URL")
    supa_key = os.getenv("SUPABASE_KEY")
    
    if not supa_url or not supa_key:
        print("Missing Supabase credentials in .env")
        return

    importer = SupabaseImporter(supa_url, supa_key)

    print("Reading local dracula_full.txt...")
    with open('dracula_full.txt', 'r', encoding='utf-8') as f:
        raw_text = f.read()

    print("Cleaning text...")
    clean_text = clean_gutenberg_text(raw_text)
    
    print("Parsing chapters...")
    chapters = parse_chapters(clean_text)
    
    print(f"Parsed {len(chapters)} raw chapters. Filtering short ones...")

    book_data = {
        "title": "Dracula",
        "author": "Bram Stoker",
        "cover_url": "https://www.gutenberg.org/cache/epub/345/pg345.cover.medium.jpg",
        "difficulty_level": "C1",
        "description": "Dracula is a novel by Bram Stoker.",
        "source": "gutendex",
        "external_id": "345"
    }

    print("Importing to Supabase...")
    success = importer.import_book(book_data, chapters)
    
    if success:
        print("Successfully imported Dracula with new parsing logic!")
    else:
        print("Import failed. Check logs.")

if __name__ == "__main__":
    run_import()
