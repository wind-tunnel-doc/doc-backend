# doc-backend

## 介绍
风洞文档后端

## 软件架构
~~~
com.doc    
├── doc-gateway         // 网关模块 [9000]
├── doc-auth            // 认证中心 [9200]
├── doc-api             // 接口模块
│       └── doc-api-system                          // 系统接口
├── doc-common          // 通用模块
│       └── doc-common-core                         // 核心模块
│       └── doc-common-datasource                   // 多数据源
│       └── doc-common-log                          // 日志记录
│       └── doc-common-redis                        // 缓存服务
│       └── doc-common-security                     // 安全模块
│       └── doc-common-swagger                      // 系统接口
├── doc-modules         // 业务模块
│       └── doc-file                                // 文件服务 [9201]
│       └── doc-system                              // 系统模块 [9204]
│       └── doc-websocket                           // Websocket服务 [9209]
├──pom.xml                // 公共依赖
~~~

#### 环境配置

1.  jdk = 17
2.  redis >= 3.2.100
3.  nacos >= 2.2.0
4.  mysql >= 8.0.33

#### 使用说明

1.  mysql导入源码中的sql目录下的所有sql文件（sql名即为数据库名，自行创建数据库）

2.  修改nacos配置文件(nacos-server-2.2.0\nacos\conf\application.properties)中的mysql配置（注意数据库名必须为doc_nacos_config、端口、用户名和密码）
    db.url.0=jdbc:mysql://localhost:3306/docnacos_config?characterEncoding=utf8&connectTimeout=1000&socketTimeout=3000&autoReconnect=true&useUnicode=true&useSSL=false&serverTimezone=UTC
    db.user.0=root（用户名可自行修改）
    db.password.0=password（密码可自行修改）
3.  nacos运行：找到目录（nacos-server-2.2.0\nacos\bin），在cmd窗口下输入命令（startup.cmd -m standalone）即可
4.  redis运行：找到目录（Redis-x64-3.2.100），点击redis-server.exe运行即可
5.  运行redis和nacos后，再运行所有的 DocxxxApplication 项目即可
6.  可在localhost：{port}/doc.html下访问接口文档,port为各个application的端口号
7.  访问 http://localhost:8848/nacos 即可查看nacos服务注册中心，可在服务管理下的服务列表中找到已经运行成功的服务。
