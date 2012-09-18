

============================================
==       Create Database Swimming.db3     ==
============================================


CREATE TABLE sqlite_sequence(name,seq);
CREATE TABLE sqlite_stat1(tbl,idx,stat);
CREATE TABLE users (
    "id" INTEGER PRIMARY KEY,
    "user" VARCHAR(20) NOT NULL,
    "passwd" VARCHAR(20),
    "dtmod" DATETIME
);
CREATE UNIQUE INDEX "idx_user" on users (user ASC);
CREATE TABLE "_alter0_log_users" (
    "id" INTEGER,
    "action" CHAR(4) NOT NULL,
    "userid" INTEGER NOT NULL,
    "user" VARCHAR(20) NOT NULL,
    "passwd" VARCHAR(20),
    "dtmod" DATETIME
);
CREATE TABLE log_users (
    "id" INTEGER PRIMARY KEY,
    "action" CHAR(4) NOT NULL,
    "userid" INTEGER NOT NULL,
    "user" VARCHAR(20) NOT NULL,
    "passwd" VARCHAR(20),
    "dtmod" DATETIME
);
CREATE TRIGGER "tr_users_After_Insert"  AFTER insert ON users
BEGIN
    update users set dtmod = datetime('now') where rowid = new.rowid;    
    insert into log_users (  action, userid, user, passwd )
                 values ( 'INS', new.id, new.user, new.passwd );
END;
CREATE TRIGGER "tr_log_users_After_Insert" AFTER insert ON log_users
BEGIN
    update log_users set dtmod = datetime('now') where rowid = new.rowid;
END;
CREATE TRIGGER "tr_users_Before_Delete" before delete  ON users
BEGIN
    insert into log_users (  action, userid, user, passwd )
                 values ( 'DEL', old.id, old.user, old.passwd );
END;
CREATE TRIGGER "tr_users_Before_Update" before update  ON users
BEGIN
    update users set dtmod = datetime('now') where rowid = old.rowid;
    insert into log_users (  action, userid, user, passwd )
                 values ( 'MOD1', old.id, old.user, old.passwd );
    insert into log_users (  action, userid, user, passwd )
                 values ( 'MOD2', new.id, new.user, new.passwd );
END;












