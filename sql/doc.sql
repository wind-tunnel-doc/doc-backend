/*
 Navicat Premium Data Transfer

 Source Server         : 本机MySQL
 Source Server Type    : MySQL
 Source Server Version : 80033 (8.0.33)
 Source Host           : localhost:3306
 Source Schema         : doc

 Target Server Type    : MySQL
 Target Server Version : 80033 (8.0.33)
 File Encoding         : 65001

 Date: 03/10/2024 17:47:16
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for sys_job
-- ----------------------------
DROP TABLE IF EXISTS `sys_job`;
CREATE TABLE `sys_job`  (
  `job_id` bigint NOT NULL AUTO_INCREMENT COMMENT '任务ID',
  `job_name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '' COMMENT '任务名称',
  `job_group` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT 'DEFAULT' COMMENT '任务组名',
  `invoke_target` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '调用目标字符串',
  `cron_expression` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT 'cron执行表达式',
  `misfire_policy` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '3' COMMENT '计划执行错误策略（1立即执行 2执行一次 3放弃执行）',
  `concurrent` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '1' COMMENT '是否并发执行（0允许 1禁止）',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '0' COMMENT '状态（0正常 1暂停）',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '备注信息',
  PRIMARY KEY (`job_id`, `job_name`, `job_group`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 100 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '定时任务调度表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_job
-- ----------------------------
INSERT INTO `sys_job` VALUES (1, '系统默认（无参）', 'DEFAULT', 'ryTask.ryNoParams', '0/10 * * * * ?', '3', '1', '1', 'admin', '2024-01-25 09:54:17', '', NULL, '');
INSERT INTO `sys_job` VALUES (2, '系统默认（有参）', 'DEFAULT', 'ryTask.ryParams(\'ry\')', '0/15 * * * * ?', '3', '1', '1', 'admin', '2024-01-25 09:54:17', '', NULL, '');
INSERT INTO `sys_job` VALUES (3, '系统默认（多参）', 'DEFAULT', 'ryTask.ryMultipleParams(\'ry\', true, 2000L, 316.50D, 100)', '0/20 * * * * ?', '3', '1', '1', 'admin', '2024-01-25 09:54:17', '', NULL, '');

-- ----------------------------
-- Table structure for sys_job_log
-- ----------------------------
DROP TABLE IF EXISTS `sys_job_log`;
CREATE TABLE `sys_job_log`  (
  `job_log_id` bigint NOT NULL AUTO_INCREMENT COMMENT '任务日志ID',
  `job_name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '任务名称',
  `job_group` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '任务组名',
  `invoke_target` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '调用目标字符串',
  `job_message` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '日志信息',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '0' COMMENT '执行状态（0正常 1失败）',
  `exception_info` varchar(2000) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '异常信息',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`job_log_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '定时任务调度日志表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_job_log
-- ----------------------------

-- ----------------------------
-- Table structure for sys_logininfor
-- ----------------------------
DROP TABLE IF EXISTS `sys_logininfor`;
CREATE TABLE `sys_logininfor`  (
  `info_id` bigint NOT NULL AUTO_INCREMENT COMMENT '访问ID',
  `user_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '用户账号',
  `ipaddr` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '登录IP地址',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '0' COMMENT '登录状态（0成功 1失败）',
  `msg` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '提示信息',
  `access_time` datetime NULL DEFAULT NULL COMMENT '访问时间',
  PRIMARY KEY (`info_id`) USING BTREE,
  INDEX `idx_sys_logininfor_s`(`status` ASC) USING BTREE,
  INDEX `idx_sys_logininfor_lt`(`access_time` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 392 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '系统访问记录' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_logininfor
-- ----------------------------

-- ----------------------------
-- Table structure for sys_notice
-- ----------------------------
DROP TABLE IF EXISTS `sys_notice`;
CREATE TABLE `sys_notice`  (
  `notice_id` int NOT NULL AUTO_INCREMENT COMMENT '公告ID',
  `notice_title` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '公告标题',
  `notice_type` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '公告类型（1通知 2公告）',
  `notice_content` longblob NULL COMMENT '公告内容',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '0' COMMENT '公告状态（0正常 1关闭）',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`notice_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 10 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '通知公告表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_notice
-- ----------------------------

-- ----------------------------
-- Table structure for sys_oper_log
-- ----------------------------
DROP TABLE IF EXISTS `sys_oper_log`;
CREATE TABLE `sys_oper_log`  (
  `oper_id` bigint NOT NULL AUTO_INCREMENT COMMENT '日志主键',
  `title` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '模块标题',
  `business_type` int NULL DEFAULT 0 COMMENT '业务类型（0其它 1新增 2修改 3删除）',
  `method` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '方法名称',
  `request_method` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '请求方式',
  `operator_type` int NULL DEFAULT 0 COMMENT '操作类别（0其它 1后台用户 2手机端用户）',
  `oper_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '操作人员',
  `dept_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '部门名称',
  `oper_url` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '请求URL',
  `oper_ip` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '主机地址',
  `oper_location` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '操作地点',
  `oper_param` varchar(2000) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '请求参数',
  `json_result` varchar(2000) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '返回参数',
  `status` int NULL DEFAULT 0 COMMENT '操作状态（0正常 1异常）',
  `error_msg` varchar(2000) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '错误消息',
  `oper_time` datetime NULL DEFAULT NULL COMMENT '操作时间',
  `cost_time` bigint NULL DEFAULT 0 COMMENT '消耗时间',
  PRIMARY KEY (`oper_id`) USING BTREE,
  INDEX `idx_sys_oper_log_bt`(`business_type` ASC) USING BTREE,
  INDEX `idx_sys_oper_log_s`(`status` ASC) USING BTREE,
  INDEX `idx_sys_oper_log_ot`(`oper_time` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1163 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '操作日志记录' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_oper_log
-- ----------------------------

-- ----------------------------
-- Table structure for sys_role_type
-- ----------------------------
DROP TABLE IF EXISTS `sys_role_type`;
CREATE TABLE `sys_role_type`  (
  `role_id` int NOT NULL COMMENT '角色id',
  `role_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '角色名',
  PRIMARY KEY (`role_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_role_type
-- ----------------------------
INSERT INTO `sys_role_type` VALUES (1, '普通用户');
INSERT INTO `sys_role_type` VALUES (2, '组织');
INSERT INTO `sys_role_type` VALUES (99, '管理员');

-- ----------------------------
-- Table structure for sys_user
-- ----------------------------
DROP TABLE IF EXISTS `sys_user`;
CREATE TABLE `sys_user`  (
  `user_id` bigint UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '用户ID',
  `user_name` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '用户账号',
  `nick_name` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '用户昵称',
  `user_type` varchar(2) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '00' COMMENT '用户类型（00系统用户）',
  `email` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '用户邮箱',
  `phone` varchar(11) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '' COMMENT '手机号码',
  `qq` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT 'QQ号',
  `wx` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '微信号',
  `sex` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '' COMMENT '用户性别',
  `avatar` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '头像地址',
  `password` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '' COMMENT '密码',
  `pay_password` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '支付密码',
  `status` int NOT NULL DEFAULT 0 COMMENT '帐号状态（0正常 1停用）',
  `del_flag` int NOT NULL DEFAULT 0 COMMENT '删除标志（0正常 1停用 2删除）',
  `login_ip` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '最后登录IP',
  `login_time` datetime NULL DEFAULT NULL COMMENT '最后登录时间',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NOT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '备注',
  `level` int NOT NULL DEFAULT 1 COMMENT '志愿等级',
  `score` int NOT NULL DEFAULT 0 COMMENT '积分',
  `experience` int NOT NULL DEFAULT 0 COMMENT '经验值',
  `balance` int NOT NULL DEFAULT 0 COMMENT '时间币数量',
  `role` int NOT NULL DEFAULT 0 COMMENT '角色(0: 普通用户 999:管理员)',
  PRIMARY KEY (`user_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1132 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '用户信息表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_user
-- ----------------------------
INSERT INTO `sys_user` VALUES (107, 'shiliuyinzhen', 'shiliuyinzhen', '00', '3162837668@qq.com', '18848271382', '3487865496', 'shiliuyinzhen_', '男', 'https://shiliuyinzhen-timebank.oss-cn-beijing.aliyuncs.com/50efacdb-b303-42ae-8450-bacaca3df735.jpg', '$2a$10$MXLTQ4GoG38ZFlts8ekA8esLZXD4fn5uZ2LxWwJ2ca0YUzIkL8WDq', '$2a$10$r2rNIDyRuvL0WaWX94v5g.mYPyi/4kLzQ1Jhew6MFcgwCl9V3shU.', 0, 0, '127.0.0.1', '2024-04-13 00:57:03', '', '2024-01-27 16:24:56', '', '2024-04-13 00:25:00', NULL, 1, 7271, 0, 12008, 999);
INSERT INTO `sys_user` VALUES (108, 'xiaohei', '小黑', '00', '', '', NULL, NULL, '男', 'https://cravatar.cn/avatar/aeccae349815fe8dde3381dad73c81a2d?s=200&d=robohash&f=y', '$2a$10$jGxZn4TVBraCJkYyLIitN.tpcrlb5Tl83QN466joWfMpa01o3Mn.a', '$2a$10$jGxZn4TVBraCJkYyLIitN.tpcrlb5Tl83QN466joWfMpa01o3Mn.a', 0, 0, '', NULL, '', '2024-04-12 15:55:14', '', '2024-04-12 15:55:18', NULL, 1, 0, 0, 0, 0);
INSERT INTO `sys_user` VALUES (109, 'zt', 'zt', '00', '', '', '123', NULL, '女', 'https://cravatar.cn/avatar/aeccae2349815fe8dde338dad73c81a2d?s=200&d=robohash&f=y', '$2a$10$kTp7rWyGfNtwj6pJ0IzpF.l4P67zTrZWd1LeZGCF6rRr/p.h6N5wi', '$2a$10$MXLTQ4GoG38ZFlts8ekA8esLZXD4fn5uZ2LxWwJ2ca0YUzIkL8WDq', 0, 0, '127.0.0.1', '2024-04-12 20:03:00', '', '2024-02-26 15:59:11', '', '2024-04-12 14:26:00', NULL, 1, 7129, 0, 7353, 999);
INSERT INTO `sys_user` VALUES (110, 'buchixiaocai', '不吃香菜', '00', '', '', NULL, NULL, '女', 'https://cravatar.cn/avatar/aeccae349815fe8dd3e338dad73c81a2d?s=200&d=robohash&f=y', '$2a$10$jGxZn4TVBraCJkYyLIitN.tpcrlb5Tl83QN466joWfMpa01o3Mn.a', '$2a$10$jGxZn4TVBraCJkYyLIitN.tpcrlb5Tl83QN466joWfMpa01o3Mn.a', 0, 0, '', NULL, '', '2024-04-12 15:59:21', '', '2024-04-12 15:59:24', NULL, 1, 0, 0, 0, 0);
INSERT INTO `sys_user` VALUES (111, 'buchiniurou', '不吃牛肉', '00', '', '', NULL, NULL, '男', 'https://cravatar.cn/avatar/aeccae349815fe8dd4e338dad73c81a2d?s=200&d=robohash&f=y', '$10$VIpW1ihuxWv1Ol9ef94cS.DLk2YPw5F5rbnGndLlU4gh1rhbFFgYK', NULL, 0, 0, '', NULL, '', '2024-04-12 16:00:54', '', '2024-04-12 16:00:58', NULL, 1, 0, 0, 0, 0);
INSERT INTO `sys_user` VALUES (112, 'sanfenredu', '三分热度', '00', '', '', NULL, NULL, '男', 'https://cravatar.cn/avatar/aeccae349815fe8dd5e338dad73c81a2d?s=200&d=robohash&f=y', '$10$VIpW1ihuxWv1Ol9ef94cS.DLk2YPw5F5rbnGndLlU4gh1rhbFFgYK', NULL, 0, 0, '', NULL, '', '2024-04-12 16:01:59', '', '2024-04-12 16:02:04', NULL, 1, 0, 0, 0, 0);
INSERT INTO `sys_user` VALUES (113, 'wufawutian', '无法无天', '00', '', '', NULL, NULL, '男', 'https://cravatar.cn/avatar/aeccae3469815fe8dde338dad73c81a2d?s=200&d=robohash&f=y', '$10$VIpW1ihuxWv1Ol9ef94cS.DLk2YPw5F5rbnGndLlU4gh1rhbFFgYK', NULL, 0, 0, '', NULL, '', '2024-04-12 16:03:00', '', '2024-04-12 16:03:03', NULL, 1, 0, 0, 0, 0);
INSERT INTO `sys_user` VALUES (114, 'geiwosantianguangming', '给我三天光明', '00', '', '', NULL, NULL, '男', 'https://cravatar.cn/avatar/aecca7e349815fe8dde338dad73c81a2d?s=200&d=robohash&f=y', '$10$VIpW1ihuxWv1Ol9ef94cS.DLk2YPw5F5rbnGndLlU4gh1rhbFFgYK', NULL, 0, 0, '', NULL, '', '2024-04-12 16:03:38', '', '2024-04-12 16:03:40', NULL, 1, 0, 0, 0, 0);
INSERT INTO `sys_user` VALUES (115, 'yanzhiganlu', '杨枝甘露', '00', '', '', NULL, NULL, '女', 'https://cravatar.cn/avatar/aeccae349815fe8dde338d9ad73c81a2d?s=200&d=robohash&f=y', '$10$VIpW1ihuxWv1Ol9ef94cS.DLk2YPw5F5rbnGndLlU4gh1rhbFFgYK', NULL, 0, 0, '', NULL, '', '2024-04-12 16:04:41', '', '2024-04-12 16:04:44', NULL, 1, 0, 0, 0, 0);
INSERT INTO `sys_user` VALUES (116, 'xianghesshuangpinai', '想喝双皮奶', '00', '', '', NULL, NULL, '女', 'https://cravatar.cn/avatar/aeccae3498185fe8dde338dad73c81a2d?s=200&d=robohash&f=y', '$10$VIpW1ihuxWv1Ol9ef94cS.DLk2YPw5F5rbnGndLlU4gh1rhbFFgYK', NULL, 0, 0, '', NULL, '', '2024-04-12 16:08:28', '', '2024-04-12 16:08:31', NULL, 1, 0, 0, 0, 0);
INSERT INTO `sys_user` VALUES (117, 'xiaofubufu', '小付不富', '00', '', '', NULL, NULL, '男', 'https://cravatar.cn/avatar/aeccae349815fe8dde3038dad73c81a2d?s=200&d=robohash&f=y', '$10$VIpW1ihuxWv1Ol9ef94cS.DLk2YPw5F5rbnGndLlU4gh1rhbFFgYK', NULL, 0, 0, '', NULL, '', '2024-04-12 16:09:52', '', '2024-04-12 16:09:55', NULL, 1, 0, 0, 0, 0);
INSERT INTO `sys_user` VALUES (118, 'xiaoyubuchishaokao', '小鱼不吃烧烤', '00', '', '', NULL, NULL, '女', 'https://cravatar.cn/avatar/aeccae341115fe8dde338dad73c81a2d?s=200&d=robohash&f=y', '$10$VIpW1ihuxWv1Ol9ef94cS.DLk2YPw5F5rbnGndLlU4gh1rhbFFgYK', NULL, 0, 0, '', NULL, '', '2024-04-12 16:10:05', '', '2024-04-12 16:10:07', NULL, 1, 0, 0, 0, 0);
INSERT INTO `sys_user` VALUES (119, 'huasuiihua', '花碎花', '00', '', '', NULL, NULL, '女', 'https://cravatar.cn/avatar/aeccae349815fe8dde338d12ad73c81a2d?s=200&d=robohash&f=y', '$10$VIpW1ihuxWv1Ol9ef94cS.DLk2YPw5F5rbnGndLlU4gh1rhbFFgYK', NULL, 0, 0, '', NULL, '', '2024-04-12 16:11:09', '', '2024-04-12 16:11:12', NULL, 1, 0, 0, 0, 0);
INSERT INTO `sys_user` VALUES (120, 'lindaiyudaobachuiyangliu', '林黛玉倒拔垂杨柳', '00', '', '', NULL, NULL, '女', 'https://cravatar.cn/avatar/aecc13ae349815fe8dde338dad73c81a2d?s=200&d=robohash&f=y', '$10$VIpW1ihuxWv1Ol9ef94cS.DLk2YPw5F5rbnGndLlU4gh1rhbFFgYK', NULL, 0, 0, '', NULL, '', '2024-04-12 16:13:00', '', '2024-04-12 16:13:03', NULL, 1, 0, 0, 0, 0);
INSERT INTO `sys_user` VALUES (121, 'wusuosantou', '雾锁山头', '00', '123@qq.com', '18311111113', NULL, NULL, '男', 'https://cravatar.cn/avatar/aeccae349815fe8dde338dad73c81a2d?s=200&d=robohash&f=y', '$2a$10$VIpW1ihuxWv1Ol9ef94cS.DLk2YPw5F5rbnGndLlU4gh1rhbFFgYK', '$2a$10$jGxZn4TVBraCJkYyLIitN.tpcrlb5Tl83QN466joWfMpa01o3Mn.a', 0, 0, '', NULL, '', '2024-03-22 22:52:02', '', '2024-03-22 22:52:02', NULL, 1, 0, 0, 0, 0);
INSERT INTO `sys_user` VALUES (122, 'redoufu', '热豆腐', '00', '123@qq.com', '18311111114', NULL, NULL, '男', 'https://cravatar.cn/avatar/aeccae349815fe814dde338dad73c81a2d?s=200&d=robohash&f=y', '$2a$10$Rv/HGuTBy1PcfxsQhg6Zi.RJ77JCW1JCw55b5Cn/.hM3k6RU5mW52', '$2a$10$jGxZn4TVBraCJkYyLIitN.tpcrlb5Tl83QN466joWfMpa01o3Mn.a', 0, 0, '', NULL, '', '2024-03-22 23:16:20', '', '2024-03-22 23:16:20', NULL, 1, 0, 0, 0, 0);
INSERT INTO `sys_user` VALUES (123, 'ruosuosannian', '若锁三年', '00', '123@qq.com', '18311111114', NULL, NULL, '男', 'https://cravatar.cn/avatar/aeccae34981155fe8dde338dad73c81a2d?s=200&d=robohash&f=y', '$2a$10$fkXm2lax.uKx5a02mBEZMesvsHZNClLLVPUWr5.yLdl7dR2zrz8S.', '$2a$10$jGxZn4TVBraCJkYyLIitN.tpcrlb5Tl83QN466joWfMpa01o3Mn.a', 0, 0, '', NULL, '', '2024-03-22 23:17:08', '', '2024-03-22 23:17:08', NULL, 1, 0, 0, 0, 0);
INSERT INTO `sys_user` VALUES (124, 'xiaoshoubingliang', '小手冰凉', '00', '123@qq.com', '18311111114', NULL, NULL, '男', 'https://cravatar.cn/avatar/aeccae34981615fe8dde338dad73c81a2d?s=200&d=robohash&f=y', '$2a$10$jGxZn4TVBraCJkYyLIitN.tpcrlb5Tl83QN466joWfMpa01o3Mn.a', '$2a$10$jGxZn4TVBraCJkYyLIitN.tpcrlb5Tl83QN466joWfMpa01o3Mn.a', 0, 0, '', NULL, '', '2024-03-22 23:18:18', '', '2024-03-22 23:18:18', NULL, 1, 0, 0, 0, 0);
INSERT INTO `sys_user` VALUES (125, 'xiaoxiao', '晓晓', '00', '123@qq.com', '18311111114', NULL, NULL, '男', 'https://cravatar.cn/avatar/aeccae349815fe8dde338dad1773c81a2d?s=200&d=robohash&f=y', '$2a$10$TPwAE39ubPSkgan5pixLN.YU8CesI3gegfEwX497I1y3.UT7XS.l2', '$2a$10$jGxZn4TVBraCJkYyLIitN.tpcrlb5Tl83QN466joWfMpa01o3Mn.a', 0, 0, '', NULL, '', '2024-03-22 23:20:40', '', '2024-03-22 23:20:40', NULL, 1, 0, 0, 0, 0);
INSERT INTO `sys_user` VALUES (999, 'admin', 'admin', '00', '', '', NULL, NULL, '', 'https://shiliuyinzhen-timebank.oss-cn-beijing.aliyuncs.com/50efacdb-b303-42ae-8450-bacaca3df735.jpg', '$2a$10$VIpW1ihuxWv1Ol9ef94cS.DLk2YPw5F5rbnGndLlU4gh1rhbFFgYK', NULL, 0, 0, '127.0.0.1', '2024-04-12 20:31:02', '', '2024-04-12 20:30:06', '', '2024-04-12 20:30:00', NULL, 1, 0, 0, 0, 999);
INSERT INTO `sys_user` VALUES (1110, 'zhaoyong', '叶凯', '00', 'pqiao@example.com', '13046893294', '63252120020731714X', NULL, '男', 'https://cravatar.cn/avatar/aecca1e2349815fe8dde338dad73c81a2d?s=200&d=robohash&f=y', '$2a$10$50jCzsMS7DEhBiDASgf1quOWcrVgexmzjkna.1BPpsNGMhsG.JVyi', NULL, 0, 0, '127.0.0.1', '2024-04-12 23:24:23', 'shiliuyinzhen', '2024-04-12 16:45:34', 'shiliuyinzhen', '2024-04-12 16:45:00', NULL, 1, 0, 0, 0, 0);
INSERT INTO `sys_user` VALUES (1111, 'renjun', '邹晨', '00', 'na89@example.org', '15616231192', '520201196002133111', NULL, '男', 'https://cravatar.cn/avatar/8b9010ad77c47f1444a3d0b68df0eb2c?s=200&d=robohash&f=y', '$2a$10$.GthU8Y/oganS3e.gjUDn.VVgBjP0lUkH3.ySlV0fb.C46SZvh4ZC', NULL, 0, 0, '127.0.0.1', '2024-04-12 23:25:16', 'shiliuyinzhen', '2024-04-12 16:45:35', 'shiliuyinzhen', '2024-04-12 16:45:00', NULL, 1, 0, 0, 0, 0);
INSERT INTO `sys_user` VALUES (1112, 'fanglai', '倪建平', '00', 'na94@example.net', '18243387039', '421127194704054529', NULL, '男', 'https://cravatar.cn/avatar/e4e52dda6f99acfa6b674d443cc2ad6f?s=200&d=robohash&f=y', '$2a$10$JqQQM8aZVtngRhoPfQ2JP.dP6wY3xArJ3zm6Xu1AS3y6ZzYp4nqYy', NULL, 0, 0, '127.0.0.1', '2024-04-12 23:25:41', 'shiliuyinzhen', '2024-04-12 16:45:35', 'shiliuyinzhen', '2024-04-12 16:45:00', NULL, 1, 0, 0, 0, 0);
INSERT INTO `sys_user` VALUES (1113, 'yang39', '张建华', '00', 'guiyingyao@example.org', '13400921378', '230422197007051279', NULL, '男', 'https://cravatar.cn/avatar/ddb3c8410cd08ff22ce54a5cefb52ce1?s=200&d=robohash&f=y', '$2a$10$fsiJebgSd7VuKsK26TszhORmVWw2YOO92rXBqygJg5Psy6mMOq/yW', NULL, 0, 0, '127.0.0.1', '2024-04-12 23:26:07', 'shiliuyinzhen', '2024-04-12 16:45:35', 'shiliuyinzhen', '2024-04-12 16:45:00', NULL, 1, 0, 0, 0, 0);
INSERT INTO `sys_user` VALUES (1114, 'liliang', '吴坤', '00', 'wzhao@example.net', '13201240429', '62102519750806962X', NULL, '男', 'https://cravatar.cn/avatar/6e180e9395a99e2775965f5c1602dd44?s=200&d=robohash&f=y', '$2a$10$8AAb/vbkhrp4jsVeqS4cnOtJeL.ZnxjM3DRGPmIp9dvF8Wj1BiTeK', NULL, 0, 0, '127.0.0.1', '2024-04-12 23:26:51', 'shiliuyinzhen', '2024-04-12 16:45:35', 'shiliuyinzhen', '2024-04-12 16:45:00', NULL, 1, 0, 0, 0, 0);
INSERT INTO `sys_user` VALUES (1115, 'chao74', '陈磊', '00', 'zengxia@example.net', '14766747396', '152202199204260912', NULL, '男', 'https://cravatar.cn/avatar/df17130d4393bd51edfe3f422e8858a5?s=200&d=robohash&f=y', '$2a$10$G5p3SdXfpQUFpxAKwzK0gehvyYGhjxnwjbKqKEEtQ9LJDcxUUIJSO', NULL, 0, 0, '127.0.0.1', '2024-04-12 21:40:38', 'shiliuyinzhen', '2024-04-12 16:45:35', 'shiliuyinzhen', '2024-04-12 16:45:00', NULL, 1, 0, 0, 0, 0);
INSERT INTO `sys_user` VALUES (1116, 'mindai', '朱洁', '00', 'suming@example.net', '15679084606', '140227197106168690', NULL, '男', 'https://cravatar.cn/avatar/2b631fa9b6457a29110e542c87f13a9f?s=200&d=robohash&f=y', '$2a$10$1fy4SzRV2CsOZaVyrotTke65Y9qScYTMS1UJVMx5xrPmvb3F5ZSg6', NULL, 0, 0, '127.0.0.1', '2024-04-12 21:41:15', 'shiliuyinzhen', '2024-04-12 16:45:35', 'shiliuyinzhen', '2024-04-12 16:45:00', NULL, 1, 0, 0, 0, 0);
INSERT INTO `sys_user` VALUES (1117, 'rgao', '杨桂英', '00', 'ali@example.org', '18675966145', '610103200405289186', NULL, '男', 'https://cravatar.cn/avatar/884998dd9dc0f836c0ff7f97e13a5c81?s=200&d=robohash&f=y', '$2a$10$/uZQp3v98YzRG0gT1XL5suF67rSZySNTmDH1Pj1NthOD2osHOK6Ee', NULL, 0, 0, '127.0.0.1', '2024-04-12 21:41:48', 'shiliuyinzhen', '2024-04-12 16:45:35', 'shiliuyinzhen', '2024-04-12 16:45:00', NULL, 1, 0, 0, 0, 0);
INSERT INTO `sys_user` VALUES (1118, 'ming87', '黄志强', '00', 'gangcao@example.net', '15948567207', '450330198608057270', NULL, '男', 'https://cravatar.cn/avatar/c3218cd6851e5d61751e016bdbaa6355?s=200&d=robohash&f=y', '$2a$10$i1P3Rh082jRMVBwZ7yi1Wu0uThtiL/JtrluEhC0L.qmQclzZ4L7km', NULL, 0, 0, '127.0.0.1', '2024-04-12 21:42:40', 'shiliuyinzhen', '2024-04-12 16:45:35', 'shiliuyinzhen', '2024-04-12 16:45:00', NULL, 1, 0, 0, 0, 0);
INSERT INTO `sys_user` VALUES (1119, 'changmin', '王桂英', '00', 'jiangyong@example.org', '13692689555', '420503195610252094', NULL, '男', 'https://cravatar.cn/avatar/8b65baac740b75ce4acb218553bc5b9d?s=200&d=robohash&f=y', '$2a$10$.iEmCxrisKUBdEHnPqKcb.PtloYy6owJfmZdyzk/VOA.aNOJCJ0UO', NULL, 0, 0, '127.0.0.1', '2024-04-12 21:43:04', 'shiliuyinzhen', '2024-04-12 16:45:35', 'shiliuyinzhen', '2024-04-12 16:45:00', NULL, 1, 0, 0, 0, 0);
INSERT INTO `sys_user` VALUES (1120, 'konglei', '杨海燕', '00', 'gwan@example.org', '15797656747', '653130197301228113', NULL, '男', 'https://cravatar.cn/avatar/57fa8ec4ded9088cdbd3b40419c16088?s=200&d=robohash&f=y', '$2a$10$2cZLYS4FFTGGLyNxn.xGQOC2b/JZLk6Pay.0Q/DLyO6tSYR6AyxVK', NULL, 0, 0, '127.0.0.1', '2024-04-12 21:43:47', 'shiliuyinzhen', '2024-04-12 16:45:36', 'shiliuyinzhen', '2024-04-12 16:45:00', NULL, 1, 0, 0, 0, 0);
INSERT INTO `sys_user` VALUES (1121, 'xuechao', '张璐', '00', 'houqiang@example.org', '14580070374', '340302196409042076', NULL, '男', 'https://cravatar.cn/avatar/1b2b603868438da8d8b1ef4d6d74e85c?s=200&d=robohash&f=y', '$2a$10$zVVAPf7uvTcbj8VFhNZ11eA24A4eQ0ut7jhkYfWN8bJtPTv.EOJlK', NULL, 0, 0, '127.0.0.1', '2024-04-12 21:44:16', 'shiliuyinzhen', '2024-04-12 16:45:36', 'shiliuyinzhen', '2024-04-12 16:45:00', NULL, 1, 0, 0, 0, 0);
INSERT INTO `sys_user` VALUES (1122, 'yongmo', '吴凤兰', '00', 'yan64@example.com', '15516697822', '361027198412152836', NULL, '男', 'https://cravatar.cn/avatar/97c89ab752fc14522694223cb785261a?s=200&d=robohash&f=y', '$2a$10$D.zfzUeK04GzIt5gZGG1EeRCeN0toxiSm53Y0qq1iGKWG/jxEOsIi', NULL, 0, 0, '', NULL, 'shiliuyinzhen', '2024-04-12 16:45:36', 'shiliuyinzhen', '2024-04-12 16:45:36', NULL, 1, 0, 0, 0, 0);
INSERT INTO `sys_user` VALUES (1123, 'swan', '曹丽', '00', 'zouchao@example.net', '15057691413', '210201198212053917', NULL, '男', 'https://cravatar.cn/avatar/ef8ad530cb1f5776b3214c006a3f1e8d?s=200&d=robohash&f=y', '$2a$10$TBLw7txFLl6YMfoGnbsTnOJFLztT6tAQaWFZbCZgR3PnCtawmMy8K', NULL, 0, 0, '', NULL, 'shiliuyinzhen', '2024-04-12 16:45:36', 'shiliuyinzhen', '2024-04-12 16:45:36', NULL, 1, 0, 0, 0, 0);
INSERT INTO `sys_user` VALUES (1124, 'mingchen', '何玉兰', '00', 'wei00@example.org', '13677969894', '640100199306198087', NULL, '男', 'https://cravatar.cn/avatar/1d8dccfc9671f50193f3714c7295895d?s=200&d=robohash&f=y', '$2a$10$zMYV4cxq0CXD0968pd9XtuXhKARMbcjB4Z3Rz0IEyEHBYvEp/nbGy', NULL, 0, 0, '', NULL, 'shiliuyinzhen', '2024-04-12 16:45:36', 'shiliuyinzhen', '2024-04-12 16:45:36', NULL, 1, 0, 0, 0, 0);
INSERT INTO `sys_user` VALUES (1125, 'yyin', '王艳', '00', 'fangzhao@example.org', '18778715947', '34070119901118644X', NULL, '男', 'https://cravatar.cn/avatar/e02446b3a48c521e34c251ca3e1ddbed?s=200&d=robohash&f=y', '$2a$10$oRc5csGKBvFlK12r8MxAw.tOfB32X8CHvCiNs3Yuz0lP2Knu5nPnS', NULL, 0, 0, '', NULL, 'shiliuyinzhen', '2024-04-12 16:45:36', 'shiliuyinzhen', '2024-04-12 16:45:36', NULL, 1, 0, 0, 0, 0);
INSERT INTO `sys_user` VALUES (1126, 'sqiu', '龚想', '00', 'blei@example.org', '18184010155', '150423195605063656', NULL, '男', 'https://cravatar.cn/avatar/a6ca406289c2432a114408605d97457b?s=200&d=robohash&f=y', '$2a$10$kZpONrrAJm3UUfXhTRDp3OEeQ0DWTJ56dOCorZagtLYlKQVWxSDXG', NULL, 0, 0, '', NULL, 'shiliuyinzhen', '2024-04-12 16:45:36', 'shiliuyinzhen', '2024-04-12 16:45:36', NULL, 1, 0, 0, 0, 0);
INSERT INTO `sys_user` VALUES (1127, 'gang55', '冯鑫', '00', 'pingyu@example.com', '18248469883', '441825195209060562', NULL, '男', 'https://cravatar.cn/avatar/60f3166be364831b89bae1554ee63c4c?s=200&d=robohash&f=y', '$2a$10$i0Hi7wDc01bXH1nsyolwBOyfD7a2pREeHVFD/si9IbWeEFrBlOcse', NULL, 0, 0, '', NULL, 'shiliuyinzhen', '2024-04-12 16:45:36', 'shiliuyinzhen', '2024-04-12 16:45:36', NULL, 1, 0, 0, 0, 0);
INSERT INTO `sys_user` VALUES (1128, 'xiajiang', '何宇', '00', 'gang85@example.net', '15239947547', '430400195204065768', NULL, '男', 'https://cravatar.cn/avatar/aeb382fec56ea7b244a26906f0489e28?s=200&d=robohash&f=y', '$2a$10$6sn7LWdVodY7vy25K6Wq3O5Topgy5/pts/PB7M1y/a3IyfU1wmPsm', NULL, 0, 0, '', NULL, 'shiliuyinzhen', '2024-04-12 16:45:36', 'shiliuyinzhen', '2024-04-12 16:45:36', NULL, 1, 0, 0, 0, 0);
INSERT INTO `sys_user` VALUES (1129, 'gdong', '吴帅', '00', 'jie18@example.net', '13872639278', '510812196101313118', NULL, '男', 'https://cravatar.cn/avatar/9463d2d120848619cd3ce98d0e3326ee?s=200&d=robohash&f=y', '$2a$10$riiZfbKBcCJPwenV7yzlve8MiwYowQ43Qz8MtNVGj3XrEAkM2zSha', NULL, 0, 0, '', NULL, 'shiliuyinzhen', '2024-04-12 16:45:37', 'shiliuyinzhen', '2024-04-12 16:45:37', NULL, 1, 0, 0, 0, 0);
INSERT INTO `sys_user` VALUES (1130, 'zz', 'zz', '00', '123@qq.com', '18311111114', NULL, NULL, '男', '', '$2a$10$z.CdVVD2liGc9VxXXNIjcOMjtKa6PjF/V4E5zRTmgy/hv0vVnPL0K', NULL, 0, 0, '', NULL, '', '2024-10-02 19:32:20', '', '2024-10-02 19:32:20', NULL, 1, 0, 0, 0, 0);
INSERT INTO `sys_user` VALUES (1131, 'aas', 'aaa', '00', '123@qq.com', '18311111114', NULL, NULL, '男', '', '$2a$10$iTCjHPpc.rJw47YqQF8e2eTzyEt.LuAF6z50QWHJ0AxXOx6ZYmIKm', NULL, 0, 0, '', NULL, '', '2024-10-02 19:35:15', '', '2024-10-02 19:35:15', NULL, 1, 0, 0, 0, 0);

SET FOREIGN_KEY_CHECKS = 1;
