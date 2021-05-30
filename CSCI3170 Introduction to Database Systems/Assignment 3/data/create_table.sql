drop table SUPPORT;
drop table SPONSORS;
drop table LEAGUES;
drop table TEAMS;
drop table REGIONS;

create table SPONSORS(
    SID			Integer,
    SPONSOR_NAME	varchar2(30),
    MARKET_VALUE	Float,
    Primary Key (SID)
);

create table TEAMS(
    TID			Integer,
    TEAM_NAME		varchar2(30),
    AVERAGE_AGE		Float,
    Primary Key (TID)
);

create table REGIONS(
    RID			Integer,
    REGION_NAME	varchar2(30),
    FOOTBALL_RANKING	Integer,
    Primary Key (RID)
);

create table LEAGUES(
    LID			Integer,
    LEAGUE_NAME		varchar2(30),
    CHAMPION_TID	Integer,
    YEAR		Integer,
    SEASON		varchar2(10),
    RID			Integer,
    Primary Key (LID),
    FOREIGN KEY(CHAMPION_TID) REFERENCES TEAMS(TID),
    FOREIGN KEY(RID) REFERENCES REGIONS(RID)
);

create table SUPPORT(
    LID			Integer,
    SID			Integer,
    SPONSORSHIP		Float,
    Primary Key (LID, SID),
    FOREIGN KEY(LID) REFERENCES LEAGUES(LID),
    FOREIGN KEY(SID) REFERENCES SPONSORS(SID)
);
