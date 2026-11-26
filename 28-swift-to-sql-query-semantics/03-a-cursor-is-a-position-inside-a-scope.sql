SELECT id, title, published_at
FROM articles
WHERE workspace_id = $1
  AND status = 'published'
  AND (published_at, id) < ($2, $3)
ORDER BY published_at DESC, id DESC
LIMIT $4;
