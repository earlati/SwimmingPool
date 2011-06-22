PRAGMA foreign_keys=OFF;
BEGIN TRANSACTION;
ANALYZE sqlite_master;
CREATE TABLE users (
    "id" INTEGER PRIMARY KEY,
    "user" VARCHAR(20) NOT NULL,
    "passwd" VARCHAR(20),
    "dtmod" DATETIME
);
INSERT INTO "users" VALUES(1,'enzo','123x','2011-03-05 16:18:48');
INSERT INTO "users" VALUES(2,'pino','','2011-03-05 15:15:26');
CREATE TABLE "_alter0_log_users" (
    "id" INTEGER,
    "action" CHAR(4) NOT NULL,
    "userid" INTEGER NOT NULL,
    "user" VARCHAR(20) NOT NULL,
    "passwd" VARCHAR(20),
    "dtmod" DATETIME
);
INSERT INTO "_alter0_log_users" VALUES(6,'MOD',1,'enzo','123Abc','2011-03-05 15:47:13');
INSERT INTO "_alter0_log_users" VALUES(7,'MOD',1,'enzo','1','2011-03-05 15:47:19');
INSERT INTO "_alter0_log_users" VALUES(8,'MOD',1,'enzo','12','2011-03-05 15:47:23');
INSERT INTO "_alter0_log_users" VALUES(9,'MOD',1,'enzo','123','2011-03-05 15:47:28');
INSERT INTO "_alter0_log_users" VALUES(10,'MOD',4,'ginxo','','2011-03-05 15:52:37');
INSERT INTO "_alter0_log_users" VALUES(11,'INS',4,'ginxo','','2011-03-05 15:52:37');
INSERT INTO "_alter0_log_users" VALUES(12,'MOD',5,'ginxoxxx','','2011-03-05 15:53:11');
INSERT INTO "_alter0_log_users" VALUES(13,'INS',5,'ginxoxxx','','2011-03-05 15:53:11');
INSERT INTO "_alter0_log_users" VALUES(NULL,'DEL',3,'gino','aaa','2011-03-05 16:03:41');
INSERT INTO "_alter0_log_users" VALUES(NULL,'MODB',3,'gino','aaa','2011-03-05 16:03:41');
INSERT INTO "_alter0_log_users" VALUES(NULL,'MODA',3,'gino','aaa','2011-03-05 16:03:41');
INSERT INTO "_alter0_log_users" VALUES(NULL,'DEL',3,'gino','aaa','2011-03-05 16:03:41');
INSERT INTO "_alter0_log_users" VALUES(NULL,'INS',3,'gino','aaa','2011-03-05 16:03:41');
CREATE TABLE log_users (
    "id" INTEGER PRIMARY KEY,
    "action" CHAR(4) NOT NULL,
    "userid" INTEGER NOT NULL,
    "user" VARCHAR(20) NOT NULL,
    "passwd" VARCHAR(20),
    "dtmod" DATETIME
);
INSERT INTO "log_users" VALUES(1,'MOD1',3,'gino001','aaa','2011-03-05 16:26:40');
INSERT INTO "log_users" VALUES(2,'MOD2',3,'gino001','aaa','2011-03-05 16:26:40');
INSERT INTO "log_users" VALUES(3,'INS',3,'gino001','aaa','2011-03-05 16:26:40');
INSERT INTO "log_users" VALUES(4,'DEL',3,'gino001','aaa','2011-03-05 16:27:09');
INSERT INTO "log_users" VALUES(5,'MOD1',3,'gino001','aaa','2011-03-05 16:27:28');
INSERT INTO "log_users" VALUES(6,'MOD2',3,'gino001','aaa','2011-03-05 16:27:28');
INSERT INTO "log_users" VALUES(7,'INS',3,'gino001','aaa','2011-03-05 16:27:28');
INSERT INTO "log_users" VALUES(8,'MOD1',4,'gino002','bbb','2011-03-05 16:27:45');
INSERT INTO "log_users" VALUES(9,'MOD2',4,'gino002','bbb','2011-03-05 16:27:45');
INSERT INTO "log_users" VALUES(10,'INS',4,'gino002','bbb','2011-03-05 16:27:45');
INSERT INTO "log_users" VALUES(11,'DEL',3,'gino001','aaa','2011-03-05 16:28:16');
INSERT INTO "log_users" VALUES(12,'DEL',4,'gino002','bbb','2011-03-05 16:28:16');
CREATE UNIQUE INDEX "idx_user" on users (user ASC);
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
COMMIT;
