# Student PostgreSQL recovery practice

Bash, Docker Desktop/Engine, Compose v2 supporting --wait. No host PostgreSQL. Pinned PostgreSQL16; data path matches that version. Dummy-only data. No host database ports.

Fork this starter, clone your fork and enter it. Run bash practice.sh setup only in fresh working copy (refuses existing source). Then start, read, add. Save source identity before replace; replace only source container, save new identity, then read before any further write. Never remove volume.

Run backup; failure/partial file is not a valid backup. Ask mentor to inspect target: separate restore service, recovered database, distinct restore_data volume, no public tables. Only mentor-confirmed disposable target may receive restore command:

bash practice.sh restore MENTOR_CONFIRMED_DISPOSABLE

Typing confirmation is not approval by itself; mentor must inspect. Then verify both recovered and original entries. down removes project containers/network, not volumes. No -v/prune, no --clean restore, no unknown target. Never restore untrusted archives: dumps can execute supplied SQL. Dummy account is privileged for bounded exercise, not production role design.

Expected owned record: event-registration-owned-record. Source and target use separate project-scoped volumes. Do not reuse project name across independent concurrent copies. If target has tables, STOP; preserve it and ask mentor for fresh separately named exercise target. Archive is local host data: protect it and copy to an authorised independent location for real recovery planning. No backup guarantee from one local file or one restore test.
