-- phpMyAdmin SQL Dump
-- version 4.4.15.9
-- https://www.phpmyadmin.net
--
-- Host: localhost
-- Generation Time: Oct 07, 2022 at 03:30 PM
-- Server version: 5.6.37
-- PHP Version: 5.6.31

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `Skedulee`
--

-- --------------------------------------------------------

--
-- Table structure for table `employee_t`
--

CREATE TABLE IF NOT EXISTS `employee_t` (
  `employee_id` int(10) NOT NULL,
  `full_name` char(30) NOT NULL,
  `employee_email` varchar(30) NOT NULL,
  `wage_salary` char(15) NOT NULL,
  `phone_number` char(15) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `location_t`
--

CREATE TABLE IF NOT EXISTS `location_t` (
  `store_id` int(5) NOT NULL,
  `country` char(20) NOT NULL,
  `state` char(20) NOT NULL,
  `city` char(40) NOT NULL,
  `zip` int(10) NOT NULL,
  `owner` char(20) NOT NULL,
  `store_address` char(40) NOT NULL,
  `phone` int(10) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `notes_t`
--

CREATE TABLE IF NOT EXISTS `notes_t` (
  `employee_id` int(10) NOT NULL,
  `description` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `position_t`
--

CREATE TABLE IF NOT EXISTS `position_t` (
  `position` char(15) NOT NULL,
  `description` varchar(255) NOT NULL,
  `permissions` int(10) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `shift_t`
--

CREATE TABLE IF NOT EXISTS `shift_t` (
  `shift_id` int(10) NOT NULL,
  `employee_id` int(10) NOT NULL,
  `position` char(15) NOT NULL,
  `store_id` int(5) NOT NULL,
  `date` date NOT NULL,
  `timeslot` char(10) NOT NULL,
  `attendence` char(6) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `user_t`
--

CREATE TABLE IF NOT EXISTS `user_t` (
  `username` varchar(25) NOT NULL,
  `employee_id` int(10) NOT NULL,
  `password` varchar(25) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `employee_t`
--
ALTER TABLE `employee_t`
  ADD PRIMARY KEY (`employee_id`);

--
-- Indexes for table `location_t`
--
ALTER TABLE `location_t`
  ADD PRIMARY KEY (`store_id`);

--
-- Indexes for table `notes_t`
--
ALTER TABLE `notes_t`
  ADD PRIMARY KEY (`employee_id`);

--
-- Indexes for table `position_t`
--
ALTER TABLE `position_t`
  ADD PRIMARY KEY (`position`);

--
-- Indexes for table `shift_t`
--
ALTER TABLE `shift_t`
  ADD PRIMARY KEY (`shift_id`),
  ADD KEY `shift_fk` (`employee_id`),
  ADD KEY `shift_fk1` (`position`),
  ADD KEY `shift_fk2` (`store_id`);

--
-- Indexes for table `user_t`
--
ALTER TABLE `user_t`
  ADD PRIMARY KEY (`username`),
  ADD KEY `user_fk` (`employee_id`);

--
-- Constraints for dumped tables
--

--
-- Constraints for table `notes_t`
--
ALTER TABLE `notes_t`
  ADD CONSTRAINT `notes_fk` FOREIGN KEY (`employee_id`) REFERENCES `employee_t` (`employee_id`);

--
-- Constraints for table `shift_t`
--
ALTER TABLE `shift_t`
  ADD CONSTRAINT `shift_fk` FOREIGN KEY (`employee_id`) REFERENCES `employee_t` (`employee_id`),
  ADD CONSTRAINT `shift_fk1` FOREIGN KEY (`position`) REFERENCES `position_t` (`position`),
  ADD CONSTRAINT `shift_fk2` FOREIGN KEY (`store_id`) REFERENCES `location_t` (`store_id`);

--
-- Constraints for table `user_t`
--
ALTER TABLE `user_t`
  ADD CONSTRAINT `user_fk` FOREIGN KEY (`employee_id`) REFERENCES `employee_t` (`employee_id`);

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
