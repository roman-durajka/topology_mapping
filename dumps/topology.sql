CREATE DATABASE `topology` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci */;
USE `topology`;

CREATE TABLE `application_groups` (
    `id` int(11) NOT NULL AUTO_INCREMENT,
    `name` VARCHAR(255) NOT NULL,
    PRIMARY KEY (`id`)
);

CREATE TABLE `information_systems` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `path_id` int(11) DEFAULT NULL,
  `information_system` text DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=22 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE `nodes` (
  `id` int(11) NOT NULL,
  `type` varchar(255) DEFAULT NULL,
  `asset` varchar(255) DEFAULT NULL,
  `asset_value` int(11) DEFAULT NULL,
  `asset_values` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`asset_values`)),
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE `paths` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `path_id` int(11) DEFAULT NULL,
  `relation_id` int(11) DEFAULT NULL,
  `color` text DEFAULT NULL,
  `asset_value` int(11) DEFAULT NULL,
  `name` text DEFAULT NULL,
  `application_group_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=108 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE `relations` (
  `id` int(11) NOT NULL,
  `source` int(11) DEFAULT NULL,
  `target` int(11) DEFAULT NULL,
  `source_if` int(11) DEFAULT NULL,
  `target_if` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
