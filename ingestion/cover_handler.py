import os
import io
import urllib.parse
import requests
import textwrap
from PIL import Image, ImageDraw, ImageFont
from supabase import Client

class CoverHandler:
    def __init__(self, supabase_client: Client):
        self.client = supabase_client
        self.bucket_name = "covers"
        self._ensure_bucket()

    def _ensure_bucket(self):
        try:
            buckets = self.client.storage.list_buckets()
            if not any(b.name == self.bucket_name for b in buckets):
                self.client.storage.create_bucket(self.bucket_name, public=True)
        except Exception as e:
            # Might lack permissions to list/create, just try to proceed
            pass

    def process_cover(self, title: str, author: str, source_url: str = None) -> tuple[str, str]:
        """
        Attempts to fetch or generate a cover, uploads it to Supabase Storage,
        and returns the (public_url, cover_source)
        """
        image_bytes = None
        cover_source = None

        # 1. Try Gutendex Source URL
        if source_url:
            try:
                resp = requests.get(source_url, timeout=10)
                if resp.status_code == 200:
                    image_bytes = resp.content
                    cover_source = "gutendex"
            except Exception as e:
                print(f"      [Cover] Failed to fetch source cover: {e}")

        # 2. Try Open Library
        if not image_bytes:
            try:
                query_url = f"https://openlibrary.org/search.json?title={urllib.parse.quote(title)}&author={urllib.parse.quote(author)}&limit=1"
                resp = requests.get(query_url, timeout=10).json()
                docs = resp.get("docs", [])
                if docs and docs[0].get("cover_i"):
                    cover_id = docs[0].get("cover_i")
                    cover_url = f"https://covers.openlibrary.org/b/id/{cover_id}-L.jpg"
                    cover_resp = requests.get(cover_url, timeout=10)
                    if cover_resp.status_code == 200:
                        image_bytes = cover_resp.content
                        cover_source = "openlibrary"
            except Exception as e:
                print(f"      [Cover] Failed to fetch from Open Library: {e}")

        # 3. Auto Generate
        if not image_bytes:
            image_bytes = self._generate_default_cover(title, author)
            cover_source = "generated"

        # 4. Upload to Supabase Storage
        safe_title = "".join([c if c.isalnum() else "_" for c in title]).strip("_")[:40]
        file_name = f"{safe_title}_{cover_source}.jpg"

        try:
            # Use upsert to overwrite if it exists
            self.client.storage.from_(self.bucket_name).upload(
                path=file_name,
                file=image_bytes,
                file_options={"content-type": "image/jpeg", "upsert": "true"}
            )
        except Exception as e:
            # Handle potential duplicate path error if upsert doesn't work out of the box in this python client version
            try:
                self.client.storage.from_(self.bucket_name).update(
                    path=file_name,
                    file=image_bytes,
                    file_options={"content-type": "image/jpeg", "upsert": "true"}
                )
            except Exception as update_e:
                print(f"      [Cover] Failed to upload cover to Supabase: {update_e}")
                return "", cover_source

        # Retrieve public URL
        public_url = self.client.storage.from_(self.bucket_name).get_public_url(file_name)
        return public_url, cover_source

    def _generate_default_cover(self, title: str, author: str) -> bytes:
        """
        Generates a 600x900 default cover image.
        """
        width, height = 600, 900
        bg_color = (245, 240, 230)
        text_color = (40, 40, 40)
        border_color = (180, 170, 150)

        img = Image.new('RGB', (width, height), color=bg_color)
        draw = ImageDraw.Draw(img)

        # Draw border
        draw.rectangle([20, 20, width-20, height-20], outline=border_color, width=8)
        draw.rectangle([35, 35, width-35, height-35], outline=border_color, width=2)

        # Try to load a nice font, fallback to default
        try:
            # Windows typical path, fallback to something common or PIL default
            font_title = ImageFont.truetype("arial.ttf", 60)
            font_author = ImageFont.truetype("arial.ttf", 40)
        except Exception:
            font_title = ImageFont.load_default(size=48) if hasattr(ImageFont, 'load_default') else ImageFont.load_default()
            font_author = ImageFont.load_default(size=32) if hasattr(ImageFont, 'load_default') else ImageFont.load_default()

        # Wrap text
        # Title
        title_lines = textwrap.wrap(title, width=16)
        y_text = 150
        for line in title_lines:
            bbox = draw.textbbox((0, 0), line, font=font_title)
            text_w = bbox[2] - bbox[0]
            draw.text(((width - text_w) / 2, y_text), line, font=font_title, fill=text_color)
            y_text += (bbox[3] - bbox[1]) + 20

        # Author
        y_author = height - 200
        author_text = f"By {author}" if author else "Unknown Author"
        author_lines = textwrap.wrap(author_text, width=25)
        for line in author_lines:
            bbox = draw.textbbox((0, 0), line, font=font_author)
            text_w = bbox[2] - bbox[0]
            draw.text(((width - text_w) / 2, y_author), line, font=font_author, fill=text_color)
            y_author += (bbox[3] - bbox[1]) + 15

        img_byte_arr = io.BytesIO()
        img.save(img_byte_arr, format='JPEG', quality=85)
        return img_byte_arr.getvalue()
