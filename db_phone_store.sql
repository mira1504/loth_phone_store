
CREATE DATABASE `phone_store`

CREATE TABLE `admin` (
  `id` int NOT NULL AUTO_INCREMENT,
  `username` varchar(80) NOT NULL,
  `email` varchar(120) NOT NULL,
  `password` varchar(180) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `username` (`username`),
  UNIQUE KEY `email` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;


-- phone_store.customer definition

CREATE TABLE `customer` (
  `id` int NOT NULL AUTO_INCREMENT,
  `username` varchar(50) DEFAULT NULL,
  `first_name` varchar(50) DEFAULT NULL,
  `last_name` varchar(50) DEFAULT NULL,
  `email` varchar(50) DEFAULT NULL,
  `phone_number` varchar(50) DEFAULT NULL,
  `gender` varchar(5) DEFAULT NULL,
  `password` varchar(200) DEFAULT NULL,
  `date_created` datetime NOT NULL,
  `lock` tinyint(1) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `username` (`username`),
  UNIQUE KEY `email` (`email`),
  UNIQUE KEY `phone_number` (`phone_number`),
  CONSTRAINT `customer_chk_1` CHECK ((`lock` in (0,1)))
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- phone_store.category definition

CREATE TABLE `category` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(30) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- phone_store.brand definition

CREATE TABLE `brand` (
  `id` int NOT NULL AUTO_INCREMENT,
  `category_id` int NOT NULL,
  `name` varchar(30) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`),
  KEY `category_id` (`category_id`),
  CONSTRAINT `brand_ibfk_1` FOREIGN KEY (`category_id`) REFERENCES `category` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- phone_store.product definition

CREATE TABLE `product` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(80) NOT NULL,
  `price` decimal(10,2) NOT NULL,
  `discount` int DEFAULT NULL,
  `stock` int NOT NULL,
  `colors` text NOT NULL,
  `desc` text NOT NULL,
  `pub_date` datetime NOT NULL,
  `category_id` int NOT NULL,
  `brand_id` int NOT NULL,
  `image_1` varchar(150) NOT NULL,
  `image_2` varchar(150) NOT NULL,
  `image_3` varchar(150) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `category_id` (`category_id`),
  KEY `brand_id` (`brand_id`),
  CONSTRAINT `product_ibfk_1` FOREIGN KEY (`category_id`) REFERENCES `category` (`id`),
  CONSTRAINT `product_ibfk_2` FOREIGN KEY (`brand_id`) REFERENCES `brand` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- phone_store.customer_order definition

CREATE TABLE `customer_order` (
  `id` int NOT NULL AUTO_INCREMENT,
  `invoice` varchar(20) NOT NULL,
  `status` varchar(20) DEFAULT NULL,
  `address` varchar(200) DEFAULT NULL,
  `customer_id` int NOT NULL,
  `orders` text,
  `date_created` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `invoice` (`invoice`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- phone_store.rate definition

CREATE TABLE `rate` (
  `id` int NOT NULL AUTO_INCREMENT,
  `product_id` int NOT NULL,
  `customer_id` int NOT NULL,
  `time` datetime NOT NULL,
  `desc` text NOT NULL,
  `rate_number` int NOT NULL,
  PRIMARY KEY (`id`),
  KEY `product_id` (`product_id`),
  KEY `customer_id` (`customer_id`),
  CONSTRAINT `rate_ibfk_1` FOREIGN KEY (`product_id`) REFERENCES `product` (`id`),
  CONSTRAINT `rate_ibfk_2` FOREIGN KEY (`customer_id`) REFERENCES `customer` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

INSERT INTO phone_store.admin (username,email,password) VALUES
	 ('Hoàng Thạch','thach.hoang@gmail.com','$2b$12$TnL/SrFxXfVwkwfjDUaEs.RxFU0UXKsh0x0YOD1tNbgNqfUq7qsyW'),
	 ('Phi Dao','dao.phi@gmail.com','$2b$12$/27iDlI7A0XhrYSx5FgE8uPEQewJIL8uPTt5dc75QEFuDyIa4l1Ge'),
	 ('Nguyễn Minh Trí','tri.nguyen@gmail.com','$2b$12$yvvoAHfLm7Y8Xe5ctSn/Oeb3OKTNHm76aKmTr8T1vvqtrcKFM6yLq');

INSERT INTO phone_store.customer (username,first_name,last_name,email,phone_number,gender,password,date_created,`lock`) VALUES
	 ('ha.do','Hà','ĐỗThị','hado@gmail.com','0969307843','F','$2b$12$leOvQYibyYjgEjx5FpcvE.6ZA95HLASltTlDAHxgDw2KHKjzX4ku6','2025-06-12 05:35:22',0),
	 ('dung.pham','Dũng','Phạm Văn','dung.pham@gmail.com','0798123123','M','$2b$12$SvXLPuMhBRC8j2nIkK9ytu0k5S3c3BShvmQl54x3vaMAMYrl6QesK','2025-06-13 07:43:53',0),
	 ('thach.hoang@gmail.co','Đặng','Thạch','hthach1504@gmail.com','0978123456','M','$2b$12$u40w2R1kPJEJhLon3tBSF.An3DhqgZWgqLRSYIbbFJMzxqTA5WhbS','2025-06-13 08:24:04',0);

INSERT INTO phone_store.category (name) VALUES
	 ('Điện thoại'),
	 ('Phụ kiện điện thoại');

INSERT INTO phone_store.brand (category_id,name) VALUES
	 (1,'Samsung'),
	 (1,'Apple'),
	 (2,'Tai nghe bluetooth'),
	 (2,'Sạc dự phòng'),
	 (2,'Ốp lưng');

INSERT INTO phone_store.product (name,price,discount,stock,colors,`desc`,pub_date,category_id,brand_id,image_1,image_2,image_3) VALUES
	 ('Samsung Galaxy S25 Ultra',30000000.00,4,100,'Tự Nhiên, Trắng, Xanh, Đen','Samsung S25 Ultra mạnh mẽ với chip Snapdragon 8 Elite For Galaxy mới nhất, RAM 12GB và bộ nhớ trong 256GB-1TB. Hệ thống 3 camera sau chất lượng gồm camera chính 200MP, camera tele 50MP và camera góc siêu rộng 50MP. Thiết kế kính cường lực Corning Gorilla Armor 2 và khung viền Titanium, màn hình Dynamic AMOLED 6.9 inch. Điện thoại này còn có viên pin 5000mAh, hỗ trợ 5G và Galaxy AI ấn tượng, nâng cao trải nghiệm người dùng!','2025-06-12 05:13:09',1,1,'s25_ultra_1.jpg','s25_ultra_2.jpg','s25_ultra_3.jpg'),
	 ('Samsung Galaxy S25 Plus',25000000.00,0,100,'Tự Nhiên, Trắng, Xanh, Đen','Samsung S25 Plus mạnh mẽ với chip Snapdragon 8 Elite For Galaxy mới nhất, RAM 12GB và bộ nhớ trong 256GB-1TB. Hệ thống 3 camera sau chất lượng gồm camera chính 200MP, camera tele 50MP và camera góc siêu rộng 50MP. Thiết kế kính cường lực Corning Gorilla Armor 2 và khung viền Titanium, màn hình Dynamic AMOLED 6.9 inch. Điện thoại này còn có viên pin 5000mAh, hỗ trợ 5G và Galaxy AI ấn tượng, nâng cao trải nghiệm người dùng!','2025-06-12 05:13:09',1,1,'s25_plus_1.jpg','s25_plus_2.jpg','s25_plus_3.jpg'),
	 ('Samsung Galaxy S24 Ultra',26000000.00,10,20,'Tự Nhiên, Trắng, Xanh, Đen','Samsung S24 Ultra mạnh mẽ với chip Snapdragon 8 Elite For Galaxy mới nhất, RAM 12GB và bộ nhớ trong 246GB-1TB. Hệ thống 3 camera sau chất lượng gồm camera chính 200MP, camera tele 50MP và camera góc siêu rộng 50MP. Thiết kế kính cường lực Corning Gorilla Armor 2 và khung viền Titanium, màn hình Dynamic AMOLED 6.9 inch. Điện thoại này còn có viên pin 5000mAh, hỗ trợ 5G và Galaxy AI ấn tượng, nâng cao trải nghiệm người dùng!','2025-05-10 05:13:09',1,1,'s24_ultra_1.jpg','s24_ultra_2.jpg','s24_ultra_3.jpg'),
	 ('Samsung Galaxy S24 Plus',21000000.00,15,22,'Đỏ, Trắng, Đen','Samsung S24 Plus mạnh mẽ với chip Snapdragon 8 Elite For Galaxy mới nhất, RAM 12GB và bộ nhớ trong 246GB-1TB. Hệ thống 3 camera sau chất lượng gồm camera chính 200MP, camera tele 50MP và camera góc siêu rộng 50MP. Thiết kế kính cường lực Corning Gorilla Armor 2 và khung viền Titanium, màn hình Dynamic AMOLED 6.9 inch. Điện thoại này còn có viên pin 5000mAh, hỗ trợ 5G và Galaxy AI ấn tượng, nâng cao trải nghiệm người dùng!','2025-05-09 05:13:09',1,1,'s24_plus_1.jpg','s24_plus_2.jpg','s24_plus_3.jpg'),
	 ('iPhone 15 Pro 256GB',22000000.00,10,20,'Tự Nhiên, Trắng, Xanh, Đen','iPhone 15 Pro hiện nay là cái tên “sốt xình xịch” bởi đây là một trong 4 siêu phẩm vừa được ra mắt của Apple với những đột phá về cả thiết kế lẫn cấu hình. Phiên bản Apple iPhone 15 Pro 256GB chính là một trong những chiếc iPhone được săn đón nhất bởi dung lượng bộ nhớ khủng, cho phép bạn thoải mái với vô vàn ứng dụng.','2025-05-10 05:13:09',1,2,'iphone_15_pro_1.jpg','iphone_15_pro_2.jpg','iphone_15_pro_3.jpg'),
	 ('iPhone 15 Pro Max 256GB',27000000.00,15,22,'Tự Nhiên, Trắng, Xanh, Đen','iPhone 15 Pro Max hiện nay là cái tên “sốt xình xịch” bởi đây là một trong 4 siêu phẩm vừa được ra mắt của Apple với những đột phá về cả thiết kế lẫn cấu hình. Phiên bản Apple iPhone 15 Pro Max 256GB chính là một trong những chiếc iPhone được săn đón nhất bởi dung lượng bộ nhớ khủng, cho phép bạn thoải mái với vô vàn ứng dụng.','2025-05-10 05:13:09',1,2,'iphone_15_pro_max_1.jpg','iphone_15_pro_max_2.jpg','iphone_15_pro_max_3.jpg'),
	 ('iPhone 16 Pro 256GB',27000000.00,0,100,'Sa Mạc, Tự Nhiên, Trắng, Đen','iPhone 16 Pro hiện nay là cái tên “sốt xình xịch” bởi đây là một trong 4 siêu phẩm vừa được ra mắt của Apple với những đột phá về cả thiết kế lẫn cấu hình. Phiên bản Apple iPhone 16 Pro 256GB chính là một trong những chiếc iPhone được săn đón nhất bởi dung lượng bộ nhớ khủng, cho phép bạn thoải mái với vô vàn ứng dụng.','2025-06-12 05:13:09',1,2,'iphone_16_pro_1.jpg','iphone_16_pro_2.jpg','iphone_16_pro_3.jpg'),
	 ('iPhone 16 Pro Max 256GB',32000000.00,0,98,'Sa Mạc, Tự Nhiên, Trắng, Đen','iPhone 16 Pro Max hiện nay là cái tên “sốt xình xịch” bởi đây là một trong 4 siêu phẩm vừa được ra mắt của Apple với những đột phá về cả thiết kế lẫn cấu hình. Phiên bản Apple iPhone 16 Pro Max 256GB chính là một trong những chiếc iPhone được săn đón nhất bởi dung lượng bộ nhớ khủng, cho phép bạn thoải mái với vô vàn ứng dụng.','2025-06-12 05:13:09',1,2,'iphone_16_pro_max_1.jpg','iphone_16_pro_max_2.jpg','iphone_16_pro_max_3.jpg'),
	 ('Samsung Galaxy S25 ',20000000.00,0,100,'Đỏ, Trắng, Đen','Samsung S25 mạnh mẽ với chip Snapdragon 8 Elite For Galaxy mới nhất, RAM 12GB và bộ nhớ trong 256GB-1TB. Hệ thống 3 camera sau chất lượng gồm camera chính 200MP, camera tele 50MP và camera góc siêu rộng 50MP. Thiết kế kính cường lực Corning Gorilla Armor 2 và khung viền Titanium, màn hình Dynamic AMOLED 6.9 inch. Điện thoại này còn có viên pin 5000mAh, hỗ trợ 5G và Galaxy AI ấn tượng, nâng cao trải nghiệm người dùng!','2025-06-12 05:13:09',1,1,'s25_1.jpg','s25_2.jpg','s25_3.jpg'),
	 ('iPhone 16 Plus 256GB',25000000.00,0,99,'Đỏ, Trắng, Đen','iPhone 16 Plus hiện nay là cái tên “sốt xình xịch” bởi đây là một trong 4 siêu phẩm vừa được ra mắt của Apple với những đột phá về cả thiết kế lẫn cấu hình. Phiên bản Apple iPhone 16 Plus 256GB chính là một trong những chiếc iPhone được săn đón nhất bởi dung lượng bộ nhớ khủng, cho phép bạn thoải mái với vô vàn ứng dụng.','2025-06-12 05:13:09',1,2,'iphone_16_plus_1.jpg','iphone_16_plus_2.jpg','iphone_16_plus_3.jpg');
INSERT INTO phone_store.product (name,price,discount,stock,colors,`desc`,pub_date,category_id,brand_id,image_1,image_2,image_3) VALUES
	 ('iPhone 16 256GB',23000000.00,0,100,'Đỏ, Trắng, Đen','iPhone 16 hiện nay là cái tên “sốt xình xịch” bởi đây là một trong 4 siêu phẩm vừa được ra mắt của Apple với những đột phá về cả thiết kế lẫn cấu hình. Phiên bản Apple iPhone 16 256GB chính là một trong những chiếc iPhone được săn đón nhất bởi dung lượng bộ nhớ khủng, cho phép bạn thoải mái với vô vàn ứng dụng.','2025-06-12 05:13:09',1,2,'iphone_16_1.jpg','iphone_16_2.jpg','iphone_16_3.jpg'),
	 ('iPhone 15 256GB',18000000.00,5,20,'Đỏ, Trắng, Đen','iPhone 15 hiện nay là cái tên “sốt xình xịch” bởi đây là một trong 4 siêu phẩm vừa được ra mắt của Apple với những đột phá về cả thiết kế lẫn cấu hình. Phiên bản Apple iPhone 15 256GB chính là một trong những chiếc iPhone được săn đón nhất bởi dung lượng bộ nhớ khủng, cho phép bạn thoải mái với vô vàn ứng dụng.','2025-05-10 05:13:09',1,2,'iphone_15_1.jpg','iphone_15_2.jpg','iphone_15_3.jpg'),
	 ('iPhone 15 Plus 256GB',20000000.00,10,22,'Đỏ, Trắng, Đen','iPhone 15 Plus hiện nay là cái tên “sốt xình xịch” bởi đây là một trong 4 siêu phẩm vừa được ra mắt của Apple với những đột phá về cả thiết kế lẫn cấu hình. Phiên bản Apple iPhone 15 Plus 256GB chính là một trong những chiếc iPhone được săn đón nhất bởi dung lượng bộ nhớ khủng, cho phép bạn thoải mái với vô vàn ứng dụng.','2025-05-10 05:13:09',1,2,'iphone_15_plus_1.jpg','iphone_15_plus_2.jpg','iphone_15_plus_3.jpg'),
	 ('iPhone 14 256GB',16000000.00,5,20,'Đỏ, Trắng, Đen','iPhone 14 hiện nay là cái tên “sốt xình xịch” bởi đây là một trong 4 siêu phẩm vừa được ra mắt của Apple với những đột phá về cả thiết kế lẫn cấu hình. Phiên bản Apple iPhone 14 256GB chính là một trong những chiếc iPhone được săn đón nhất bởi dung lượng bộ nhớ khủng, cho phép bạn thoải mái với vô vàn ứng dụng.','2025-05-10 05:13:09',1,2,'iphone_14_1.jpg','iphone_14_2.jpg','iphone_14_3.jpg'),
	 ('iPhone 14 Plus 256GB',18000000.00,10,22,'Đỏ, Trắng, Đen','iPhone 14 Plus hiện nay là cái tên “sốt xình xịch” bởi đây là một trong 4 siêu phẩm vừa được ra mắt của Apple với những đột phá về cả thiết kế lẫn cấu hình. Phiên bản Apple iPhone 14 Plus 256GB chính là một trong những chiếc iPhone được săn đón nhất bởi dung lượng bộ nhớ khủng, cho phép bạn thoải mái với vô vàn ứng dụng.','2025-05-10 05:13:09',1,2,'iphone_14_plus_1.jpg','iphone_14_plus_2.jpg','iphone_14_plus_3.jpg'),
	 ('iPhone 14 Pro 256GB',20000000.00,10,20,'Tự Nhiên, Trắng, Xanh, Đen','iPhone 14 Pro hiện nay là cái tên “sốt xình xịch” bởi đây là một trong 4 siêu phẩm vừa được ra mắt của Apple với những đột phá về cả thiết kế lẫn cấu hình. Phiên bản Apple iPhone 14 Pro 256GB chính là một trong những chiếc iPhone được săn đón nhất bởi dung lượng bộ nhớ khủng, cho phép bạn thoải mái với vô vàn ứng dụng.','2025-05-10 05:13:09',1,2,'iphone_14_pro_1.jpg','iphone_14_pro_2.jpg','iphone_14_pro_3.jpg'),
	 ('iPhone 14 Pro Max 256GB',22000000.00,15,22,'Tự Nhiên, Trắng, Xanh, Đen','iPhone 14 Pro Max hiện nay là cái tên “sốt xình xịch” bởi đây là một trong 4 siêu phẩm vừa được ra mắt của Apple với những đột phá về cả thiết kế lẫn cấu hình. Phiên bản Apple iPhone 14 Pro Max 256GB chính là một trong những chiếc iPhone được săn đón nhất bởi dung lượng bộ nhớ khủng, cho phép bạn thoải mái với vô vàn ứng dụng.','2025-05-10 05:13:09',1,2,'iphone_14_pro_max_1.jpg','iphone_14_pro_max_2.jpg','iphone_14_pro_max_3.jpg'),
	 ('Samsung Galaxy S24',24000000.00,15,22,'Đỏ, Trắng, Đen','Samsung S24 mạnh mẽ với chip Snapdragon 8 Elite For Galaxy mới nhất, RAM 12GB và bộ nhớ trong 246GB-1TB. Hệ thống 3 camera sau chất lượng gồm camera chính 200MP, camera tele 50MP và camera góc siêu rộng 50MP. Thiết kế kính cường lực Corning Gorilla Armor 2 và khung viền Titanium, màn hình Dynamic AMOLED 6.9 inch. Điện thoại này còn có viên pin 5000mAh, hỗ trợ 5G và Galaxy AI ấn tượng, nâng cao trải nghiệm người dùng!','2025-05-09 05:13:09',1,1,'s24_1.jpg','s24_2.jpg','s24_3.jpg'),
	 ('iPhone 13 256GB',14000000.00,5,20,'Đỏ, Trắng, Đen','iPhone 13 hiện nay là cái tên “sốt xình xịch” bởi đây là một trong 4 siêu phẩm vừa được ra mắt của Apple với những đột phá về cả thiết kế lẫn cấu hình. Phiên bản Apple iPhone 13 256GB chính là một trong những chiếc iPhone được săn đón nhất bởi dung lượng bộ nhớ khủng, cho phép bạn thoải mái với vô vàn ứng dụng.','2025-05-10 05:13:09',1,2,'iphone_13_1.jpg','iphone_13_2.jpg','iphone_13_3.jpg'),
	 ('iPhone 13 Plus 256GB',16000000.00,10,22,'Đỏ, Trắng, Đen','iPhone 13 Plus hiện nay là cái tên “sốt xình xịch” bởi đây là một trong 4 siêu phẩm vừa được ra mắt của Apple với những đột phá về cả thiết kế lẫn cấu hình. Phiên bản Apple iPhone 13 Plus 256GB chính là một trong những chiếc iPhone được săn đón nhất bởi dung lượng bộ nhớ khủng, cho phép bạn thoải mái với vô vàn ứng dụng.','2025-05-10 05:13:09',1,2,'iphone_13_plus_1.jpg','iphone_13_plus_2.jpg','iphone_13_plus_3.jpg');
INSERT INTO phone_store.product (name,price,discount,stock,colors,`desc`,pub_date,category_id,brand_id,image_1,image_2,image_3) VALUES
	 ('iPhone 13 Pro 256GB',18000000.00,10,20,'Tự Nhiên, Trắng, Xanh, Đen','iPhone 13 Pro hiện nay là cái tên “sốt xình xịch” bởi đây là một trong 4 siêu phẩm vừa được ra mắt của Apple với những đột phá về cả thiết kế lẫn cấu hình. Phiên bản Apple iPhone 13 Pro 256GB chính là một trong những chiếc iPhone được săn đón nhất bởi dung lượng bộ nhớ khủng, cho phép bạn thoải mái với vô vàn ứng dụng.','2025-05-10 05:13:09',1,2,'iphone_13_pro_1.jpg','iphone_13_pro_2.jpg','iphone_13_pro_3.jpg'),
	 ('iPhone 13 Pro Max 256GB',20000000.00,15,22,'Tự Nhiên, Trắng, Xanh, Đen','iPhone 13 Pro Max hiện nay là cái tên “sốt xình xịch” bởi đây là một trong 4 siêu phẩm vừa được ra mắt của Apple với những đột phá về cả thiết kế lẫn cấu hình. Phiên bản Apple iPhone 13 Pro Max 256GB chính là một trong những chiếc iPhone được săn đón nhất bởi dung lượng bộ nhớ khủng, cho phép bạn thoải mái với vô vàn ứng dụng.','2025-05-10 05:13:09',1,2,'iphone_13_pro_max_1.jpg','iphone_13_pro_max_2.jpg','iphone_13_pro_max_3.jpg'),
	 ('iPhone 12 256GB',12000000.00,5,20,'Đỏ, Trắng, Đen','iPhone 12 hiện nay là cái tên “sốt xình xịch” bởi đây là một trong 4 siêu phẩm vừa được ra mắt của Apple với những đột phá về cả thiết kế lẫn cấu hình. Phiên bản Apple iPhone 12 256GB chính là một trong những chiếc iPhone được săn đón nhất bởi dung lượng bộ nhớ khủng, cho phép bạn thoải mái với vô vàn ứng dụng.','2025-05-10 05:13:09',1,2,'iphone_12_1.jpg','iphone_12_2.jpg','iphone_12_3.jpg'),
	 ('iPhone 12 Plus 256GB',14000000.00,10,22,'Đỏ, Trắng, Đen','iPhone 12 Plus hiện nay là cái tên “sốt xình xịch” bởi đây là một trong 4 siêu phẩm vừa được ra mắt của Apple với những đột phá về cả thiết kế lẫn cấu hình. Phiên bản Apple iPhone 12 Plus 256GB chính là một trong những chiếc iPhone được săn đón nhất bởi dung lượng bộ nhớ khủng, cho phép bạn thoải mái với vô vàn ứng dụng.','2025-05-10 05:13:09',1,2,'iphone_12_plus_1.jpg','iphone_12_plus_2.jpg','iphone_12_plus_3.jpg'),
	 ('iPhone 12 Pro 256GB',16000000.00,10,20,'Tự Nhiên, Trắng, Xanh, Đen','iPhone 12 Pro hiện nay là cái tên “sốt xình xịch” bởi đây là một trong 4 siêu phẩm vừa được ra mắt của Apple với những đột phá về cả thiết kế lẫn cấu hình. Phiên bản Apple iPhone 12 Pro 256GB chính là một trong những chiếc iPhone được săn đón nhất bởi dung lượng bộ nhớ khủng, cho phép bạn thoải mái với vô vàn ứng dụng.','2025-05-10 05:13:09',1,2,'iphone_12_pro_1.jpg','iphone_12_pro_2.jpg','iphone_12_pro_3.jpg'),
	 ('iPhone 12 Pro Max 256GB',18000000.00,15,22,'Tự Nhiên, Trắng, Xanh, Đen','iPhone 12 Pro Max hiện nay là cái tên “sốt xình xịch” bởi đây là một trong 4 siêu phẩm vừa được ra mắt của Apple với những đột phá về cả thiết kế lẫn cấu hình. Phiên bản Apple iPhone 12 Pro Max 256GB chính là một trong những chiếc iPhone được săn đón nhất bởi dung lượng bộ nhớ khủng, cho phép bạn thoải mái với vô vàn ứng dụng.','2025-05-10 05:13:09',1,2,'iphone_12_pro_max_1.jpg','iphone_12_pro_max_2.jpg','iphone_12_pro_max_3.jpg'),
	 ('Samsung Galaxy S23',20000000.00,15,22,'Đỏ, Trắng, Đen','Samsung S23 mạnh mẽ với chip Snapdragon 8 Elite For Galaxy mới nhất, RAM 12GB và bộ nhớ trong 236GB-1TB. Hệ thống 3 camera sau chất lượng gồm camera chính 230MP, camera tele 50MP và camera góc siêu rộng 50MP. Thiết kế kính cường lực Corning Gorilla Armor 2 và khung viền Titanium, màn hình Dynamic AMOLED 6.9 inch. Điện thoại này còn có viên pin 5000mAh, hỗ trợ 5G và Galaxy AI ấn tượng, nâng cao trải nghiệm người dùng!','2025-05-09 05:13:09',1,1,'s23_1.jpg','s23_2.jpg','s23_3.jpg'),
	 ('Samsung Galaxy S23 Plus',22000000.00,15,22,'Đỏ, Trắng, Đen','Samsung S23 Plus mạnh mẽ với chip Snapdragon 8 Elite For Galaxy mới nhất, RAM 12GB và bộ nhớ trong 236GB-1TB. Hệ thống 3 camera sau chất lượng gồm camera chính 230MP, camera tele 50MP và camera góc siêu rộng 50MP. Thiết kế kính cường lực Corning Gorilla Armor 2 và khung viền Titanium, màn hình Dynamic AMOLED 6.9 inch. Điện thoại này còn có viên pin 5000mAh, hỗ trợ 5G và Galaxy AI ấn tượng, nâng cao trải nghiệm người dùng!','2025-05-09 05:13:09',1,1,'s23_plus_1.jpg','s23_plus_2.jpg','s23_plus_3.jpg'),
	 ('Samsung Galaxy S23 Ultra',24000000.00,10,20,'Tự Nhiên, Trắng, Xanh, Đen','Samsung S23 Ultra mạnh mẽ với chip Snapdragon 8 Elite For Galaxy mới nhất, RAM 12GB và bộ nhớ trong 236GB-1TB. Hệ thống 3 camera sau chất lượng gồm camera chính 230MP, camera tele 50MP và camera góc siêu rộng 50MP. Thiết kế kính cường lực Corning Gorilla Armor 2 và khung viền Titanium, màn hình Dynamic AMOLED 6.9 inch. Điện thoại này còn có viên pin 5000mAh, hỗ trợ 5G và Galaxy AI ấn tượng, nâng cao trải nghiệm người dùng!','2025-05-10 05:13:09',1,1,'s23_ultra_1.jpg','s23_ultra_2.jpg','s23_ultra_3.jpg'),
	 ('Samsung Galaxy S22',18000000.00,15,22,'Đỏ, Trắng, Đen','Samsung S22 mạnh mẽ với chip Snapdragon 8 Elite For Galaxy mới nhất, RAM 12GB và bộ nhớ trong 226GB-1TB. Hệ thống 3 camera sau chất lượng gồm camera chính 220MP, camera tele 50MP và camera góc siêu rộng 50MP. Thiết kế kính cường lực Corning Gorilla Armor 2 và khung viền Titanium, màn hình Dynamic AMOLED 6.9 inch. Điện thoại này còn có viên pin 5000mAh, hỗ trợ 5G và Galaxy AI ấn tượng, nâng cao trải nghiệm người dùng!','2025-05-09 05:13:09',1,1,'s22_1.jpg','s22_2.jpg','s22_3.jpg');
INSERT INTO phone_store.product (name,price,discount,stock,colors,`desc`,pub_date,category_id,brand_id,image_1,image_2,image_3) VALUES
	 ('Samsung Galaxy S22 Plus',20000000.00,15,22,'Đỏ, Trắng, Đen','Samsung S22 Plus mạnh mẽ với chip Snapdragon 8 Elite For Galaxy mới nhất, RAM 12GB và bộ nhớ trong 226GB-1TB. Hệ thống 3 camera sau chất lượng gồm camera chính 220MP, camera tele 50MP và camera góc siêu rộng 50MP. Thiết kế kính cường lực Corning Gorilla Armor 2 và khung viền Titanium, màn hình Dynamic AMOLED 6.9 inch. Điện thoại này còn có viên pin 5000mAh, hỗ trợ 5G và Galaxy AI ấn tượng, nâng cao trải nghiệm người dùng!','2025-05-09 05:13:09',1,1,'s22_plus_1.jpg','s22_plus_2.jpg','s22_plus_3.jpg'),
	 ('Samsung Galaxy S22 Ultra',22000000.00,10,20,'Tự Nhiên, Trắng, Xanh, Đen','Samsung S22 Ultra mạnh mẽ với chip Snapdragon 8 Elite For Galaxy mới nhất, RAM 12GB và bộ nhớ trong 226GB-1TB. Hệ thống 3 camera sau chất lượng gồm camera chính 220MP, camera tele 50MP và camera góc siêu rộng 50MP. Thiết kế kính cường lực Corning Gorilla Armor 2 và khung viền Titanium, màn hình Dynamic AMOLED 6.9 inch. Điện thoại này còn có viên pin 5000mAh, hỗ trợ 5G và Galaxy AI ấn tượng, nâng cao trải nghiệm người dùng!','2025-05-10 05:13:09',1,1,'s22_ultra_1.jpg','s22_ultra_2.jpg','s22_ultra_3.jpg'),
	 ('Samsung Galaxy S21',16000000.00,15,22,'Đỏ, Trắng, Đen','Samsung S21 mạnh mẽ với chip Snapdragon 8 Elite For Galaxy mới nhất, RAM 12GB và bộ nhớ trong 216GB-1TB. Hệ thống 3 camera sau chất lượng gồm camera chính 210MP, camera tele 50MP và camera góc siêu rộng 50MP. Thiết kế kính cường lực Corning Gorilla Armor 2 và khung viền Titanium, màn hình Dynamic AMOLED 6.9 inch. Điện thoại này còn có viên pin 5000mAh, hỗ trợ 5G và Galaxy AI ấn tượng, nâng cao trải nghiệm người dùng!','2025-05-09 05:13:09',1,1,'s21_1.jpg','s21_2.jpg','s21_3.jpg'),
	 ('Samsung Galaxy S21 Plus',18000000.00,15,22,'Đỏ, Trắng, Đen','Samsung S21 Plus mạnh mẽ với chip Snapdragon 8 Elite For Galaxy mới nhất, RAM 12GB và bộ nhớ trong 216GB-1TB. Hệ thống 3 camera sau chất lượng gồm camera chính 210MP, camera tele 50MP và camera góc siêu rộng 50MP. Thiết kế kính cường lực Corning Gorilla Armor 2 và khung viền Titanium, màn hình Dynamic AMOLED 6.9 inch. Điện thoại này còn có viên pin 5000mAh, hỗ trợ 5G và Galaxy AI ấn tượng, nâng cao trải nghiệm người dùng!','2025-05-09 05:13:09',1,1,'s21_plus_1.jpg','s21_plus_2.jpg','s21_plus_3.jpg'),
	 ('Samsung Galaxy S21 Ultra',20000000.00,10,20,'Tự Nhiên, Trắng, Xanh, Đen','Samsung S21 Ultra mạnh mẽ với chip Snapdragon 8 Elite For Galaxy mới nhất, RAM 12GB và bộ nhớ trong 216GB-1TB. Hệ thống 3 camera sau chất lượng gồm camera chính 210MP, camera tele 50MP và camera góc siêu rộng 50MP. Thiết kế kính cường lực Corning Gorilla Armor 2 và khung viền Titanium, màn hình Dynamic AMOLED 6.9 inch. Điện thoại này còn có viên pin 5000mAh, hỗ trợ 5G và Galaxy AI ấn tượng, nâng cao trải nghiệm người dùng!','2025-05-10 05:13:09',1,1,'s21_ultra_1.jpg','s21_ultra_2.jpg','s21_ultra_3.jpg'),
	 ('Samsung Galaxy S20',14000000.00,15,22,'Đỏ, Trắng, Đen','Samsung S20 mạnh mẽ với chip Snapdragon 8 Elite For Galaxy mới nhất, RAM 12GB và bộ nhớ trong 206GB-1TB. Hệ thống 3 camera sau chất lượng gồm camera chính 200MP, camera tele 50MP và camera góc siêu rộng 50MP. Thiết kế kính cường lực Corning Gorilla Armor 2 và khung viền Titanium, màn hình Dynamic AMOLED 6.9 inch. Điện thoại này còn có viên pin 5000mAh, hỗ trợ 5G và Galaxy AI ấn tượng, nâng cao trải nghiệm người dùng!','2025-05-09 05:13:09',1,1,'s20_1.jpg','s20_2.jpg','s20_3.jpg'),
	 ('Samsung Galaxy S20 Plus',16000000.00,15,22,'Đỏ, Trắng, Đen','Samsung S20 Plus mạnh mẽ với chip Snapdragon 8 Elite For Galaxy mới nhất, RAM 12GB và bộ nhớ trong 206GB-1TB. Hệ thống 3 camera sau chất lượng gồm camera chính 200MP, camera tele 50MP và camera góc siêu rộng 50MP. Thiết kế kính cường lực Corning Gorilla Armor 2 và khung viền Titanium, màn hình Dynamic AMOLED 6.9 inch. Điện thoại này còn có viên pin 5000mAh, hỗ trợ 5G và Galaxy AI ấn tượng, nâng cao trải nghiệm người dùng!','2025-05-09 05:13:09',1,1,'s20_plus_1.jpg','s20_plus_2.jpg','s20_plus_3.jpg'),
	 ('Samsung Galaxy S20 Ultra',18000000.00,10,20,'Tự Nhiên, Trắng, Xanh, Đen','Samsung S20 Ultra mạnh mẽ với chip Snapdragon 8 Elite For Galaxy mới nhất, RAM 12GB và bộ nhớ trong 206GB-1TB. Hệ thống 3 camera sau chất lượng gồm camera chính 200MP, camera tele 50MP và camera góc siêu rộng 50MP. Thiết kế kính cường lực Corning Gorilla Armor 2 và khung viền Titanium, màn hình Dynamic AMOLED 6.9 inch. Điện thoại này còn có viên pin 5000mAh, hỗ trợ 5G và Galaxy AI ấn tượng, nâng cao trải nghiệm người dùng!','2025-05-10 05:13:09',1,1,'s20_ultra_1.jpg','s20_ultra_2.jpg','s20_ultra_3.jpg'),
	 ('Tai nghe AirPods4',3490000.00,11,15,'Trắng','Apple AirPods 4 là tai nghe không dây với chip H2 cùng EQ thích ứng và âm thanh không gian cá nhân hóa mang lại trải nghiệm âm thanh ấn tượng. Tai nghe được trang bị Micrô kép với cảm biến quang học cùng micro hướng vào trong giúp thu âm tốt hơn. Cùng với điều khiển chạm cho phép người dùng điều khiển qua các thao tác nhấn tiện lợi.','2025-06-13 04:30:16',2,3,'airpods_4_1.jpg','airpods_4_2.jpg','airpods_4_3.jpg'),
	 ('Sạc dự phòng Ugreen 25.000 mAh',650000.00,0,15,'Trắng, Đen','Sạc dự phòng Ugreen 25000 mah 145W 2 chiều 2C1A 90597A là một phần không thể thiếu cho thiết bị của bạn trong những chặng đường dài. Sở hữu nhiều tính năng tiện ích ấn tượng, phiên bản chắc chắn sẽ mang đến những trải nghiệm tuyệt vời dành cho bạn trong những tình huống khẩn cấp.','2025-06-13 04:35:10',2,4,'urgreen_1.jpg','urgreen_2.jpg','urgreen_3.jpg');
INSERT INTO phone_store.product (name,price,discount,stock,colors,`desc`,pub_date,category_id,brand_id,image_1,image_2,image_3) VALUES
	 ('Ốp lưng Magsafe Iphone 15 Pro Max',1200000.00,10,20,'Trắng, Đen, Hồng','Ốp lưng nhựa dẹo trong suốt. Có tích hợp sạc Magsafe cho iphone 15 Pro Max','2025-06-13 06:05:05',2,5,'op_lung_magsafe_1.png','op_lung_magsafe_2.jpg','op_lung_magsafe_3.jpg');
