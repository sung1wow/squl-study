CREATE TABLE dept(NO INT PRIMARY KEY,NAME VARCHAR(10), tel VARCHAR(15),inwon INT,addr TEXT) CHARSET=UTF8; -- 테이블 생성

--자료 추가
# insert into 테이블명 (칼럼명,...) values(입력자료,...)
INSERT INTO dept(NO,NAME,tel,inwon,addr) VALUES(1,'인사과','111-1111',3,'삼성동12');
INSERT INTO dept VALUES(2,'영업과','111-2222',5,'서초동12');
INSERT INTO dept(NO,NAME) VALUES(3,'자재과');
INSERT INTO dept(NO,addr,tel,NAME) VALUES(4,'역삼2동33','111-5555','자재2과');

INSERT INTO dept VALUES(5,'판매과');  -- err : 입력자료와 칼럼갯수 불일치
INSERT INTO dept(NAME, tel) VALUES('판매과2','111-6666');  -- err NO:pk, 생략 불가
INSERT INTO dept(NO,NAME) VALUES(5,'판매과부서는 사람들이 좋아 일하기 좋은 우수한 부서임');  -- err : 자릿수 넘침(varchar(10)넘음)
SELECT * FROM dept;
SELECT * FROM dept WHERE NO=1;


-- 자료 수정
-- update 테이블명 set 수정칼럼명=수정값,... where 조건 <== 수정 대상 칼럼을 지정
-- pk 칼럼의 자료는 수정 대상에서 제외
UPDATE dept SET tel='123-4567' WHERE NO=2;
UPDATE dept SET addr='압구정동33',inwon=7, tel='777-8888' WHERE NO=3;
SELECT * FROM dept;

-- 자료 삭제
-- delete from 테이블명 where 조건	     -- 전체 또는 부분적 레코드 삭제 가능
-- truncate table 테이블명		--  where 조건을 사용X,  전체 레코드 삭제 가능
delete FROM dept WHERE NAME='자재2과';
TRUNCATE TABLE dept;
SELECT * FROM dept;

DROP TABLE dept;   -- 테이블 자체(구조, 자료)가 제거됨


-- 무결성 제약조건
-- : 테이블 생성시 잘못된 자료 입력을 막고자 다양한 입력 제한 조건을 줄 수 있다.
-- 1) 기본키 제약 : primary key(pk) 사용, 중복 레코드 입력 방지
CREATE TABLE aa(bun INT PRIMARY KEY, irum CHAR(10));
SELECT * FROM information_schema.TABLE_CONSTRAINTS WHERE TABLE_NAME='aa';   -- 참고용임 외우지는 말기 
INSERT INTO aa VALUES(1,'tom');
INSERT INTO aa VALUES(2,'tom');
INSERT INTO aa VALUES(2,'tom');          -- err primary key 는 유일해야 함, 같은 값 또 넣으면 오류 발생
INSERT INTO aa(irum) VALUES('tom');      -- err bun 이 primary key 인데 입력 안 함.
INSERT INTO aa(bun) VALUES('3');
SELECT * FROM aa;
DROP TABLE aa;

CREATE TABLE aa(bun INT, irum CHAR(10), CONSTRAINT aa_bun_pk PRIMARY KEY(bun));
INSERT INTO aa VALUES(1,'tom');
SELECT * FROM aa;
DROP TABLE aa;

-- 2) check 제약 : 입력 자료의 특정 칼럼값 조건 검사
CREATE TABLE aa(bun INT, nai INT CHECK(nai >= 20));
INSERT INTO aa VALUES(1,23);
INSERT INTO aa VALUES(2,13);   -- err 20보다 작으므로
SELECT * FROM aa;
DROP TABLE aa;

-- 3) unique 제약 : 특정 칼럼값 중복 불허
CREATE TABLE aa(bun INT, irum CHAR(10) NOT NULL UNIQUE);
INSERT INTO aa VALUES(1,'tom');
INSERT INTO aa VALUES(2,'john');
INSERT INTO aa VALUES(3,'john');    -- err 나왔던거 중복 되는거 안 됨
SELECT * FROM aa;
DROP TABLE aa;

