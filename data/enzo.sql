use enarl7_swim;

select * from users;
delete from users where email is null;
update users set enabled = 1 where user = 'enzo';

SELECT * FROM `enzarl7_swim`.`session_connect`;

insert into session_connect ( date, id_user, hash_code ) 
  values( current_timestamp, 22, "aaaaaaxxxxx" );

ALTER TABLE `enzarl7_swim`.`session_connect` CHANGE COLUMN `id` `id` INT(11) NOT NULL AUTO_INCREMENT  ;


grant all privileges on enzarl7_swim.*  
to 'enzarl7_swim'@'enzo7' identified by 'davidone'
with grant option;

grant all privileges on zeoslib.* to zeos@'%' identified by 'davidone';

insert into location ( name ) values ( 'Milano' );
select last_insert_id() lastid, l.* from location l;

insert into users ( user ) values ( 'Pino' );
select last_insert_id() lastid, u.*  from users u;

select last_insert_id();

DELETE FROM remote_cmd 
WHERE email = 'enzo.arlati@libero.it' and command = 'resetPwd';

DELETE FROM remote_cmd where dt_expire < now()  limit 10;

select * from remote_cmd order by dt_mod desc;

INSERT INTO remote_cmd (`command`, `email`,`dt_mod`,`dt_expire`)
VALUES ( 'resetPwd', 'enzo.arlati@libero.it', 
         now(), 
         date_add( now(), interval 3 day ) );



