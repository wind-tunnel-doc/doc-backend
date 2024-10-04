/*
 Navicat Premium Data Transfer

 Source Server         : 本机MySQL
 Source Server Type    : MySQL
 Source Server Version : 80033 (8.0.33)
 Source Host           : localhost:3306
 Source Schema         : doc_nacos_config

 Target Server Type    : MySQL
 Target Server Version : 80033 (8.0.33)
 File Encoding         : 65001

 Date: 03/10/2024 18:19:07
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for config_info
-- ----------------------------
DROP TABLE IF EXISTS `config_info`;
CREATE TABLE `config_info`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT 'id',
  `data_id` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL COMMENT 'data_id',
  `group_id` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NULL DEFAULT NULL,
  `content` longtext CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL COMMENT 'content',
  `md5` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NULL DEFAULT NULL COMMENT 'md5',
  `gmt_create` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `gmt_modified` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '修改时间',
  `src_user` text CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NULL COMMENT 'source user',
  `src_ip` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NULL DEFAULT NULL COMMENT 'source ip',
  `app_name` varchar(128) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NULL DEFAULT NULL,
  `tenant_id` varchar(128) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NULL DEFAULT '' COMMENT '租户字段',
  `c_desc` varchar(256) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NULL DEFAULT NULL,
  `c_use` varchar(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NULL DEFAULT NULL,
  `effect` varchar(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NULL DEFAULT NULL,
  `type` varchar(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NULL DEFAULT NULL,
  `c_schema` text CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NULL,
  `encrypted_data_key` text CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NULL COMMENT '秘钥',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_configinfo_datagrouptenant`(`data_id` ASC, `group_id` ASC, `tenant_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 191 CHARACTER SET = utf8mb3 COLLATE = utf8mb3_bin COMMENT = 'config_info' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of config_info
-- ----------------------------
INSERT INTO `config_info` VALUES (1, 'application-dev.yml', 'DEFAULT_GROUP', 'spring:\n  autoconfigure:\n    exclude: com.alibaba.druid.spring.boot.autoconfigure.DruidDataSourceAutoConfigure\n  mvc:\n    pathmatch:\n      matching-strategy: ant_path_matcher\n\n# feign 配置\nfeign:\n  sentinel:\n    enabled: true\n  okhttp:\n    enabled: true\n  httpclient:\n    enabled: true\n  client:\n    config:\n      default:\n        connectTimeout: 10000\n        readTimeout: 10000\n  compression:\n    request:\n      enabled: true\n      min-request-size: 8192\n    response:\n      enabled: true\n\n#rabbitmq 配置\n# rabbitmq:\n#   host: localhost\n#   port: 5627\n#   username: guest\n#   password: guest\n#   template:\n#       receive-timeout: 30000\n#       reply-timeout: 30000\n#   virtual-host: /\n#   # 发送者开启 confirm 确认机制\n#   publisher-confirm-type: correlated\n#   # 发送者开启 return 确认机制\n#   publisher-returns: true\n#   # 设置消费端手动 ack\n#   listener:\n#     simple:\n#       #手动应答\n#       acknowledge-mode: manual\n#       #消费端最小并发数\n#       concurrency: 5\n#       #消费端最大并发数\n#       max-concurrency: 10\n#       #一次请求中预处理的消息数量\n#       prefetch: 5\n#       # 是否支持重试\n#       retry:\n#         #启用消费重试\n#         enabled: true\n#         #重试次数\n#         max-attempts: 3\n#         #重试间隔时间\n#         initial-interval: 3000\n#     cache:\n#       channel:\n#         #缓存的channel数量\n#         size: 50\n        \n# 暴露监控端点\nmanagement:\n  endpoints:\n    web:\n      exposure:\n        include: \'*\'\n', 'a6ddd5afe18893038c8001c581786660', '2020-05-20 12:00:00', '2024-10-02 07:05:17', 'nacos', '127.0.0.1', '', '', '通用配置', 'null', 'null', 'yaml', '', '');
INSERT INTO `config_info` VALUES (2, 'doc-gateway-dev.yml', 'DEFAULT_GROUP', 'spring:\n  redis:\n    host: localhost\n    port: 6379\n    # password:\n  cloud:\n    gateway:\n      discovery:\n        locator:\n          lowerCaseServiceId: true\n          enabled: true\n      routes:\n        # 认证中心\n        - id: doc-auth\n          uri: lb://doc-auth\n          predicates:\n            - Path=/auth/**\n          filters:\n            # 验证码处理\n            - CacheRequestFilter\n            - ValidateCodeFilter\n            - StripPrefix=1\n        # 定时任务\n        - id: doc-job\n          uri: lb://doc-job\n          predicates:\n            - Path=/schedule/**\n          filters:\n            - StripPrefix=1\n        # 系统模块\n        - id: doc-system\n          uri: lb://doc-system\n          predicates:\n            - Path=/system/**\n          filters:\n            - StripPrefix=1\n        # 文件服务\n        - id: doc-file\n          uri: lb://doc-file\n          predicates:\n            - Path=/file/**\n          filters:\n            - StripPrefix=1\n        # websocket服务\n        - id: doc-websocket\n          uri: lb://doc-websocket\n          predicates:\n            - Path=/websocket/**\n          filters:\n            - StripPrefix=1\n# 安全配置\nsecurity:\n  # 验证码\n  captcha:\n    enabled: true\n    type: char\n  # 防止XSS攻击\n  xss:\n    enabled: true\n    excludeUrls:\n      - /system/notice\n  # 不校验白名单\n  ignore:\n    whites:\n      - /auth/login\n      - /auth/register\n      - /auth/email/code\n      - /websocket/**\n      - /*/v2/api-docs\n      - /csrf\n', '21c2f2f2d8935727ad7421df14a326fb', '2020-05-14 14:17:55', '2024-10-02 07:11:17', 'nacos', '127.0.0.1', '', '', '网关模块', 'null', 'null', 'yaml', '', '');
INSERT INTO `config_info` VALUES (3, 'doc-auth-dev.yml', 'DEFAULT_GROUP', 'spring:\n  redis:\n    host: localhost\n    port: 6379\n    # password:\n', 'a28d798d2ff81830b4a389929719a8a6', '2020-11-20 00:00:00', '2024-03-12 09:29:25', '', '127.0.0.1', '', '', '认证中心', 'null', 'null', 'yaml', '', '');
INSERT INTO `config_info` VALUES (5, 'doc-system-dev.yml', 'DEFAULT_GROUP', '# spring配置\nspring:\n  # redis 配置\n  redis:\n    host: localhost\n    port: 6379\n    # password:\n  datasource:\n    druid:\n      stat-view-servlet:\n        enabled: true\n        loginUsername: admin\n        loginPassword: 123456\n    dynamic:\n      druid:\n        initial-size: 5\n        min-idle: 5\n        maxActive: 20\n        maxWait: 60000\n        connectTimeout: 30000\n        socketTimeout: 60000\n        timeBetweenEvictionRunsMillis: 60000\n        minEvictableIdleTimeMillis: 300000\n        validationQuery: SELECT 1 FROM DUAL\n        testWhileIdle: true\n        testOnBorrow: false\n        testOnReturn: false\n        poolPreparedStatements: true\n        maxPoolPreparedStatementPerConnectionSize: 20\n        filters: stat,slf4j\n        connectionProperties: druid.stat.mergeSql\\=true;druid.stat.slowSqlMillis\\=5000\n      datasource:\n        # 主库数据源\n        master:\n          driver-class-name: com.mysql.cj.jdbc.Driver\n          url: jdbc:mysql://localhost:3306/doc?useUnicode=true&characterEncoding=utf8&zeroDateTimeBehavior=convertToNull&useSSL=true&serverTimezone=GMT%2B8\n          username: root\n          password: 962464\n        # 从库数据源\n        # slave:\n        #   driver-class-name: com.mysql.cj.jdbc.Driver\n        #   url: jdbc:mysql://localhost:3306/doc_quartz?useUnicode=true&characterEncoding=utf8&zeroDateTimeBehavior=convertToNull&useSSL=true&serverTimezone=GMT%2B8\n        #   username: root\n        #   password: 962464 \n\n  #rabbitmq 配置\n  # rabbitmq:\n  #   host: localhost\n  #   port: 5672\n  #   username: guest\n  #   password: guest\n  #   template:\n  #       receive-timeout: 30000\n  #       reply-timeout: 30000\n  #   virtual-host: /\n  #   # 发送者开启 confirm 确认机制\n  #   publisher-confirm-type: correlated\n  #   # 发送者开启 return 确认机制\n  #   publisher-returns: true\n  #   # 设置消费端手动 ack\n  #   listener:\n  #     simple:\n  #       #手动应答\n  #       acknowledge-mode: manual\n  #       #消费端最小并发数\n  #       concurrency: 5\n  #       #消费端最大并发数\n  #       max-concurrency: 10\n  #       #一次请求中预处理的消息数量\n  #       prefetch: 5\n  #       # 是否支持重试\n  #       retry:\n  #         #启用消费重试\n  #         enabled: true\n  #         #重试次数\n  #         max-attempts: 3\n  #         #重试间隔时间\n  #         initial-interval: 3000\n  #     cache:\n  #       channel:\n  #         #缓存的channel数量\n  #         size: 50\n              \n# mybatis配置\nmybatis:\n    # 搜索指定包别名\n    typeAliasesPackage: com.doc.system\n    # 配置mapper的扫描，找到所有的mapper.xml映射文件\n    mapperLocations: classpath:mapper/*.xml\n\n# swagger配置\nswagger:\n  title: 系统模块接口文档\n  license: Powered By Wind Tunnel\n  licenseUrl: https://WindTunnel.vip', 'f8f0644d1a6f84dcb9e4d28f94223ffb', '2020-11-20 00:00:00', '2024-10-02 07:23:52', 'nacos', '127.0.0.1', '', '', '系统模块', 'null', 'null', 'yaml', '', '');
INSERT INTO `config_info` VALUES (6, 'doc-job-dev.yml', 'DEFAULT_GROUP', '# spring配置\nspring:\n  redis:\n    host: localhost\n    port: 6379\n    # password: \n  datasource:\n    driver-class-name: com.mysql.cj.jdbc.Driver\n    url: jdbc:mysql://localhost:3306/doc?useUnicode=true&characterEncoding=utf8&zeroDateTimeBehavior=convertToNull&useSSL=true&serverTimezone=GMT%2B8\n    username: root\n    password: 962464\n\n# mybatis配置\nmybatis:\n    # 搜索指定包别名\n    typeAliasesPackage: com.doc.job.pojo\n    # 配置mapper的扫描，找到所有的mapper.xml映射文件\n    mapperLocations: classpath:mapper/*.xml\n\n# swagger配置\nswagger:\n  title: 定时任务接口文档\n  license: Powered By WindTunnel\n  licenseUrl: https://WindTunnel.vip\n', 'b61dbc99311d79fc06d524d23d5300a2', '2020-11-20 00:00:00', '2024-10-02 07:24:12', 'nacos', '127.0.0.1', '', '', '定时任务', 'null', 'null', 'yaml', '', '');
INSERT INTO `config_info` VALUES (7, 'doc-file-dev.yml', 'DEFAULT_GROUP', '# 本地文件上传    \nlocal:\n  domain: http://localhost:9201\n  path: E:/java/java_projects/doc/doc-modules/doc-file/src/main/resources\n  prefix: /statics\n\n# alioss 配置\nalioss:\n  endpoint: oss-cn-beijing.aliyuncs.com\n  accessKeyId: LTAI5tBUn4GwgNjWPD4VEfQy\n  accessKeySecret: wiSbIPgzDtt1aFnIxQkqZiH0rCYVcR\n  bucketName: wind-tunnel-doc', '596b205fc3462227797baaa653011304', '2020-11-20 00:00:00', '2024-10-02 07:31:34', 'nacos', '127.0.0.1', '', '', '文件服务', 'null', 'null', 'yaml', '', '');
INSERT INTO `config_info` VALUES (8, 'sentinel-doc-gateway', 'DEFAULT_GROUP', '[\n    {\n        \"resource\": \"doc-auth\",\n        \"count\": 500,\n        \"grade\": 1,\n        \"limitApp\": \"default\",\n        \"strategy\": 0,\n        \"controlBehavior\": 0\n    },\n	{\n        \"resource\": \"doc-system\",\n        \"count\": 1000,\n        \"grade\": 1,\n        \"limitApp\": \"default\",\n        \"strategy\": 0,\n        \"controlBehavior\": 0\n    },\n	{\n        \"resource\": \"doc-websocket\",\n        \"count\": 200,\n        \"grade\": 1,\n        \"limitApp\": \"default\",\n        \"strategy\": 0,\n        \"controlBehavior\": 0\n    },\n	{\n        \"resource\": \"doc-job\",\n        \"count\": 300,\n        \"grade\": 1,\n        \"limitApp\": \"default\",\n        \"strategy\": 0,\n        \"controlBehavior\": 0\n    }\n]', '1f20eb848f90d40978e1c3fe421b1a31', '2020-11-20 00:00:00', '2024-10-02 07:20:43', 'nacos', '127.0.0.1', '', '', '限流策略', 'null', 'null', 'json', '', '');
INSERT INTO `config_info` VALUES (11, 'doc-websocket-dev.yml', 'DEFAULT_GROUP', 'spring:\n  redis:\n    host: localhost\n    port: 6379\n    # password:\n  datasource:\n    druid:\n      stat-view-servlet:\n        enabled: true\n        loginUsername: admin\n        loginPassword: 123456\n    dynamic:\n      druid:\n        initial-size: 5\n        min-idle: 5\n        maxActive: 20\n        maxWait: 60000\n        connectTimeout: 30000\n        socketTimeout: 60000\n        timeBetweenEvictionRunsMillis: 60000\n        minEvictableIdleTimeMillis: 300000\n        validationQuery: SELECT 1 FROM DUAL\n        testWhileIdle: true\n        testOnBorrow: false\n        testOnReturn: false\n        poolPreparedStatements: true\n        maxPoolPreparedStatementPerConnectionSize: 20\n        filters: stat,slf4j\n        connectionProperties: druid.stat.mergeSql\\=true;druid.stat.slowSqlMillis\\=5000\n      datasource:\n          # 主库数据源\n          master:\n            driver-class-name: com.mysql.cj.jdbc.Driver\n            url: jdbc:mysql://localhost:3306/doc?useUnicode=true&characterEncoding=utf8&zeroDateTimeBehavior=convertToNull&useSSL=true&serverTimezone=GMT%2B8\n            username: root\n            password: 962464\n\n# mybatis配置\nmybatis:\n  # 搜索指定包别名\n  typeAliasesPackage: com.doc.websocket.pojo\n  # 配置mapper的扫描，找到所有的mapper.xml映射文件\n  mapperLocations: classpath:mapper/*.xml\n  configuration:\n    map-underscore-to-camel-case: true\n    \n# swagger配置\nswagger:\n  title: websocket模块接口文档\n  license: Powered By WindTunnel\n  licenseUrl: https://WindTunnel.vip', '2247e8908258a4caf98d3c9b778c91f6', '2024-03-12 08:32:09', '2024-10-02 07:21:06', 'nacos', '127.0.0.1', '', '', 'websocket模块\n', '', '', 'yaml', '', '');

