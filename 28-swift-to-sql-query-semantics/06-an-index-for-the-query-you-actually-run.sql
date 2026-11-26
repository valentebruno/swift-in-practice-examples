CREATE INDEX articles_published_feed
ON articles (workspace_id, published_at DESC, id DESC)
WHERE status = 'published';
