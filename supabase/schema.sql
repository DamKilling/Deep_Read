-- ==============================================================================
-- DEEP READ SUPABASE SCHEMA
-- Execute this script in the Supabase SQL Editor to create the required tables.
-- ==============================================================================

-- 1. Create the 'books' table
CREATE TABLE IF NOT EXISTS public.books (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    title TEXT NOT NULL,
    author TEXT NOT NULL,
    cover_url TEXT,
    difficulty_level TEXT, -- e.g., A1, A2, B1...
    description TEXT,
    total_chapters INTEGER DEFAULT 0,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);

-- 2. Create the 'chapters' table
CREATE TABLE IF NOT EXISTS public.chapters (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    book_id UUID NOT NULL REFERENCES public.books(id) ON DELETE CASCADE,
    chapter_number INTEGER NOT NULL,
    title TEXT NOT NULL,
    content TEXT NOT NULL, -- The actual text of the chapter
    audio_url TEXT, -- URL to the MP3 file
    word_count INTEGER DEFAULT 0,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL,
    UNIQUE(book_id, chapter_number)
);

-- 3. Create the 'user_progress' table
-- Tracks the overall progress of a user across the app
CREATE TABLE IF NOT EXISTS public.user_progress (
    user_id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
    consecutive_days INTEGER DEFAULT 0,
    total_words_read INTEGER DEFAULT 0,
    books_completed INTEGER DEFAULT 0,
    last_read_date DATE,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);

-- 4. Create the 'user_book_progress' table
-- Tracks which book the user is reading and what chapter they are on
CREATE TABLE IF NOT EXISTS public.user_book_progress (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    book_id UUID NOT NULL REFERENCES public.books(id) ON DELETE CASCADE,
    current_chapter_number INTEGER DEFAULT 1,
    is_completed BOOLEAN DEFAULT FALSE,
    started_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL,
    last_read_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL,
    UNIQUE(user_id, book_id)
);

-- ==============================================================================
-- RLS (Row Level Security) POLICIES
-- ==============================================================================

-- Enable RLS on all tables
ALTER TABLE public.books ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.chapters ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.user_progress ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.user_book_progress ENABLE ROW LEVEL SECURITY;

-- Books and Chapters are readable by everyone (authenticated or not, up to you. Usually authenticated only)
CREATE POLICY "Books are viewable by authenticated users" 
ON public.books FOR SELECT TO authenticated USING (true);

CREATE POLICY "Chapters are viewable by authenticated users" 
ON public.chapters FOR SELECT TO authenticated USING (true);

-- User Progress is only readable/writable by the owner
CREATE POLICY "Users can view own progress" 
ON public.user_progress FOR SELECT TO authenticated USING (auth.uid() = user_id);

CREATE POLICY "Users can insert own progress" 
ON public.user_progress FOR INSERT TO authenticated WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update own progress" 
ON public.user_progress FOR UPDATE TO authenticated USING (auth.uid() = user_id);

-- User Book Progress is only readable/writable by the owner
CREATE POLICY "Users can view own book progress" 
ON public.user_book_progress FOR SELECT TO authenticated USING (auth.uid() = user_id);

CREATE POLICY "Users can insert own book progress" 
ON public.user_book_progress FOR INSERT TO authenticated WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update own book progress" 
ON public.user_book_progress FOR UPDATE TO authenticated USING (auth.uid() = user_id);

-- ==============================================================================
-- INSERT MOCK DATA (Optional - run this to have something to look at)
-- ==============================================================================

INSERT INTO public.books (id, title, author, difficulty_level, description, total_chapters, cover_url)
VALUES 
('a1b2c3d4-e5f6-4a5b-8c9d-0e1f2a3b4c5d', 'The Little Prince', 'Antoine de Saint-Exupéry', 'A2', 'A pilot stranded in the desert meets a young prince.', 27, 'https://via.placeholder.com/150x220.png?text=Little+Prince'),
('b2c3d4e5-f6a7-5b6c-9d0e-1f2a3b4c5d6e', 'Alice in Wonderland', 'Lewis Carroll', 'B1', 'A young girl falls through a rabbit hole.', 12, 'https://via.placeholder.com/150x220.png?text=Alice');

-- Insert a sample chapter for The Little Prince
INSERT INTO public.chapters (book_id, chapter_number, title, content, word_count)
VALUES 
('a1b2c3d4-e5f6-4a5b-8c9d-0e1f2a3b4c5d', 1, 'Chapter 1', 'Once when I was six years old I saw a magnificent picture in a book, called True Stories from Nature, about the primeval forest. It was a picture of a boa constrictor in the act of swallowing an animal. Here is a copy of the drawing.', 45);