-- ----------------------------
-- Table structure for config_info_aggr
-- ----------------------------
DROP TABLE IF EXISTS `config_info_aggr`;
CREATE TABLE `config_info_aggr`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT 'id',
  `data_id` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL COMMENT 'data_id',
  `group_id` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL COMMENT 'group_id',
  `datum_id` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL COMMENT 'datum_id',
  `content` longtext CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL COMMENT '内容',
  `gmt_modified` datetime NOT NULL COMMENT '修改时间',
  `app_name` varchar(128) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NULL DEFAULT NULL,
  `tenant_id` varchar(128) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NULL DEFAULT '' COMMENT '租户字段',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_configinfoaggr_datagrouptenantdatum`(`data_id` ASC, `group_id` ASC, `tenant_id` ASC, `datum_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb3 COLLATE = utf8mb3_bin COMMENT = '增加租户字段' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of config_info_aggr
-- ----------------------------

-- ----------------------------
-- Table structure for config_info_beta
-- ----------------------------
DROP TABLE IF EXISTS `config_info_beta`;
CREATE TABLE `config_info_beta`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT 'id',
  `data_id` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL COMMENT 'data_id',
  `group_id` varchar(128) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL COMMENT 'group_id',
  `app_name` varchar(128) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NULL DEFAULT NULL COMMENT 'app_name',
  `content` longtext CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL COMMENT 'content',
  `beta_ips` varchar(1024) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NULL DEFAULT NULL COMMENT 'betaIps',
  `md5` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NULL DEFAULT NULL COMMENT 'md5',
  `gmt_create` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `gmt_modified` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '修改时间',
  `src_user` text CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NULL COMMENT 'source user',
  `src_ip` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NULL DEFAULT NULL COMMENT 'source ip',
  `tenant_id` varchar(128) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NULL DEFAULT '' COMMENT '租户字段',
  `encrypted_data_key` text CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NULL COMMENT '秘钥',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_configinfobeta_datagrouptenant`(`data_id` ASC, `group_id` ASC, `tenant_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb3 COLLATE = utf8mb3_bin COMMENT = 'config_info_beta' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of config_info_beta
