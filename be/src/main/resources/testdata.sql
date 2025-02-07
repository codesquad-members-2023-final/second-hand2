use
test;
create table category
(
    category_id bigint auto_increment primary key,
    name        varchar(45)  not null,
    img_url     varchar(200) not null,
    placeholder varchar(300) not null
);

create table town
(
    town_id  bigint primary key,
    city     varchar(45) not null,
    county   varchar(45) not null,
    district varchar(45) not null
);


create table member_profile
(
    member_profile_id bigint auto_increment
        primary key,
    member_email      varchar(45) not null unique
);


create table member_password
(
    member_password_id bigint auto_increment
        primary key,
    member_password    varchar(128) not null
);


create table member
(
    member_id          bigint auto_increment
        primary key,
    login_name         varchar(45) not null,
    oauth_provider     varchar(45) not null,
    img_url            varchar(200) null,
    member_profile_id  bigint      not null unique,
    member_password_id bigint null,
    main_town_id       bigint null,
    sub_town_id        bigint null,
    constraint member_profile_id1
        foreign key (member_profile_id) references member_profile (member_profile_id),
    constraint member_password_id1
        foreign key (member_password_id) references member_password (member_password_id),
    constraint fk_member_town1
        foreign key (main_town_id) references town (town_id),
    constraint fk_member_town2
        foreign key (sub_town_id) references town (town_id)
);


create table member_token
(
    member_token_id bigint auto_increment
        primary key,
    member_id       bigint       not null,
    member_token    varchar(500) not null,
    constraint fk_member_id1
        foreign key (member_id) references member (member_id)
);

create table product
(
    product_id    bigint auto_increment
        primary key,
    title         varchar(45)  not null,
    content       text         not null,
    price         int null,
    status        varchar(45)  not null default 'SELLING',
    created_at    datetime NULL DEFAULT CURRENT_TIMESTAMP,
    count_view    smallint              default 0,
    count_like    smallint              default 0,
    thumbnail_url varchar(200) not null,
    town_id       bigint       not null,
    category_id   bigint       not null,
    member_id     bigint       not null,
    deleted       tinyint(1) not null default 0,
    constraint fk_product_category1
        foreign key (category_id) references category (category_id),
    constraint fk_product_member1
        foreign key (member_id) references member (member_id),
    constraint fk_product_town1
        foreign key (town_id) references town (town_id)
);

create table interested
(
    interested_id bigint auto_increment primary key,
    product_id    bigint not null,
    member_id     bigint not null,
    is_liked      tinyint(1) not null,
    constraint fk_interested_member1
        foreign key (member_id) references member (member_id),
    constraint fk_interested_product1
        foreign key (product_id) references product (product_id)
);

create table product_img
(
    product_img_id bigint auto_increment primary key,
    img_url        varchar(200) not null,
    product_id     bigint null,
    constraint fk_product_img_product
        foreign key (product_id) references product (product_id)
);

create table chat_room
(
    id              bigint auto_increment primary key,
    chat_room_id    binary(16) not null unique,
    product_id      bigint   not null,
    seller_id       bigint   not null,
    customer_id     bigint   not null,
    created_at      datetime not null,
    chatroom_status enum('EMPTY', 'SELLER_ONLY', 'CUSTOMER_ONLY', 'FULL') default 'FULL' null
);