-- 4) FOREIGN KEY(fk), 외부키, 참조키 제약. 특정 칼럼이 다른 테이블의 칼럼을 참조
-- fk 대상은 pk 다!!!
CREATE TABLE jikwon(bun INT PRIMARY KEY, irum VARCHAR(10) NOT NULL, 
buser CHAR(10) NOT NULL);
INSERT INTO jikwon VALUES(1,'한송이','인사과');
INSERT INTO jikwon VALUES(2,'이기자','인사과');
INSERT INTO jikwon VALUES(3,'한송이','판매과');
SELECT * FROM jikwon;

CREATE TABLE gajok(CODE INT PRIMARY KEY, NAME VARCHAR(10) NOT NULL,
birth DATETIME,jikwonbun INT,FOREIGN KEY(jikwonbun) REFERENCES jikwon(bun));
INSERT INTO gajok VALUES(10,'한가해','2015-05-12',3);
INSERT INTO gajok VALUES(20,'공기밥','2011-12-12',2);
INSERT INTO gajok VALUES(30,'김밥','2013-12-12',5);    -- err 
INSERT INTO gajok VALUES(30,'심심해','2010-05-12',3);
SELECT * FROM gajok;

DELETE FROM jikwon WHERE bun=1;
DELETE FROM jikwon WHERE bun=3;      -- 참조 자료(가족)가 있으므로 삭제 불가
DROP TABLE jikwon;          -- err 마찬가지로 참조 자료가 있으므로 삭제 불가
DELETE FROM gajok WHERE jikwonbun=2;   -- 1) 참조키(pk가 2번)인 가족자료 삭제
DELETE FROM jikwon WHERE bun=2;         -- 2) 참조 가족이 없으므로 2번 직원 삭제 가능
SELECT * FROM jikwon;

-- 참고
-- CREATE TABLE gajok(CODE INT PRIMARY KEY, ...) on delete cascade (이건 무작정 다 없애는 거라서 잘 안 씀)
-- 직원자료를 삭제하면 관련있는 가족자료도 함께 삭제 가능
DROP TABLE gajok;
DROP TABLE jikwon;

-- default : 특정 칼럼에 초기치 부여. null 예방
CREATE TABLE aa(bun INT AUTO_INCREMENT PRIMARY KEY, 
juso CHAR(20) DEFAULT '강남구 역삼동');   -- AUTO_INCREMENT : bun 자동 증가
INSERT INTO aa VALUES(1,'서초구 서초2동');
INSERT INTO aa(juso) VALUES('서초구 서초3동');
INSERT INTO aa(juso) VALUES('서초구 서초4동');
INSERT INTO aa(bun) VALUES(5);
INSERT INTO aa(bun) VALUES(6);
SELECT * FROM aa;
DROP TABLE aa;




-- 혼자 풀어 보기 --

CREATE TABLE 교수(교수코드 INT PRIMARY KEY, 교수명 VARCHAR(10), 
연구실 INT CHECK(100<= 연구실 AND 500>=연구실));
INSERT INTO 교수 VALUES(15,'김교수',140);
INSERT INTO 교수 VALUES(364,'홍길동',280);
INSERT INTO 교수 VALUES(223,'석박사',337);
-- INSERT INTO 교수 VALUES(2,'나교수',50);    -- err 50 이므로 에러발생
SELECT * FROM 교수;
-- DROP TABLE 교수;


CREATE TABLE 과목(과목코드 INT PRIMARY KEY AUTO_INCREMENT, 과목명 VARCHAR(10) UNIQUE, 교재명 VARCHAR(10) NOT NULL, 
담당교수 INT, FOREIGN KEY(담당교수) REFERENCES 교수(교수코드));
INSERT INTO 과목 VALUES(NULL,'수학','수학의정석',15);
INSERT INTO 과목 VALUES(NULL,'코딩','코딩은쉽다',364);
INSERT INTO 과목 VALUES(NULL,'과학','과학일기',223);
SELECT * FROM 과목;
-- DROP TABLE 과목;


