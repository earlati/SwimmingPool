use enarl7_swim;

select * from users;

SELECT * FROM `enzarl7_swim`.`session_connect`;

insert into session_connect ( date, id_user, hash_code ) 
  values( current_timestamp, 22, "aaaaaaxxxxx" );

ALTER TABLE `enzarl7_swim`.`session_connect` CHANGE COLUMN `id` `id` INT(11) NOT NULL AUTO_INCREMENT  ;
