-- ==============================================================================
-- ADD AUDIO TIMESTAMPS TO CHAPTERS
-- Execute this script in your Supabase SQL Editor.
-- ==============================================================================

-- 1. Add the JSONB column to store our sentence-level timestamps
ALTER TABLE public.chapters 
ADD COLUMN IF NOT EXISTS audio_timestamps JSONB;

-- 2. Update the existing mock data for 'The Little Prince' Chapter 1
-- We are giving it a sample MP3 and assigning timestamps for the 3 sentences in the text:
-- Sentence 1: "Once when I was six..." (0 to 6 seconds)
-- Sentence 2: "It was a picture of a..." (6 to 10 seconds)
-- Sentence 3: "Here is a copy of the drawing." (10 to 14 seconds)

UPDATE public.chapters
SET 
  audio_url = 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3',
  audio_timestamps = '[
    {"sentenceIndex": 0, "start": 0.0, "end": 6.0},
    {"sentenceIndex": 1, "start": 6.0, "end": 10.0},
    {"sentenceIndex": 2, "start": 10.0, "end": 14.0}
  ]'
WHERE book_id = 'a1b2c3d4-e5f6-4a5b-8c9d-0e1f2a3b4c5d' AND chapter_number = 1;
