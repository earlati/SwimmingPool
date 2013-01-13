use enarl7_swim;

select * from users;
delete from users where email is null;
update users set enabled = 1 where user = 'enzo';

SELECT * FROM `enzarl7_swim`.`session_connect`;

insert into session_connect ( date, id_user, hash_code ) 
  values( current_timestamp, 22, "aaaaaaxxxxx" );

ALTER TABLE `enzarl7_swim`.`session_connect` CHANGE COLUMN `id` `id` INT(11) NOT NULL AUTO_INCREMENT  ;


grant all privileges on enzarl7_swim.*  
to 'enzarl7_swim'@'enzo7' identified by 'xxxxxxxxx'
with grant option;

grant all privileges on zeoslib.* to zeos@'%' identified by 'xxxxxxxxxx';


DELETE FROM remote_cmd where dt_expire < now()  limit 10;

select * from remote_cmd order by dt_mod desc;

select last_insert_id() lastid ;

ALTER TABLE remote_cmd ADD COLUMN enabled_user INT  DEFAULT 0  AFTER id_user ;

select * from users;
select * from user_profile;
select * from remote_cmd;
select * from session_connect;

select * from users where email = 'enzo@enzo7.localdomain';

update users set pwd = '';
commit;