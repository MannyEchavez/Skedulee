-- phpMyAdmin SQL Dump
-- version 4.4.15.9
-- https://www.phpmyadmin.net
--
-- Host: localhost
-- Generation Time: Oct 12, 2022 at 07:11 PM
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
  `first_name` char(30) NOT NULL,
  `last_name` char(30) NOT NULL,
  `employee_email` varchar(30) NOT NULL,
  `wage_salary` double NOT NULL,
  `phone_number` char(12) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `employee_t`
--

INSERT INTO `employee_t` (`employee_id`, `first_name`, `last_name`, `employee_email`, `wage_salary`, `phone_number`) VALUES
(0, 'Richard', 'Block', 'rblock@gmail.com', 23.45, '777-777-7777'),
(1, 'Mark', 'Hamelton', 'markHam@comcast.net', 14.32, '111-425-1642'),
(2, 'Tom', 'Lincoln', 'lincoln@yahoo.com', 13.78, '622-754-7292'),
(3, 'Leo', 'Haveth', 'leo@hotmail.com', 14.98, '936-279-1484'),
(4, 'Ben', 'Greg', 'bg@comcast.net', 13.55, '726-325-5162'),
(5, 'Robert', 'Toff', 'toffu@gmail.com', 24.01, '856-853-0909'),
(6, 'Ronald', 'Hearth', 'ronald@comcast.net', 30.46, '858-526-7346');

-- --------------------------------------------------------

--
-- Table structure for table `location_t`
--

