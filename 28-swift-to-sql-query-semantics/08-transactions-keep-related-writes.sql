UPDATE articles
SET title = $1, revision = revision + 1
WHERE workspace_id = $2
  AND id = $3
  AND revision = $4
RETURNING revision;
