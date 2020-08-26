use `snet0409-data`;

select * from users;

drop table if exists `like-information`;
create table `like-information`(
	id bigint unsigned not null,
    like_photo_id bigint unsigned not null,
    like_comment_id bigint unsigned not null,
    like_post_id bigint unsigned not null,
    like_message_id bigint unsigned not null,
    like_count bigint unsigned not null
);

insert into `like-information` (id, like_photo_id, like_comment_id, like_post_id,  like_message_id, like_count)
select id, like_photo_id, like_comment_id, like_post_id,  like_message_id, like_count from likes where id < 50;

select * from `like-information`;
select * from `like-information` order by id;
select * from `like-information` order by like_post_id;

select distinct id from `like-information`;
select distinct id, like_photo_id, like_comment_id, like_post_id,  like_message_id, like_count from `like-information`;

select * from `like-information` order by id between 23 and 78;

select count(like_count) from `like-information` group by id;

drop table if exists requests_information;
create table requests_information(
	initiator_user_id bigint unsigned not null,
    target_user_id bigint unsigned not null,
    status enum('requested', 'approved', 'unfriended', 'decline') default 'requested',
    requested_at datetime default current_timestamp,
    updated_at datetime
);

show tables;

insert into requests_information(initiator_user_id, target_user_id, status, requested_at, updated_at)
select initiator_user_id, target_user_id, status, requested_at, updated_at from friend_requests where initiator_user_id and target_user_id > 80;
select * from requests_information;
select * from requests_information order by initiator_user_id;

select initiator_user_id, target_user_id from requests_information where requested_at >= '2002-10-21 00:58:36' and requested_at <= '2019-04-06 05:36:34';
select * from requests_information where requested_at >= '2002-10-21 00:58:36' and requested_at <= '2019-04-06 05:36:34';



drop table if exists messages_information;
create table messages_information(
	id bigint unsigned not null,
    from_user_id bigint unsigned not null,
    to_user_id bigint unsigned not null,
    body text,
    is_read bool,
    created_at datetime default current_timestamp
);

insert into messages_information (id, from_user_id, to_user_id, body, is_read, created_at)
select id, from_user_id, to_user_id, body, is_read, created_at from messages where created_at between '1990-08-03 10:11:47' and '2000-04-03 00:57:11';
select * from messages_information;

SET SQL_SAFE_UPDATES = 0;

update messages_information
set is_read = 0 
where id between 40 and 80;
select * from messages_information order by is_read;

select * from messages_information where body like '%epudianda%';
select count(body) from messages_information;

select max(to_user_id) from messages_information;
select min(to_user_id) from messages_information;

select sum(to_user_id and from_user_id) from messages_information;
select sum(is_read) from messages_information;



drop table if exists users_information;
create table users_information(
	id bigint unsigned not null,
    email varchar(120) not null unique,
    phone varchar(15) not null,
    pass varchar(200) not null,
    created_at datetime default current_timestamp,
    visible_for enum('all', 'frends_of_friends', 'friends') default 'all',
    can_comment bool,
    can_message enum('all', 'frends_of_friends', 'friends') default 'all',
    invite_to_community enum('all', 'frends_of_friends', 'friends') default 'all'
);

insert into users_information(id, email, phone, pass)
select id, email, phone, pass from users where phone like '%99%';
select * from users_information;

select email , count(pass) as password_sum from users group by email;
