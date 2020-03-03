/* Задача 1
Написать cкрипт, добавляющий в БД vk, которую создали на занятии, 3 новые таблицы (с перечнем полей, указанием индексов и внешних ключей)
*/

DROP database IF EXISTS test;
CREATE database test;
use test;

drop table if exists users;
create table users(
	id SERIAL primary key,
	firstname VARCHAR(100),
	lastname VARCHAR(100),
	email VARCHAR(100) unique,
	password_hash VARCHAR(100),
	phone VARCHAR(12),
	
	index users_phone_idx(phone),
	index users_firstname_lastname_idx(firstname,lastname)
);


DROP TABLE IF EXISTS profiles;
CREATE TABLE profiles (
	user_id SERIAL PRIMARY KEY,
    gender CHAR(1),
    birthday DATE,
	photo_id BIGINT UNSIGNED NULL,
    created_at DATETIME DEFAULT NOW(),
    hometown VARCHAR(100)
);


alter table profiles
add constraint fk_user_id
foreign key (user_id) references users(id)
on update cascade 
on delete restrict;


drop table if exists messages;
create table messages(
	id SERIAL primary key,
	from_user_id BIGINT unsigned not null,
	to_user_id BIGINT unsigned not null,
	body text,
	created_at DATETIME default now(),
	
	
	index (from_user_id),
	index(to_user_id),
	foreign key (from_user_id) references users(id),
	foreign key (to_user_id) references users(id)
);

drop table if exists friend_requests;
create table friend_requess(
	initiator_user_id BIGINT unsigned not null,
	target_user_id BIGINT unsigned not null,
	`status` ENUM('requested','approved','unfriended','declined'),
	requested_at datetime default now(),
	updated_at datetime on update current_timestamp,
	
	primary key (initiator_user_id, target_user_id),
	index (initiator_user_id),
	index (target_user_id),
	foreign key (initiator_user_id) references users(id),
	foreign key (target_user_id) references users(id)
);

drop table if exists communties;
create table communities(
	id serial primary key,
	name VARCHAR(200),
	admin_user_id BIGINT unsigned not null,
	
	index (admin_user_id),
	foreign key (admin_user_id) references users(id)
);

drop table if exists user_communites;
create table user_communites(
	user_id bigint unsigned not null,
	community_id bigint unsigned not null,
	
	primary key (user_id, community_id),
	foreign key (user_id) references users(id),
	foreign key (community_id) references communities(id)
);



drop table if exists media_types;
create table media_types(
	id serial primary key,
	name VARCHAR(200)
);


drop table if exists media;
create table media(
	id serial primary key,
	media_type_id bigint unsigned not null,
	user_id bigint unsigned not null,
	body text,
	filename varchar(255),
	`size` int,
	metadata JSON,
	created_at bigint unsigned not null,
	index (user_id),
	foreign key (user_id) references users(id),
	foreign key (media_type_id) references media_types(id)
);


drop table if exists likes;
create table likes(
	id serial primary key,
	user_id bigint unsigned not null,
	media_id bigint unsigned not null,
	created_at datetime default now()
	
);


drop table if exists `photo_albums`;
create table `photo_albums`(
	`id` serial,
	`name` VARCHAR(200),
	`user_id` bigint unsigned not null,
	
	primary key(`id`),
	foreign key (`user_id`) references users(`id`)
);


drop table if exists `photos`;
create table `photos`(
	`id` serial primary key,
	`album_id` bigint unsigned null,
	`media_id` bigint unsigned not null,
	
	
	foreign key (album_id) references photo_albums(id),
	foreign key (media_id) references media(id)
);


-- ==================================================================


drop table if exists songs; 
create table songs(
	id serial primary key,
	filename varchar(255),
	`SIZE` int,
	metadata json,
	author varchar(200),
	name varchar(200), -- изначально планировал связать с таблицей songs_authors, но видимо так нельзя.Не понял как сделать так, чтобы при загрузке аудиозаписи автоматически создавалась строка 'name' в таблицу songs_authors
	lyrics text,
	thumbnail varchar(255),
	owner_id bigint unsigned not null,
	foreign key (owner_id) references users(id),
	index song_author_name_idx (author,name)
);


drop table if exists songs_authors; 
create table songs_authors(
	id serial primary key,
	user_id bigint unsigned not null,
	name varchar(200),
	songs bigint unsigned not null,
	thumbnail varchar(255),
	foreign key (user_id) references users(id),
	foreign key (songs) references songs(id),
	index author_name_idx (name)
);




drop table if exists songs_alubms;
create table songs_alubms(
	id serial primary key,
	name varchar(200),
	author varchar(200),
	songs bigint unsigned not null,
	thumbnail varchar(255),
	description text,
	foreign key (author) references songs(author),
	foreign key (songs) references songs(id),
	index album_name_idx (name)
);







