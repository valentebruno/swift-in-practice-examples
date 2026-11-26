SELECT id, title, published_at
FROM articles
WHERE workspace_id = $1
  AND status = 'published'
ORDER BY published_at DESC, id DESC
LIMIT $2;