CREATE TABLE 학생(학번 INT PRIMARY KEY, 학생명 VARCHAR(10), 
수강과목 INT, FOREIGN KEY(수강과목) REFERENCES 과목(과목코드), 학년 INT DEFAULT 1 CHECK (1 <= 학년 AND 4 >= 학년));
INSERT INTO 학생(학번, 학생명, 수강과목) VALUES(26196, '장성원',1);
INSERT INTO 학생 VALUES(80206, '장학생',2,3);
INSERT INTO 학생 VALUES(37551, '국민생',3,2);
SELECT * FROM 학생;
-- DROP TABLE 학생;

-- index (색인) : 검색 속도 향상을 위해 특정 column에 색인 부여 가능
-- pk column은 자동으로 인덱싱됨(ascending sort : 오름차순 정렬)
-- index를 자제해야 하는 경우 : 입력, 수정, 삭제 등의 작업이 빈번한 경우
CREATE TABLE aa(bun INT PRIMARY KEY, irum VARCHAR(10) NOT NULL, juso VARCHAR(50));
INSERT INTO aa VALUES(1,'신선해','테헤란로111');
ALTER TABLE aa ADD INDEX ind_juso(juso);   -- juso column에 인덱스 부여
SELECT * FROM aa;
EXPLAIN SELECT * FROM aa; 
DESC aa;
SHOW INDEX FROM aa;
ALTER TABLE aa DROP INDEX ind_juso;
SHOW INDEX FROM aa;
DROP TABLE aa;


-- 테이블 관련 주요 명령
-- CREATE table 테이블명 ...
-- ALTER table 테이블명 ...
-- DROP table 테이블명 ...
CREATE TABLE aa(bun INT, irum VARCHAR(10),  juso VARCHAR(50));
INSERT INTO aa VALUES(1,'tom','seoul');
SELECT * FROM aa;

ALTER TABLE aa RENAME kbs;   -- 테이블명 변경
SELECT * FROM aa;
ALTER TABLE kbs RENAME aa;

-- 칼럼 관련 명령
ALTER TABLE aa ADD (job_id INT DEFAULT 10);   -- 칼럼 추가
SELECT * FROM aa;
ALTER TABLE aa CHANGE job_id job_num INT;     -- 칼럼 수정 (이름이나 성격 변경)
SELECT * FROM aa;
ALTER TABLE aa MODIFY job_num VARCHAR(10);    -- 칼럼 성격 변경
DESC aa;

ALTER TABLE aa DROP COLUMN job_num;
DESC aa;


-- ---------------------------------------------------------------------------------------
create table sangdata(
code int primary key,
sang varchar(20),
su int,
dan int);
insert into sangdata values(1,'장갑',3,10000);
insert into sangdata values(2,'벙어리장갑',2,12000);
insert into sangdata values(3,'가죽장갑',10,50000);
insert into sangdata values(4,'가죽점퍼',5,650000);

SELECT * FROM sangdata;


create table buser(
buserno int primary key, 
busername varchar(10) not null,
buserloc varchar(10),
busertel varchar(15));

insert into buser values(10,'총무부','서울','02-100-1111');
insert into buser values(20,'영업부','서울','02-100-2222');
insert into buser values(30,'전산부','서울','02-100-3333');
insert into buser values(40,'관리부','인천','032-200-4444');

SELECT * FROM buser;


create table jikwon(
jikwonno int primary key,
jikwonname varchar(10) not null,
busernum int not null,
jikwonjik varchar(10) default '사원', 
jikwonpay int,
jikwonibsail date,
jikwongen varchar(4),
jikwonrating char(3),
CONSTRAINT ck_jikwongen check(jikwongen='남' or jikwongen='여'));

