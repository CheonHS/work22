-- --------------------------------------------------------
-- 호스트:                          127.0.0.1
-- 서버 버전:                        10.9.2-MariaDB - mariadb.org binary distribution
-- 서버 OS:                        Win64
-- HeidiSQL 버전:                  11.3.0.6295
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!50503 SET NAMES utf8mb4 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;


-- work22 데이터베이스 구조 내보내기
CREATE DATABASE IF NOT EXISTS `work22` /*!40100 DEFAULT CHARACTER SET utf8mb3 */;
USE `work22`;

-- 테이블 work22.board 구조 내보내기
CREATE TABLE IF NOT EXISTS `board` (
  `b_idx` int(10) NOT NULL AUTO_INCREMENT,
  `b_title` varchar(255) NOT NULL,
  `b_content` varchar(255) NOT NULL,
  `b_views` int(10) NOT NULL DEFAULT 0,
  `b_date` datetime NOT NULL,
  `u_idx` int(10) NOT NULL,
  `b_group` int(10) NOT NULL,
  `b_order` int(10) NOT NULL,
  `b_depth` int(10) NOT NULL,
  `b_filename` varchar(255) NOT NULL,
  PRIMARY KEY (`b_idx`),
  KEY `u_idx` (`u_idx`),
  CONSTRAINT `board_ibfk_1` FOREIGN KEY (`u_idx`) REFERENCES `user` (`u_idx`) ON DELETE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=17 DEFAULT CHARSET=utf8mb3;

-- 테이블 데이터 work22.board:~11 rows (대략적) 내보내기
/*!40000 ALTER TABLE `board` DISABLE KEYS */;
INSERT IGNORE INTO `board` (`b_idx`, `b_title`, `b_content`, `b_views`, `b_date`, `u_idx`, `b_group`, `b_order`, `b_depth`, `b_filename`) VALUES
	(1, '1', '1', 13, '2022-10-12 19:54:52', 3, 1, 1, 0, ''),
	(2, '2', '2', 3, '2022-10-12 19:54:59', 3, 1, 6, 1, ''),
	(3, '3', '3', 0, '2022-10-12 19:55:11', 3, 1, 5, 1, ''),
	(4, '4', '4', 79, '2022-10-12 19:55:15', 3, 1, 2, 1, ''),
	(5, '5', '5', 7, '2022-10-12 19:55:20', 3, 1, 3, 2, ''),
	(6, '6', '6', 1, '2022-10-12 20:00:01', 3, 1, 4, 3, ''),
	(9, '다른 작성자', '호로로롤', 31, '2022-10-19 00:38:13', 10, 9, 1, 0, ''),
	(13, '11', '1111', 44, '2022-10-30 13:37:59', 3, 13, 1, 0, 'abc.jpg'),
	(14, '123', '11', 1, '2022-10-31 00:10:46', 3, 14, 1, 0, 'abc.jpg'),
	(15, '123', '123', 1, '2022-10-31 00:12:10', 3, 15, 1, 0, 'ttt.jpg'),
	(16, '123123', '123123', 11, '2022-10-31 00:12:37', 3, 16, 1, 0, 'ttt1.jpg');
/*!40000 ALTER TABLE `board` ENABLE KEYS */;

-- 테이블 work22.comment 구조 내보내기
CREATE TABLE IF NOT EXISTS `comment` (
  `c_idx` int(10) NOT NULL AUTO_INCREMENT,
  `c_content` varchar(255) NOT NULL,
  `c_date` datetime NOT NULL,
  `b_idx` int(10) NOT NULL,
  `u_idx` int(10) NOT NULL,
  `c_group` int(10) NOT NULL,
  `c_order` int(10) NOT NULL,
  `c_depth` int(10) NOT NULL,
  PRIMARY KEY (`c_idx`)
) ENGINE=InnoDB AUTO_INCREMENT=20 DEFAULT CHARSET=utf8mb3;

-- 테이블 데이터 work22.comment:~0 rows (대략적) 내보내기
/*!40000 ALTER TABLE `comment` DISABLE KEYS */;
/*!40000 ALTER TABLE `comment` ENABLE KEYS */;

-- 테이블 work22.user 구조 내보내기
CREATE TABLE IF NOT EXISTS `user` (
  `u_idx` int(10) NOT NULL AUTO_INCREMENT,
  `u_id` varchar(255) NOT NULL,
  `u_pw` varchar(255) NOT NULL,
  `u_name` varchar(255) NOT NULL,
  `u_tel` varchar(255) NOT NULL,
  `u_age` varchar(255) NOT NULL,
  `u_level` int(10) NOT NULL,
  PRIMARY KEY (`u_idx`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=47 DEFAULT CHARSET=utf8mb3;

-- 테이블 데이터 work22.user:~10 rows (대략적) 내보내기
/*!40000 ALTER TABLE `user` DISABLE KEYS */;
INSERT IGNORE INTO `user` (`u_idx`, `u_id`, `u_pw`, `u_name`, `u_tel`, `u_age`, `u_level`) VALUES
	(3, 'a', '111', '김땡땡', '010-1111-1111', '20', 9),
	(5, 'ccc', '34343', '강하다', '010-2121-3232', '58', 1),
	(6, 'dfdf', '545', '홍길동', '010-2898-4767', '44', 1),
	(7, 'zyzy', '252d', '대한민국', '010-4747-3634', '88', 1),
	(8, 'a1234', 'bbbb', '만세', '010-8487-7978', '69', 1),
	(9, 'baba', 'cfdfd', '바비', '010-8787-1111', '56', 1),
	(10, 'wew', 'qqqq', '박찬호', '010-7777-3232', '23', 1),
	(11, 'a1', '5555', '강호동', '090-4343-4444', '32', 1),
	(12, 'b1', '1111', '박길동', '090-3333-7777', '49', 1),
	(13, 'bb1', '2222', '고길동', '090-4444-6666', '61', 1);
/*!40000 ALTER TABLE `user` ENABLE KEYS */;

/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IFNULL(@OLD_FOREIGN_KEY_CHECKS, 1) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40111 SET SQL_NOTES=IFNULL(@OLD_SQL_NOTES, 1) */;