-- ----------------------------

-- ----------------------------
-- Table structure for config_info_tag
-- ----------------------------
DROP TABLE IF EXISTS `config_info_tag`;
CREATE TABLE `config_info_tag`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT 'id',
  `data_id` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL COMMENT 'data_id',
  `group_id` varchar(128) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL COMMENT 'group_id',
  `tenant_id` varchar(128) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NULL DEFAULT '' COMMENT 'tenant_id',
  `tag_id` varchar(128) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL COMMENT 'tag_id',
  `app_name` varchar(128) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NULL DEFAULT NULL COMMENT 'app_name',
  `content` longtext CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL COMMENT 'content',
  `md5` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NULL DEFAULT NULL COMMENT 'md5',
  `gmt_create` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `gmt_modified` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '修改时间',
  `src_user` text CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NULL COMMENT 'source user',
  `src_ip` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NULL DEFAULT NULL COMMENT 'source ip',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_configinfotag_datagrouptenanttag`(`data_id` ASC, `group_id` ASC, `tenant_id` ASC, `tag_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb3 COLLATE = utf8mb3_bin COMMENT = 'config_info_tag' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of config_info_tag
-- ----------------------------

-- ----------------------------
-- Table structure for config_tags_relation
-- ----------------------------
DROP TABLE IF EXISTS `config_tags_relation`;
CREATE TABLE `config_tags_relation`  (
  `id` bigint NOT NULL COMMENT 'id',
  `tag_name` varchar(128) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL COMMENT 'tag_name',
  `tag_type` varchar(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NULL DEFAULT NULL COMMENT 'tag_type',
  `data_id` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL COMMENT 'data_id',
  `group_id` varchar(128) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL COMMENT 'group_id',
  `tenant_id` varchar(128) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NULL DEFAULT '' COMMENT 'tenant_id',
  `nid` bigint NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`nid`) USING BTREE,
  UNIQUE INDEX `uk_configtagrelation_configidtag`(`id` ASC, `tag_name` ASC, `tag_type` ASC) USING BTREE,
  INDEX `idx_tenant_id`(`tenant_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb3 COLLATE = utf8mb3_bin COMMENT = 'config_tag_relation' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of config_tags_relation
-- ----------------------------

-- ----------------------------
-- Table structure for group_capacity
-- ----------------------------
DROP TABLE IF EXISTS `group_capacity`;
CREATE TABLE `group_capacity`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `group_id` varchar(128) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL DEFAULT '' COMMENT 'Group ID，空字符表示整个集群',
  `quota` int UNSIGNED NOT NULL DEFAULT 0 COMMENT '配额，0表示使用默认值',
  `usage` int UNSIGNED NOT NULL DEFAULT 0 COMMENT '使用量',
  `max_size` int UNSIGNED NOT NULL DEFAULT 0 COMMENT '单个配置大小上限，单位为字节，0表示使用默认值',
  `max_aggr_count` int UNSIGNED NOT NULL DEFAULT 0 COMMENT '聚合子配置最大个数，，0表示使用默认值',
  `max_aggr_size` int UNSIGNED NOT NULL DEFAULT 0 COMMENT '单个聚合数据的子配置大小上限，单位为字节，0表示使用默认值',
  `max_history_count` int UNSIGNED NOT NULL DEFAULT 0 COMMENT '最大变更历史数量',
  `gmt_create` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `gmt_modified` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '修改时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_group_id`(`group_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb3 COLLATE = utf8mb3_bin COMMENT = '集群、各Group容量信息表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of group_capacity
-- ----------------------------

-- ----------------------------
-- Table structure for his_config_info
-- ----------------------------
DROP TABLE IF EXISTS `his_config_info`;
CREATE TABLE `his_config_info`  (
  `id` bigint UNSIGNED NOT NULL,
  `nid` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `data_id` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL,
  `group_id` varchar(128) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL,
  `app_name` varchar(128) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NULL DEFAULT NULL COMMENT 'app_name',
  `content` longtext CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL,
  `md5` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NULL DEFAULT NULL,
  `gmt_create` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `gmt_modified` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `src_user` text CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NULL,
  `src_ip` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NULL DEFAULT NULL,
  `op_type` char(10) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NULL DEFAULT NULL,
  `tenant_id` varchar(128) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NULL DEFAULT '' COMMENT '租户字段',
  `encrypted_data_key` text CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NULL COMMENT '秘钥',
  PRIMARY KEY (`nid`) USING BTREE,
  INDEX `idx_gmt_create`(`gmt_create` ASC) USING BTREE,
  INDEX `idx_gmt_modified`(`gmt_modified` ASC) USING BTREE,
  INDEX `idx_did`(`data_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 192 CHARACTER SET = utf8mb3 COLLATE = utf8mb3_bin COMMENT = '多租户改造' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of his_config_info
-- ----------------------------
INSERT INTO `his_config_info` VALUES (4, 176, 'doc-monitor-dev.yml', 'DEFAULT_GROUP', '', '# spring\nspring:\n  security:\n    user:\n      name: timebank\n      password: 123456\n  boot:\n    admin:\n      ui:\n        title: 时间银行服务状态监控\n', 'be8498d06733dcbd804e3b58fcacb898', '2024-10-02 15:04:10', '2024-10-02 07:04:11', NULL, '127.0.0.1', 'D', '', '');
INSERT INTO `his_config_info` VALUES (9, 177, 'timebank-volunteer-dev.yml', 'DEFAULT_GROUP', '', '# spring配置\nspring:\n  redis:\n    host: localhost\n    port: 6379\n    # password:\n  elasticsearch:\n    uris: 127.0.0.1:9200\n    username:\n    password:\n  datasource:\n    druid:\n      stat-view-servlet:\n        enabled: true\n        loginUsername: admin\n        loginPassword: 123456\n    dynamic:\n      druid:\n        initial-size: 5\n        min-idle: 5\n        maxActive: 20\n        maxWait: 60000\n        connectTimeout: 30000\n        socketTimeout: 60000\n        timeBetweenEvictionRunsMillis: 60000\n        minEvictableIdleTimeMillis: 300000\n        validationQuery: SELECT 1 FROM DUAL\n        testWhileIdle: true\n        testOnBorrow: false\n        testOnReturn: false\n        poolPreparedStatements: true\n        maxPoolPreparedStatementPerConnectionSize: 20\n        filters: stat,slf4j\n        connectionProperties: druid.stat.mergeSql\\=true;druid.stat.slowSqlMillis\\=5000\n      datasource:\n        # 主库数据源\n        master:\n          driver-class-name: com.mysql.cj.jdbc.Driver\n          url: jdbc:mysql://localhost:3306/timebank?useUnicode=true&characterEncoding=utf8&zeroDateTimeBehavior=convertToNull&useSSL=true&serverTimezone=GMT%2B8\n          username: root\n          password: 962464\n  #rabbitmq 配置\n  rabbitmq:\n    host: localhost\n    port: 5672\n    username: guest\n    password: guest\n    template:\n        receive-timeout: 30000\n        reply-timeout: 30000\n    virtual-host: /\n    # 发送者开启 confirm 确认机制\n    publisher-confirm-type: correlated\n    # 发送者开启 return 确认机制\n    publisher-returns: true\n    # 设置消费端手动 ack\n    listener:\n      simple:\n        #手动应答\n        acknowledge-mode: manual\n        #消费端最小并发数\n        concurrency: 5\n        #消费端最大并发数\n        max-concurrency: 10\n        #一次请求中预处理的消息数量\n        prefetch: 5\n        # 是否支持重试\n        retry:\n          #启用消费重试\n          enabled: true\n          #重试次数\n          max-attempts: 3\n          #重试间隔时间\n          initial-interval: 3000\n      cache:\n        channel:\n          #缓存的channel数量\n          size: 50\n       \n# mybatis配置\nmybatis:\n    # 搜索指定包别名\n    typeAliasesPackage: com.timebank.volunteer.pojo\n    # 配置mapper的扫描，找到所有的mapper.xml映射文件\n    mapperLocations: classpath:mapper/*.xml\n\n# 高德地图配置\ngaode:\n  key: 5636b0e2be833e234ce3d70d451d4cf6\n\n# swagger配置\nswagger:\n  title: 志愿服务模块接口文档\n  license: Powered By timebank\n  licenseUrl: https://timebank.vip', '0dc746f2a287e7385cbb44e1dd21b37e', '2024-10-02 15:04:32', '2024-10-02 07:04:33', NULL, '127.0.0.1', 'D', '', '');
INSERT INTO `his_config_info` VALUES (10, 178, 'timebank-timecoin-dev.yml', 'DEFAULT_GROUP', '', '# spring配置\nspring:\n  redis:\n    host: localhost\n    port: 6379\n    # password:\n  datasource:\n    druid:\n      stat-view-servlet:\n        enabled: true\n        loginUsername: admin\n        loginPassword: 123456\n    dynamic:\n      druid:\n        initial-size: 5\n        min-idle: 5\n        maxActive: 20\n        maxWait: 60000\n        connectTimeout: 30000\n        socketTimeout: 60000\n        timeBetweenEvictionRunsMillis: 60000\n        minEvictableIdleTimeMillis: 300000\n        validationQuery: SELECT 1 FROM DUAL\n        testWhileIdle: true\n        testOnBorrow: false\n        testOnReturn: false\n        poolPreparedStatements: true\n        maxPoolPreparedStatementPerConnectionSize: 20\n        filters: stat,slf4j\n        connectionProperties: druid.stat.mergeSql\\=true;druid.stat.slowSqlMillis\\=5000\n      datasource:\n          # 主库数据源\n          master:\n            driver-class-name: com.mysql.cj.jdbc.Driver\n            url: jdbc:mysql://localhost:3306/timebank?useUnicode=true&characterEncoding=utf8&zeroDateTimeBehavior=convertToNull&useSSL=true&serverTimezone=GMT%2B8\n            username: root\n            password: 962464\n            \n# fabric配置\nfabric:\n  # 通道名\n  channelName: mychannel\n  # 智能合约名\n  contractName: mycc-go\n  # fabric连接文件路径\n  networkConfigPath: timebank-modules/timebank-timecoin/src/main/resources/connection.json\n  # fabric证书文件路径\n  certificatePath: timebank-modules/timebank-timecoin/src/main/resources/crypto-config/peerOrganizations/org1.example.com/users/Admin@org1.example.com/msp/signcerts/Admin@org1.example.com-cert.pem\n  # fabric私钥文件路径\n  privateKeyPath: timebank-modules/timebank-timecoin/src/main/resources/crypto-config/peerOrganizations/org1.example.com/users/Admin@org1.example.com/msp/keystore/priv_sk\n\n# swagger配置\nswagger:\n  title: 时间币模块接口文档\n  license: Powered By timebank\n  licenseUrl: https://timebank.vip', '0b9c5ead69b76b26ebc89e59b6a5f94e', '2024-10-02 15:04:39', '2024-10-02 07:04:39', NULL, '127.0.0.1', 'D', '', '');
INSERT INTO `his_config_info` VALUES (12, 179, 'doc-score-dev.yml', 'DEFAULT_GROUP', '', '# spring配置\nspring:\n  redis:\n    host: localhost\n    port: 6379\n    # password:\n  datasource:\n    druid:\n      stat-view-servlet:\n        enabled: true\n        loginUsername: admin\n        loginPassword: 123456\n    dynamic:\n      druid:\n        initial-size: 5\n        min-idle: 5\n        maxActive: 20\n        maxWait: 60000\n        connectTimeout: 30000\n        socketTimeout: 60000\n        timeBetweenEvictionRunsMillis: 60000\n        minEvictableIdleTimeMillis: 300000\n        validationQuery: SELECT 1 FROM DUAL\n        testWhileIdle: true\n        testOnBorrow: false\n        testOnReturn: false\n        poolPreparedStatements: true\n        maxPoolPreparedStatementPerConnectionSize: 20\n        filters: stat,slf4j\n        connectionProperties: druid.stat.mergeSql\\=true;druid.stat.slowSqlMillis\\=5000\n      datasource:\n        # 主库数据源\n        master:\n          driver-class-name: com.mysql.cj.jdbc.Driver\n          url: jdbc:mysql://localhost:3306/timebank?useUnicode=true&characterEncoding=utf8&zeroDateTimeBehavior=convertToNull&useSSL=true&serverTimezone=GMT%2B8\n          username: root\n          password: 962464\n  #rabbitmq 配置\n  rabbitmq:\n    host: localhost\n    port: 5672\n    username: guest\n    password: guest\n    template:\n        receive-timeout: 30000\n        reply-timeout: 30000\n    virtual-host: /\n    # 发送者开启 confirm 确认机制\n    publisher-confirm-type: correlated\n    # 发送者开启 return 确认机制\n    publisher-returns: true\n    # 设置消费端手动 ack\n    listener:\n      simple:\n        #手动应答\n        acknowledge-mode: manual\n        #消费端最小并发数\n        concurrency: 5\n        #消费端最大并发数\n        max-concurrency: 10\n        #一次请求中预处理的消息数量\n        prefetch: 5\n        # 是否支持重试\n        retry:\n          #启用消费重试\n          enabled: true\n          #重试次数\n          max-attempts: 3\n          #重试间隔时间\n          initial-interval: 3000\n      cache:\n        channel:\n          #缓存的channel数量\n          size: 50\n               \n# mybatis配置\nmybatis:\n    # 搜索指定包别名\n    typeAliasesPackage: com.timebank.score.pojo\n    # 配置mapper的扫描，找到所有的mapper.xml映射文件\n    mapperLocations: classpath:mapper/*.xml\n\n# swagger配置\nswagger:\n  title: 积分商城模块接口文档\n  license: Powered By timebank\n  licenseUrl: https://timebank.vip', '5ee51be7e1622a0844e2a519d7ae9573', '2024-10-02 15:04:43', '2024-10-02 07:04:44', NULL, '127.0.0.1', 'D', '', '');
INSERT INTO `his_config_info` VALUES (1, 180, 'application-dev.yml', 'DEFAULT_GROUP', '', 'spring:\n  autoconfigure:\n    exclude: com.alibaba.druid.spring.boot.autoconfigure.DruidDataSourceAutoConfigure\n  mvc:\n    pathmatch:\n      matching-strategy: ant_path_matcher\n\n# feign 配置\nfeign:\n  sentinel:\n    enabled: true\n  okhttp:\n    enabled: true\n  httpclient:\n    enabled: true\n  client:\n    config:\n      default:\n        connectTimeout: 10000\n        readTimeout: 10000\n  compression:\n    request:\n      enabled: true\n      min-request-size: 8192\n    response:\n      enabled: true\n\n#rabbitmq 配置\nrabbitmq:\n  host: localhost\n  port: 5627\n  username: guest\n  password: guest\n  template:\n      receive-timeout: 30000\n      reply-timeout: 30000\n  virtual-host: /\n  # 发送者开启 confirm 确认机制\n  publisher-confirm-type: correlated\n  # 发送者开启 return 确认机制\n  publisher-returns: true\n  # 设置消费端手动 ack\n  listener:\n    simple:\n      #手动应答\n      acknowledge-mode: manual\n      #消费端最小并发数\n      concurrency: 5\n      #消费端最大并发数\n      max-concurrency: 10\n      #一次请求中预处理的消息数量\n      prefetch: 5\n      # 是否支持重试\n      retry:\n        #启用消费重试\n        enabled: true\n        #重试次数\n        max-attempts: 3\n        #重试间隔时间\n        initial-interval: 3000\n    cache:\n      channel:\n        #缓存的channel数量\n        size: 50\n        \n# 暴露监控端点\nmanagement:\n  endpoints:\n    web:\n      exposure:\n        include: \'*\'\n', '91aa2982915e8a2aa5267c5575689b22', '2024-10-02 15:05:17', '2024-10-02 07:05:17', 'nacos', '127.0.0.1', 'U', '', '');
INSERT INTO `his_config_info` VALUES (2, 181, 'doc-gateway-dev.yml', 'DEFAULT_GROUP', '', 'spring:\n  redis:\n    host: localhost\n    port: 6379\n    # password:\n  cloud:\n    gateway:\n      discovery:\n        locator:\n          lowerCaseServiceId: true\n          enabled: true\n      routes:\n        # 认证中心\n        - id: timebank-auth\n          uri: lb://timebank-auth\n          predicates:\n            - Path=/auth/**\n          filters:\n            # 验证码处理\n            - CacheRequestFilter\n            - ValidateCodeFilter\n            - StripPrefix=1\n        # 定时任务\n        - id: timebank-job\n          uri: lb://timebank-job\n          predicates:\n            - Path=/schedule/**\n          filters:\n            - StripPrefix=1\n        # 系统模块\n        - id: timebank-system\n          uri: lb://timebank-system\n          predicates:\n            - Path=/system/**\n          filters:\n            - StripPrefix=1\n        # 文件服务\n        - id: timebank-file\n          uri: lb://timebank-file\n          predicates:\n            - Path=/file/**\n          filters:\n            - StripPrefix=1\n        # 志愿服务\n        - id: timebank-volunteer\n          uri: lb://timebank-volunteer\n          predicates:\n            - Path=/volunteer/**\n          filters:\n            - StripPrefix=1\n        # 时间币服务\n        - id: timebank-timecoin\n          uri: lb://timebank-timecoin\n          predicates:\n            - Path=/timecoin/**\n          filters:\n            - StripPrefix=1\n        # 积分商城服务\n        - id: timebank-score\n          uri: lb://timebank-score\n          predicates:\n            - Path=/score/**\n          filters:\n            - StripPrefix=1\n        # websocket服务\n        - id: timebank-websocket\n          uri: lb://timebank-websocket\n          predicates:\n            - Path=/websocket/**\n          filters:\n            - StripPrefix=1\n# 安全配置\nsecurity:\n  # 验证码\n  captcha:\n    enabled: true\n    type: char\n  # 防止XSS攻击\n  xss:\n    enabled: true\n    excludeUrls:\n      - /system/notice\n  # 不校验白名单\n  ignore:\n    whites:\n      - /auth/login\n      - /auth/register\n      - /auth/email/code\n      - /system/sign/**\n      - /volunteer/service/list\n      - /volunteer/type/list\n      - /volunteer/service/*\n      - /score/goods/list\n      - /score/goodstype/list\n      - /websocket/**\n      - /*/v2/api-docs\n      - /csrf\n', '5bdf33a8ae7554e945fd5862b0b2c7ad', '2024-10-02 15:08:44', '2024-10-02 07:08:44', 'nacos', '127.0.0.1', 'U', '', '');
INSERT INTO `his_config_info` VALUES (2, 182, 'doc-gateway-dev.yml', 'DEFAULT_GROUP', '', 'spring:\n  redis:\n    host: localhost\n    port: 6379\n    # password:\n  cloud:\n    gateway:\n      discovery:\n        locator:\n          lowerCaseServiceId: true\n          enabled: true\n      routes:\n        # 认证中心\n        - id: doc-auth\n          uri: lb://doc-auth\n          predicates:\n            - Path=/auth/**\n          filters:\n            # 验证码处理\n            - CacheRequestFilter\n            - ValidateCodeFilter\n            - StripPrefix=1\n        # 定时任务\n        - id: doc-job\n          uri: lb://doc-job\n          predicates:\n            - Path=/schedule/**\n          filters:\n            - StripPrefix=1\n        # 系统模块\n        - id: doc-system\n          uri: lb://doc-system\n          predicates:\n            - Path=/system/**\n          filters:\n            - StripPrefix=1\n        # 文件服务\n        - id: doc-file\n          uri: lb://doc-file\n          predicates:\n            - Path=/file/**\n          filters:\n            - StripPrefix=1\n        # websocket服务\n        - id: doc-websocket\n          uri: lb://doc-websocket\n          predicates:\n            - Path=/websocket/**\n          filters:\n            - StripPrefix=1\n# 安全配置\nsecurity:\n  # 验证码\n  captcha:\n    enabled: true\n    type: char\n  # 防止XSS攻击\n  xss:\n    enabled: true\n    excludeUrls:\n      - /system/notice\n  # 不校验白名单\n  ignore:\n    whites:\n      - /auth/login\n      - /auth/register\n      - /auth/email/code\n      - /websocket/**\n      - /*/v2/api-docs\n      - /csrf\n', '21c2f2f2d8935727ad7421df14a326fb', '2024-10-02 15:11:16', '2024-10-02 07:11:17', 'nacos', '127.0.0.1', 'U', '', '');
INSERT INTO `his_config_info` VALUES (11, 183, 'doc-websocket-dev.yml', 'DEFAULT_GROUP', '', 'spring:\n  redis:\n    host: localhost\n    port: 6379\n    # password:\n  datasource:\n    druid:\n      stat-view-servlet:\n        enabled: true\n        loginUsername: admin\n        loginPassword: 123456\n    dynamic:\n      druid:\n        initial-size: 5\n        min-idle: 5\n        maxActive: 20\n        maxWait: 60000\n        connectTimeout: 30000\n        socketTimeout: 60000\n        timeBetweenEvictionRunsMillis: 60000\n        minEvictableIdleTimeMillis: 300000\n        validationQuery: SELECT 1 FROM DUAL\n        testWhileIdle: true\n        testOnBorrow: false\n        testOnReturn: false\n        poolPreparedStatements: true\n        maxPoolPreparedStatementPerConnectionSize: 20\n        filters: stat,slf4j\n        connectionProperties: druid.stat.mergeSql\\=true;druid.stat.slowSqlMillis\\=5000\n      datasource:\n          # 主库数据源\n          master:\n            driver-class-name: com.mysql.cj.jdbc.Driver\n            url: jdbc:mysql://localhost:3306/timebank?useUnicode=true&characterEncoding=utf8&zeroDateTimeBehavior=convertToNull&useSSL=true&serverTimezone=GMT%2B8\n            username: root\n            password: 962464\n\n# mybatis配置\nmybatis:\n  # 搜索指定包别名\n  typeAliasesPackage: com.timebank.websocket.pojo\n  # 配置mapper的扫描，找到所有的mapper.xml映射文件\n  mapperLocations: classpath:mapper/*.xml\n  configuration:\n    map-underscore-to-camel-case: true\n    \n# swagger配置\nswagger:\n  title: websocket模块接口文档\n  license: Powered By timebank\n  licenseUrl: https://timebank.vip', '5a4cb2fdc33eb1957eff3d66139ec02e', '2024-10-02 15:16:58', '2024-10-02 07:16:58', 'nacos', '127.0.0.1', 'U', '', '');
INSERT INTO `his_config_info` VALUES (5, 184, 'doc-system-dev.yml', 'DEFAULT_GROUP', '', '# spring配置\nspring:\n  # redis 配置\n  redis:\n    host: localhost\n    port: 6379\n    # password:\n  datasource:\n    druid:\n      stat-view-servlet:\n        enabled: true\n        loginUsername: admin\n        loginPassword: 123456\n    dynamic:\n      druid:\n        initial-size: 5\n        min-idle: 5\n        maxActive: 20\n        maxWait: 60000\n        connectTimeout: 30000\n        socketTimeout: 60000\n        timeBetweenEvictionRunsMillis: 60000\n        minEvictableIdleTimeMillis: 300000\n        validationQuery: SELECT 1 FROM DUAL\n        testWhileIdle: true\n        testOnBorrow: false\n        testOnReturn: false\n        poolPreparedStatements: true\n        maxPoolPreparedStatementPerConnectionSize: 20\n        filters: stat,slf4j\n        connectionProperties: druid.stat.mergeSql\\=true;druid.stat.slowSqlMillis\\=5000\n      datasource:\n        # 主库数据源\n        master:\n          driver-class-name: com.mysql.cj.jdbc.Driver\n          url: jdbc:mysql://localhost:3306/timebank_system?useUnicode=true&characterEncoding=utf8&zeroDateTimeBehavior=convertToNull&useSSL=true&serverTimezone=GMT%2B8\n          username: root\n          password: 962464\n        # 从库数据源\n        slave:\n          driver-class-name: com.mysql.cj.jdbc.Driver\n          url: jdbc:mysql://localhost:3306/timebank_quartz?useUnicode=true&characterEncoding=utf8&zeroDateTimeBehavior=convertToNull&useSSL=true&serverTimezone=GMT%2B8\n          username: root\n          password: 962464 \n\n  #rabbitmq 配置\n  rabbitmq:\n    host: localhost\n    port: 5672\n    username: guest\n    password: guest\n    template:\n        receive-timeout: 30000\n        reply-timeout: 30000\n    virtual-host: /\n    # 发送者开启 confirm 确认机制\n    publisher-confirm-type: correlated\n    # 发送者开启 return 确认机制\n    publisher-returns: true\n    # 设置消费端手动 ack\n    listener:\n      simple:\n        #手动应答\n        acknowledge-mode: manual\n        #消费端最小并发数\n        concurrency: 5\n        #消费端最大并发数\n        max-concurrency: 10\n        #一次请求中预处理的消息数量\n        prefetch: 5\n        # 是否支持重试\n        retry:\n          #启用消费重试\n          enabled: true\n          #重试次数\n          max-attempts: 3\n          #重试间隔时间\n          initial-interval: 3000\n      cache:\n        channel:\n          #缓存的channel数量\n          size: 50\n              \n# mybatis配置\nmybatis:\n    # 搜索指定包别名\n    typeAliasesPackage: com.timebank.system\n    # 配置mapper的扫描，找到所有的mapper.xml映射文件\n    mapperLocations: classpath:mapper/*.xml\n\n# swagger配置\nswagger:\n  title: 系统模块接口文档\n  license: Powered By timebank\n  licenseUrl: https://timebank.vip', 'd5fe54ea05b0a5156b3674691ebd8f9f', '2024-10-02 15:18:12', '2024-10-02 07:18:13', 'nacos', '127.0.0.1', 'U', '', '');
INSERT INTO `his_config_info` VALUES (6, 185, 'doc-job-dev.yml', 'DEFAULT_GROUP', '', '# spring配置\nspring:\n  redis:\n    host: localhost\n    port: 6379\n    # password: \n  datasource:\n    driver-class-name: com.mysql.cj.jdbc.Driver\n    url: jdbc:mysql://localhost:3306/timebank_system?useUnicode=true&characterEncoding=utf8&zeroDateTimeBehavior=convertToNull&useSSL=true&serverTimezone=GMT%2B8\n    username: root\n    password: 962464\n\n# mybatis配置\nmybatis:\n    # 搜索指定包别名\n    typeAliasesPackage: com.timebank.job.pojo\n    # 配置mapper的扫描，找到所有的mapper.xml映射文件\n    mapperLocations: classpath:mapper/*.xml\n\n# swagger配置\nswagger:\n  title: 定时任务接口文档\n  license: Powered By timebank\n  licenseUrl: https://timebank.vip\n', '599fa48aa53ea197c41d97625c69873f', '2024-10-02 15:19:27', '2024-10-02 07:19:27', 'nacos', '127.0.0.1', 'U', '', '');
INSERT INTO `his_config_info` VALUES (7, 186, 'doc-file-dev.yml', 'DEFAULT_GROUP', '', '# 本地文件上传    \nlocal:\n  domain: http://localhost:9201\n  path: E:/java/java_projects/TimeBank/timebank-modules/timebank-file/src/main/resources\n  prefix: /statics\n\n# alioss 配置\nalioss:\n  endpoint: oss-cn-beijing.aliyuncs.com\n  accessKeyId: LTAI5t8tEnf1atzuGtbfYjXH\n  accessKeySecret: 2tMGQFZmJVcfeuISPDuglolYD8QwIW\n  bucketName: shiliuyinzhen-timebank', '99a32ea36b0d663892a15b2336e40d00', '2024-10-02 15:20:04', '2024-10-02 07:20:05', 'nacos', '127.0.0.1', 'U', '', '');
INSERT INTO `his_config_info` VALUES (8, 187, 'sentinel-doc-gateway', 'DEFAULT_GROUP', '', '[\n    {\n        \"resource\": \"timebank-auth\",\n        \"count\": 500,\n        \"grade\": 1,\n        \"limitApp\": \"default\",\n        \"strategy\": 0,\n        \"controlBehavior\": 0\n    },\n	{\n        \"resource\": \"timebank-system\",\n        \"count\": 1000,\n        \"grade\": 1,\n        \"limitApp\": \"default\",\n        \"strategy\": 0,\n        \"controlBehavior\": 0\n    },\n	{\n        \"resource\": \"timebank-volunteer\",\n        \"count\": 200,\n        \"grade\": 1,\n        \"limitApp\": \"default\",\n        \"strategy\": 0,\n        \"controlBehavior\": 0\n    },\n    {\n        \"resource\": \"timebank-timecoin\",\n        \"count\": 200,\n        \"grade\": 1,\n        \"limitApp\": \"default\",\n        \"strategy\": 0,\n        \"controlBehavior\": 0\n    },\n    {\n        \"resource\": \"timebank-score\",\n        \"count\": 200,\n        \"grade\": 1,\n        \"limitApp\": \"default\",\n        \"strategy\": 0,\n        \"controlBehavior\": 0\n    },\n     {\n        \"resource\": \"timebank-websocket\",\n        \"count\": 200,\n        \"grade\": 1,\n        \"limitApp\": \"default\",\n        \"strategy\": 0,\n        \"controlBehavior\": 0\n    },\n	{\n        \"resource\": \"timebank-job\",\n        \"count\": 300,\n        \"grade\": 1,\n        \"limitApp\": \"default\",\n        \"strategy\": 0,\n        \"controlBehavior\": 0\n    }\n]', 'bb22a9ae219527e9cf5b0c5e6766d1bd', '2024-10-02 15:20:43', '2024-10-02 07:20:43', 'nacos', '127.0.0.1', 'U', '', '');
INSERT INTO `his_config_info` VALUES (11, 188, 'doc-websocket-dev.yml', 'DEFAULT_GROUP', '', 'spring:\n  redis:\n    host: localhost\n    port: 6379\n    # password:\n  datasource:\n    druid:\n      stat-view-servlet:\n        enabled: true\n        loginUsername: admin\n        loginPassword: 123456\n    dynamic:\n      druid:\n        initial-size: 5\n        min-idle: 5\n        maxActive: 20\n        maxWait: 60000\n        connectTimeout: 30000\n        socketTimeout: 60000\n        timeBetweenEvictionRunsMillis: 60000\n        minEvictableIdleTimeMillis: 300000\n        validationQuery: SELECT 1 FROM DUAL\n        testWhileIdle: true\n        testOnBorrow: false\n        testOnReturn: false\n        poolPreparedStatements: true\n        maxPoolPreparedStatementPerConnectionSize: 20\n        filters: stat,slf4j\n        connectionProperties: druid.stat.mergeSql\\=true;druid.stat.slowSqlMillis\\=5000\n      datasource:\n          # 主库数据源\n          master:\n            driver-class-name: com.mysql.cj.jdbc.Driver\n            url: jdbc:mysql://localhost:3306/doc?useUnicode=true&characterEncoding=utf8&zeroDateTimeBehavior=convertToNull&useSSL=true&serverTimezone=GMT%2B8\n            username: root\n            password: 962464\n\n# mybatis配置\nmybatis:\n  # 搜索指定包别名\n  typeAliasesPackage: com.doc.websocket.pojo\n  # 配置mapper的扫描，找到所有的mapper.xml映射文件\n  mapperLocations: classpath:mapper/*.xml\n  configuration:\n    map-underscore-to-camel-case: true\n    \n# swagger配置\nswagger:\n  title: websocket模块接口文档\n  license: Powered By Wind Tunnel\n  licenseUrl: https://timebank.vip', '10057420f5c9bdfead3ac239f077904c', '2024-10-02 15:21:05', '2024-10-02 07:21:06', 'nacos', '127.0.0.1', 'U', '', '');
INSERT INTO `his_config_info` VALUES (5, 189, 'doc-system-dev.yml', 'DEFAULT_GROUP', '', '# spring配置\nspring:\n  # redis 配置\n  redis:\n    host: localhost\n    port: 6379\n    # password:\n  datasource:\n    druid:\n      stat-view-servlet:\n        enabled: true\n        loginUsername: admin\n        loginPassword: 123456\n    dynamic:\n      druid:\n        initial-size: 5\n        min-idle: 5\n        maxActive: 20\n        maxWait: 60000\n        connectTimeout: 30000\n        socketTimeout: 60000\n        timeBetweenEvictionRunsMillis: 60000\n        minEvictableIdleTimeMillis: 300000\n        validationQuery: SELECT 1 FROM DUAL\n        testWhileIdle: true\n        testOnBorrow: false\n        testOnReturn: false\n        poolPreparedStatements: true\n        maxPoolPreparedStatementPerConnectionSize: 20\n        filters: stat,slf4j\n        connectionProperties: druid.stat.mergeSql\\=true;druid.stat.slowSqlMillis\\=5000\n      datasource:\n        # 主库数据源\n        master:\n          driver-class-name: com.mysql.cj.jdbc.Driver\n          url: jdbc:mysql://localhost:3306/doc_system?useUnicode=true&characterEncoding=utf8&zeroDateTimeBehavior=convertToNull&useSSL=true&serverTimezone=GMT%2B8\n          username: root\n          password: 962464\n        # 从库数据源\n        # slave:\n        #   driver-class-name: com.mysql.cj.jdbc.Driver\n        #   url: jdbc:mysql://localhost:3306/doc_quartz?useUnicode=true&characterEncoding=utf8&zeroDateTimeBehavior=convertToNull&useSSL=true&serverTimezone=GMT%2B8\n        #   username: root\n        #   password: 962464 \n\n  #rabbitmq 配置\n  # rabbitmq:\n  #   host: localhost\n  #   port: 5672\n  #   username: guest\n  #   password: guest\n  #   template:\n  #       receive-timeout: 30000\n  #       reply-timeout: 30000\n  #   virtual-host: /\n  #   # 发送者开启 confirm 确认机制\n  #   publisher-confirm-type: correlated\n  #   # 发送者开启 return 确认机制\n  #   publisher-returns: true\n  #   # 设置消费端手动 ack\n  #   listener:\n  #     simple:\n  #       #手动应答\n  #       acknowledge-mode: manual\n  #       #消费端最小并发数\n  #       concurrency: 5\n  #       #消费端最大并发数\n  #       max-concurrency: 10\n  #       #一次请求中预处理的消息数量\n  #       prefetch: 5\n  #       # 是否支持重试\n  #       retry:\n  #         #启用消费重试\n  #         enabled: true\n  #         #重试次数\n  #         max-attempts: 3\n  #         #重试间隔时间\n  #         initial-interval: 3000\n  #     cache:\n  #       channel:\n  #         #缓存的channel数量\n  #         size: 50\n              \n# mybatis配置\nmybatis:\n    # 搜索指定包别名\n    typeAliasesPackage: com.doc.system\n    # 配置mapper的扫描，找到所有的mapper.xml映射文件\n    mapperLocations: classpath:mapper/*.xml\n\n# swagger配置\nswagger:\n  title: 系统模块接口文档\n  license: Powered By Wind Tunnel\n  licenseUrl: https://WindTunnel.vip', '51d6f113bf744ebd57f64313ac2f0187', '2024-10-02 15:23:51', '2024-10-02 07:23:52', 'nacos', '127.0.0.1', 'U', '', '');
INSERT INTO `his_config_info` VALUES (6, 190, 'doc-job-dev.yml', 'DEFAULT_GROUP', '', '# spring配置\nspring:\n  redis:\n    host: localhost\n    port: 6379\n    # password: \n  datasource:\n    driver-class-name: com.mysql.cj.jdbc.Driver\n    url: jdbc:mysql://localhost:3306/doc_system?useUnicode=true&characterEncoding=utf8&zeroDateTimeBehavior=convertToNull&useSSL=true&serverTimezone=GMT%2B8\n    username: root\n    password: 962464\n\n# mybatis配置\nmybatis:\n    # 搜索指定包别名\n    typeAliasesPackage: com.doc.job.pojo\n    # 配置mapper的扫描，找到所有的mapper.xml映射文件\n    mapperLocations: classpath:mapper/*.xml\n\n# swagger配置\nswagger:\n  title: 定时任务接口文档\n  license: Powered By WindTunnel\n  licenseUrl: https://WindTunnel.vip\n', 'ee90a3889322b77817577e0c36c2f911', '2024-10-02 15:24:12', '2024-10-02 07:24:12', 'nacos', '127.0.0.1', 'U', '', '');
INSERT INTO `his_config_info` VALUES (7, 191, 'doc-file-dev.yml', 'DEFAULT_GROUP', '', '# 本地文件上传    \nlocal:\n  domain: http://localhost:9201\n  path: E:/java/java_projects/doc/doc-modules/doc-file/src/main/resources\n  prefix: /statics\n\n# alioss 配置\nalioss:\n  endpoint: oss-cn-beijing.aliyuncs.com\n  accessKeyId: LTAI5t8tEnf1atzuGtbfYjXH\n  accessKeySecret: 2tMGQFZmJVcfeuISPDuglolYD8QwIW\n  bucketName: shiliuyinzhen-timebank', 'a96d67004836a2d05c098e7f4bff89dd', '2024-10-02 15:31:34', '2024-10-02 07:31:34', 'nacos', '127.0.0.1', 'U', '', '');

-- ----------------------------
-- Table structure for permissions
-- ----------------------------
DROP TABLE IF EXISTS `permissions`;
CREATE TABLE `permissions`  (
  `role` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `resource` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `action` varchar(8) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  UNIQUE INDEX `uk_role_permission`(`role` ASC, `resource` ASC, `action` ASC) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of permissions
-- ----------------------------

-- ----------------------------
-- Table structure for roles
-- ----------------------------
DROP TABLE IF EXISTS `roles`;
CREATE TABLE `roles`  (
  `username` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `role` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  UNIQUE INDEX `idx_user_role`(`username` ASC, `role` ASC) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of roles
-- ----------------------------
INSERT INTO `roles` VALUES ('nacos', 'ROLE_ADMIN');

-- ----------------------------
-- Table structure for tenant_capacity
-- ----------------------------
DROP TABLE IF EXISTS `tenant_capacity`;
CREATE TABLE `tenant_capacity`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `tenant_id` varchar(128) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL DEFAULT '' COMMENT 'Tenant ID',
  `quota` int UNSIGNED NOT NULL DEFAULT 0 COMMENT '配额，0表示使用默认值',
  `usage` int UNSIGNED NOT NULL DEFAULT 0 COMMENT '使用量',
  `max_size` int UNSIGNED NOT NULL DEFAULT 0 COMMENT '单个配置大小上限，单位为字节，0表示使用默认值',
  `max_aggr_count` int UNSIGNED NOT NULL DEFAULT 0 COMMENT '聚合子配置最大个数',
  `max_aggr_size` int UNSIGNED NOT NULL DEFAULT 0 COMMENT '单个聚合数据的子配置大小上限，单位为字节，0表示使用默认值',
  `max_history_count` int UNSIGNED NOT NULL DEFAULT 0 COMMENT '最大变更历史数量',
  `gmt_create` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `gmt_modified` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '修改时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_tenant_id`(`tenant_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb3 COLLATE = utf8mb3_bin COMMENT = '租户容量信息表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of tenant_capacity
-- ----------------------------

-- ----------------------------
-- Table structure for tenant_info
-- ----------------------------
DROP TABLE IF EXISTS `tenant_info`;
CREATE TABLE `tenant_info`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT 'id',
  `kp` varchar(128) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL COMMENT 'kp',
  `tenant_id` varchar(128) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NULL DEFAULT '' COMMENT 'tenant_id',
  `tenant_name` varchar(128) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NULL DEFAULT '' COMMENT 'tenant_name',
  `tenant_desc` varchar(256) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NULL DEFAULT NULL COMMENT 'tenant_desc',
  `create_source` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NULL DEFAULT NULL COMMENT 'create_source',
  `gmt_create` bigint NOT NULL COMMENT '创建时间',
  `gmt_modified` bigint NOT NULL COMMENT '修改时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_tenant_info_kptenantid`(`kp` ASC, `tenant_id` ASC) USING BTREE,
  INDEX `idx_tenant_id`(`tenant_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb3 COLLATE = utf8mb3_bin COMMENT = 'tenant_info' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of tenant_info
-- ----------------------------

-- ----------------------------
-- Table structure for users
-- ----------------------------
DROP TABLE IF EXISTS `users`;
CREATE TABLE `users`  (
  `username` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `password` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `enabled` tinyint(1) NOT NULL,
  PRIMARY KEY (`username`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of users
-- ----------------------------
INSERT INTO `users` VALUES ('nacos', '$2a$10$EuWPZHzz32dJN7jexM34MOeYirDdFAZm2kuWj7VEOJhhZkDrxfvUu', 1);

SET FOREIGN_KEY_CHECKS = 1;
