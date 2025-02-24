CREATE DATABASE `topology` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci */;
USE `topology`;

CREATE TABLE `application_groups` (
    `id` int(11) NOT NULL AUTO_INCREMENT,
    `name` VARCHAR(255) NOT NULL,
    PRIMARY KEY (`id`)
);

CREATE TABLE `assets` (
    `uuid` VARCHAR(255) NOT NULL,
    `c` int(11) DEFAULT 0,
    `i` int(11) DEFAULT 0,
    `a` int(11) DEFAULT 0,
    `threat_prob` int(11) DEFAULT 0,
    `vulnerability_qualif` int(11) DEFAULT 0,
    `treatment` VARCHAR(255) DEFAULT "",
    PRIMARY KEY (`uuid`)
);

CREATE TABLE `treatments` (
  `uuid` VARCHAR(255) NOT NULL,
  `effectiveness` int(11) DEFAULT 0,
  PRIMARY KEY (`uuid`)
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
  `confidentality_value` int(11) DEFAULT NULL,
  `confidentality_values` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`confidentality_values`)),
  `integrity_value` int(11) DEFAULT NULL,
  `integrity_values` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`integrity_values`)),
  `availability_value` int(11) DEFAULT NULL,
  `availability_values` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`availability_values`)),
  `x_coord` DECIMAL(20, 14) DEFAULT 0,
  `y_coord` DECIMAL(20, 14) DEFAULT 0,
  PRIMARY KEY (`id`)
  ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE `paths` (
`id` int(11) NOT NULL AUTO_INCREMENT,
`path_id` int(11) DEFAULT NULL,
`relation_id` int(11) DEFAULT NULL,
`color` text DEFAULT NULL,
`confidentality_value` int(11) DEFAULT NULL,
`integrity_value` int(11) DEFAULT NULL,
`availability_value` int(11) DEFAULT NULL,
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