insert into jikwon values(1,'홍길동',10,'이사',9900,'2008-09-01','남','a');
insert into jikwon values(2,'한송이',20,'부장',8800,'2010-01-03','여','b');
insert into jikwon values(3,'이순신',20,'과장',7900,'2010-03-03','남','b');
insert into jikwon values(4,'이미라',30,'대리',4500,'2014-01-04','여','b');
insert into jikwon values(5,'이순라',20,'사원',3000,'2017-08-05','여','b');
insert into jikwon values(6,'김이화',20,'사원',2950,'2019-08-05','여','c');
insert into jikwon values(7,'김부만',40,'부장',8600,'2009-01-05','남','a');
insert into jikwon values(8,'김기만',20,'과장',7800,'2011-01-03','남','a');
insert into jikwon values(9,'채송화',30,'대리',5000,'2013-03-02','여','a');
insert into jikwon values(10,'박치기',10,'사원',3700,'2016-11-02','남','a');
insert into jikwon values(11,'김부해',30,'사원',3900,'2016-03-06','남','a');
insert into jikwon values(12,'박별나',40,'과장',7200,'2011-03-05','여','b');
insert into jikwon values(13,'박명화',10,'대리',4900,'2013-05-11','남','a');
insert into jikwon values(14,'박궁화',40,'사원',3400,'2016-01-15','여','b');
insert into jikwon values(15,'채미리',20,'사원',4000,'2016-11-03','여','a');
insert into jikwon values(16,'이유가',20,'사원',3000,'2016-02-01','여','c');
insert into jikwon values(17,'한국인',10,'부장',8000,'2006-01-13','남','c');
insert into jikwon values(18,'이순기',30,'과장',7800,'2011-11-03','남','a');
insert into jikwon values(19,'이유라',30,'대리',5500,'2014-03-04','여','a');
insert into jikwon values(20,'김유라',20,'사원',2900,'2019-12-05','여','b');
insert into jikwon values(21,'장비',20,'사원',2950,'2019-08-05','남','b');
insert into jikwon values(22,'김기욱',40,'대리',5850,'2013-02-05','남','a');
insert into jikwon values(23,'김기만',30,'과장',6600,'2015-01-09','남','a');
insert into jikwon values(24,'유비',20,'대리',4500,'2014-03-02','남','b');
insert into jikwon values(25,'박혁기',10,'사원',3800,'2016-11-02','남','a');
insert into jikwon values(26,'김나라',10,'사원',3500,'2016-06-06','남','b');
insert into jikwon values(27,'박하나',20,'과장',5900,'2012-06-05','여','c');
insert into jikwon values(28,'박명화',20,'대리',5200,'2013-06-01','여','a');
insert into jikwon values(29,'박가희',10,'사원',4100,'2016-08-05','여','a');
insert into jikwon values(30,'최미숙',30,'사원',4000,'2015-08-03','여','b');

SELECT * FROM jikwon;


create table gogek(
gogekno int primary key,
gogekname varchar(10) not null,
gogektel varchar(20),
gogekjumin char(14),
gogekdamsano int,
CONSTRAINT FK_gogekdamsano foreign key(gogekdamsano) references jikwon(jikwonno));

insert into gogek values(1,'이나라','02-535-2580','850612-1156777',5);
insert into gogek values(2,'김혜순','02-375-6946','700101-1054777',3);
insert into gogek values(3,'최부자','02-692-8926','890305-1065777',3);
insert into gogek values(4,'김해자','032-393-6277','770412-2028777',13);
insert into gogek values(5,'차일호','02-294-2946','790509-1062777',2);
insert into gogek values(6,'박상운','032-631-1204','790623-1023777',6);
insert into gogek values(7,'이분','02-546-2372','880323-2558777',2);
insert into gogek values(8,'신영래','031-948-0283','790908-1063777',5);
insert into gogek values(9,'장도리','02-496-1204','870206-2063777',4);
insert into gogek values(10,'강나루','032-341-2867','780301-1070777',12);
insert into gogek values(11,'이영희','02-195-1764','810103-2070777',3);
insert into gogek values(12,'이소리','02-296-1066','810609-2046777',9);
insert into gogek values(13,'배용중','02-691-7692','820920-1052777',1);
insert into gogek values(14,'김현주','031-167-1884','800128-2062777',11);
insert into gogek values(15,'송운하','02-887-9344','830301-2013777',2);

SELECT * FROM gogek;





