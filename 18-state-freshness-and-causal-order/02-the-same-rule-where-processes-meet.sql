INSERT INTO flight_snapshot (account_id, flight_id, epoch, revision, status)
VALUES (:account_id, :flight_id, :epoch, :revision, :status)
ON CONFLICT (account_id, flight_id) DO UPDATE
SET revision = excluded.revision,
    status   = excluded.status
WHERE flight_snapshot.epoch = excluded.epoch
  AND flight_snapshot.revision < excluded.revision;
