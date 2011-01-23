-- phpMyAdmin SQL Dump
-- version 3.3.2deb1
-- http://www.phpmyadmin.net
--
-- Host: localhost
-- Generation Time: Jan 23, 2011 at 08:39 PM
-- Server version: 5.1.41
-- PHP Version: 5.3.2-1ubuntu4.7


--
-- Database: `testf`
--

-- --------------------------------------------------------

--
-- Table structure for table `Test`
--

CREATE TABLE IF NOT EXISTS `Test` (
  `ip` char(20) NOT NULL,
  `version` varchar(5) NOT NULL,
  `result` text NOT NULL
) TYPE=InnoDB COMMENT='Storing all the tests';

