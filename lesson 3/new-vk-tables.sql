
create database snet0409;
use snet0409;

drop table if exists users;
create table users(
	id serial primary key,
    email varchar(120) not null unique,
    phone varchar(15) not null,
    pass varchar(200) not null,
    created_at datetime default current_timestamp,
    visible_for enum('all', 'frends_of_friends', 'friends') default 'all',
    can_comment bool,
    can_message enum('all', 'frends_of_friends', 'friends') default 'all',
    invite_to_community enum('all', 'frends_of_friends', 'friends') default 'all'
);

drop table if exists profiles;
create table profiles(
	user_id serial primary key,
    name varchar(255) not null,
    lastname varchar(255) not null,
    gender char(1) not null,
    birthday date,
    photo_id bigint unsigned not null,
    foreign key(user_id) references users(id)
);

-- добавили индексы 
alter table profiles add index(name);
alter table profiles add index(lastname);



alter table profiles change column photo_id photo_id bigint unsigned null;

drop table if exists friend_requests;
create table friend_requests(
	initiator_user_id bigint unsigned not null,
    target_user_id bigint unsigned not null,
    status enum('requested', 'approved', 'unfriended', 'decline') default 'requested',
    requested_at datetime default current_timestamp,
    updated_at datetime,
    primary key(initiator_user_id, target_user_id),
    key `friend_request_iui_idx` (initiator_user_id),
    key(target_user_id),
    constraint `friend_requests_fk1` foreign key(initiator_user_id) references profiles(user_id),
    foreign key(target_user_id) references profiles(user_id)
);

drop table if exists messages;
create table messages(
	id serial,
    from_user_id bigint unsigned not null,
    to_user_id bigint unsigned not null,
    body text,
    is_read bool,
    created_at datetime default current_timestamp,
    primary key(id),
    foreign key(from_user_id) references profiles(user_id),
    foreign key(to_user_id) references profiles(user_id)
);

drop table if exists posts;
create table posts(
	id serial primary key,
    user_id bigint unsigned not null,
    body text,
    attachments json,
    metadata json,
    created_at datetime default current_timestamp,
    updated_at datetime default current_timestamp on update current_timestamp,
    foreign key (user_id) references profiles(user_id)
);

drop table if exists comments;
create table comments(
	id serial primary key,
    user_id bigint unsigned not null,
    post_id bigint unsigned not null,
    body text,
    created_at datetime default current_timestamp,
    updated_at datetime default current_timestamp on update current_timestamp,
    foreign key (user_id) references profiles(user_id),
    foreign key (post_id) references posts(id)
);

drop table if exists photos;
create table photos(
	id serial primary key,
    file varchar(255),
    user_id bigint unsigned not null,
    description text,
    created_at datetime default current_timestamp,
    updated_at datetime default current_timestamp on update current_timestamp,
    foreign key(user_id) references profiles(user_id)
);

drop table if exists communities;
create table communities(
	id serial primary key,
    name varchar(255),
    key(name)
);

drop table if exists users_communities;
create table users_communities(
	community_id bigint unsigned not null,
    user_id bigint unsigned not null,
    is_admin bool,
    primary key(community_id, user_id),
    foreign key (user_id) references profiles(user_id),
    foreign key(community_id) references communities(id)
);  

drop table if exists likes;
create table likes(
	id bigint unsigned not null, -- id оставлю, вдруг будет возможность отслеживать того, кто поставил лайк) 
    like_photo_id bigint unsigned not null,
    like_comment_id bigint unsigned not null,
    like_post_id bigint unsigned not null,
    like_message_id bigint unsigned not null,
    like_count bigint unsigned not null, -- колличесто лайков
    foreign key(like_photo_id) references photos(id), -- чтобы было возможно лайкать фотографии 
    foreign key(like_comment_id) references comments(id), -- чтобы было возможно лайкать комментарии
    foreign key(like_post_id) references posts(id), -- чтобы было возможно лайкать посты
    foreign key(like_message_id) references messages(id) -- чтобы было возможно лайкать сообщения(как в инстаграмме)
);