CREATE TABLE IF NOT EXISTS `location_t` (
  `store_id` int(5) NOT NULL,
  `country` char(20) NOT NULL,
  `state` char(20) NOT NULL,
  `city` char(40) NOT NULL,
  `store_address` char(40) NOT NULL,
  `zip` int(10) NOT NULL,
  `owner` char(20) NOT NULL,
  `phone` char(12) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `location_t`
--

INSERT INTO `location_t` (`store_id`, `country`, `state`, `city`, `store_address`, `zip`, `owner`, `phone`) VALUES
(0, 'United States', 'New York', 'New York City', '101 Wall Street', 10005, 'Ronald Hearth', '214-748-3647'),
(1, 'United States', 'California', 'Wilmington', '22 Default Rd', 90744, 'Ronald Hearth', '111-111-1111');

-- --------------------------------------------------------

--
-- Table structure for table `notes_t`
--

CREATE TABLE IF NOT EXISTS `notes_t` (
  `employee_id` int(10) NOT NULL,
  `description` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `notes_t`
--

INSERT INTO `notes_t` (`employee_id`, `description`) VALUES
(1, 'Came in late on 2022/10/8');

-- --------------------------------------------------------

--
-- Table structure for table `position_t`
--

CREATE TABLE IF NOT EXISTS `position_t` (
  `position` char(15) NOT NULL,
  `description` varchar(255) NOT NULL,
  `permissions` int(10) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `position_t`
--

INSERT INTO `position_t` (`position`, `description`, `permissions`) VALUES
('As.Manager', 'Assist the manager in running the restaurant and make sure both customers and employees are happy.', 1),
('Cashier', 'Take orders and run the cash registers.', 3),
('Cook', 'Cook food for customers.', 3),
('Manager', 'Run the store and ensure all employees and customers are happy.', 0);

-- --------------------------------------------------------

--
-- Table structure for table `role_t`
--

CREATE TABLE IF NOT EXISTS `role_t` (
  `role_id` int(10) NOT NULL,
  `employee_id` int(10) NOT NULL,
  `position` char(15) NOT NULL,
  `store_id` int(10) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `role_t`
--

INSERT INTO `role_t` (`role_id`, `employee_id`, `position`, `store_id`) VALUES
(0, 0, 'As.Manager', 0),
(1, 1, 'Cashier', 0),
(2, 2, 'Cook', 0),
(3, 3, 'As.Manager', 0),
(4, 4, 'Cashier', 0),
(5, 5, 'Cook', 0),
(6, 6, 'Manager', 0),
(7, 6, 'Manager', 1);

-- --------------------------------------------------------

--
-- Table structure for table `shift_t`
--

CREATE TABLE IF NOT EXISTS `shift_t` (
  `shift_id` int(10) NOT NULL,
  `employee_id` int(10) NOT NULL,
  `position` char(15) NOT NULL,
  `store_id` int(10) NOT NULL,
  `date` date NOT NULL,
  `timeslot` char(20) NOT NULL,
  `attendence` char(6) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `shift_t`
--

INSERT INTO `shift_t` (`shift_id`, `employee_id`, `position`, `store_id`, `date`, `timeslot`, `attendence`) VALUES
(0, 0, 'As.Manager', 0, '2022-10-08', '6:00 AM - 2:00 PM', 'Yes'),
(1, 1, 'Cashier', 0, '2022-10-08', '6:00 PM - 2:00 AM', 'Late'),
(2, 2, 'Cook', 0, '2022-10-08', '6:00 AM - 2:00 PM', 'Yes'),
(3, 3, 'As.Manager', 0, '2022-10-08', '1:00 PM - 9:00 PM', 'Yes'),
(4, 5, 'Cook', 0, '2022-10-08', '2:00 PM - 9:00 PM', NULL),
(5, 4, 'Cashier', 0, '2022-10-08', '2:00 PM - 9:00 PM', NULL),
(6, 6, 'Manager', 0, '2022-10-08', '12:00 PM - 6:00 PM', 'Yes');

-- --------------------------------------------------------

--
-- Table structure for table `user_t`
--

CREATE TABLE IF NOT EXISTS `user_t` (
  `username` varchar(25) NOT NULL,
  `employee_id` int(10) NOT NULL,
  `password` varchar(25) NOT NULL,
  `email` varchar(30) NOT NULL,
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `user_t`
--

INSERT INTO `user_t` (`username`, `employee_id`, `password`,`email`) VALUES
('chck44', 6, 'Ch1ch_1$_B3$t', 'chck@chck.com');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `employee_t`
--
ALTER TABLE `employee_t`
  ADD PRIMARY KEY (`employee_id`),
  ADD UNIQUE KEY `employee_id_2` (`employee_id`),
  ADD KEY `employee_id` (`employee_id`);

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
-- Indexes for table `role_t`
--
ALTER TABLE `role_t`
  ADD PRIMARY KEY (`role_id`),
  ADD KEY `employee_id` (`employee_id`),
  ADD KEY `position` (`position`),
  ADD KEY `store_id` (`store_id`),
  ADD KEY `employee_id_2` (`employee_id`,`position`,`store_id`);

--
-- Indexes for table `shift_t`
--
ALTER TABLE `shift_t`
  ADD PRIMARY KEY (`shift_id`),
  ADD KEY `shift_fk` (`employee_id`),
  ADD KEY `position` (`position`),
  ADD KEY `store_id` (`store_id`),
  ADD KEY `position_2` (`position`,`store_id`,`date`),
  ADD KEY `shift_fk1` (`employee_id`,`position`,`store_id`);

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
-- Constraints for table `role_t`
--
ALTER TABLE `role_t`
  ADD CONSTRAINT `role_fk1` FOREIGN KEY (`position`) REFERENCES `position_t` (`position`),
  ADD CONSTRAINT `role_fk2` FOREIGN KEY (`store_id`) REFERENCES `location_t` (`store_id`),
  ADD CONSTRAINT `role_fk3` FOREIGN KEY (`employee_id`) REFERENCES `employee_t` (`employee_id`);

--
-- Constraints for table `shift_t`
--
ALTER TABLE `shift_t`
  ADD CONSTRAINT `shift_fk1` FOREIGN KEY (`employee_id`, `position`, `store_id`) REFERENCES `role_t` (`employee_id`, `position`, `store_id`);

--
-- Constraints for table `user_t`
--
ALTER TABLE `user_t`
  ADD CONSTRAINT `user_fk` FOREIGN KEY (`employee_id`) REFERENCES `employee_t` (`employee_id`);

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
