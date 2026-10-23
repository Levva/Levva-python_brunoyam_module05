ALTER TABLE books 
ADD COLUMN IF NOT EXISTS metadata jsonb
DEFAULT '{}'::jsonb;

UPDATE books 
SET metadata = jsonb_set(metadata, '{award_winner}', 'false'::jsonb) 
WHERE id >= 5;

SELECT * FROM books
WHERE metadata @> '{"award_winner": true}';

UPDATE books 
SET metadata = COALESCE(metadata, '{}'::jsonb) || '{"page_count": 350}'::jsonb 
WHERE id = 5;

SELECT id, title, metadata FROM books WHERE id = 5;
