CREATE TABLE sqlite_sequence(name,seq);
CREATE TABLE sqlite_stat1(tbl,idx,stat);

-- =================================================
CREATE TABLE users (
    "id" INTEGER PRIMARY KEY,
    "user" VARCHAR(20) NOT NULL,
    "passwd" VARCHAR(20),
    "dtmod" DATETIME
);
CREATE UNIQUE INDEX "idx_user" on users (user ASC);
-- =================================================
drop trigger tr_users_After_Insert; 
CREATE TRIGGER "tr_users_After_Insert"  AFTER insert ON users
BEGIN
    update users set dtmod = datetime('now') where rowid = new.rowid;    
    insert into log_users (  action, userid, user, passwd )
                 values ( 'INS', new.id, new.user, new.passwd );
END;

-- =================================================
drop trigger tr_users_before_update;
CREATE TRIGGER "tr_users_Before_Update" before update  ON users
BEGIN
    update users set dtmod = datetime('now') where rowid = old.rowid;
    insert into log_users (  action, userid, user, passwd )
                 values ( 'MOD1', old.id, old.user, old.passwd );
    insert into log_users (  action, userid, user, passwd )
                 values ( 'MOD2', new.id, new.user, new.passwd );
END;

-- =================================================
drop trigger tr_users_Before_Delete;
CREATE TRIGGER "tr_users_Before_Delete" before delete  ON users
BEGIN
    insert into log_users (  action, userid, user, passwd )
                 values ( 'DEL', old.id, old.user, old.passwd );
END;


-- =================================================
CREATE TABLE log_users (
    "id" INTEGER PRIMARY KEY,
    "action" CHAR(4) NOT NULL,
    "userid" INTEGER NOT NULL,
    "user" VARCHAR(20) NOT NULL,
    "passwd" VARCHAR(20),
    "dtmod" DATETIME
);

-- =================================================
drop trigger tr_log_users_After_Insert;
CREATE TRIGGER "tr_log_users_After_Insert" AFTER insert ON log_users
BEGIN
    update log_users set dtmod = datetime('now') where rowid = new.rowid;
END;

-- =================================================

select * from users;
select * from log_users order by id desc;
-- delete from log_users where dtmod is null;

delete from users where user like "gin%";

insert into users ( user, passwd ) values ( 'gino001', 'aaa' );
insert into users ( user, passwd ) values ( 'gino002', 'bbb' );
update users set passwd = '123x' where user = 'enzo';

