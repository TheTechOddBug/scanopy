-- Fix daemons.user_id foreign key to SET NULL on user deletion
-- Previously blocked user deletion if they maintained any daemons

ALTER TABLE daemons DROP CONSTRAINT daemons_user_id_fkey;
ALTER TABLE daemons ADD CONSTRAINT daemons_user_id_fkey
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE SET NULL;
