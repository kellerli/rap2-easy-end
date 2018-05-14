# rap2-easy-end

为了简化 rap2 的使用,搭建一个 docker 版本的混合版本,
常用于企业公司内部使用(群组).

由于查看以及尝试搭建了 [rap2-dolores](https://github.com/thx/rap2-dolores) | [rap2-delos](https://github.com/thx/rap2-delos) 之后发现常规方式有些麻烦 , 所以简单整了一个混合的 docker 本地构建自动化.

# 其它问题(重要)

由于官方的后端还存一些问题,一些操作需要人工整,可以查看 issues 目录相关的文件.

# 如何本地构建

由于一些镜像使用私人的镜像仓库,不建议直接构建,可以参考.

# 如何运行服务

镜像标签: 20180520 该标签表示为最后维稳结束的日期

``` bash

docker pull sayhub/rap2-easy-end:20180520

docker run -d \
-p="80:80" \
--name="rap2-easy-end" \
-v="/opt/app/rap2-easy-end/mysql/lib/:/var/lib/mysql/" \
-v="/opt/app/rap2-easy-end/mysql/log/:/var/log/mysql/" \
-v="/opt/app/rap2-easy-end/mysql/pki/:/var/lib/mysql-files/" \
-v="/opt/app/rap2-easy-end/redis/lib/:/var/lib/redis/" \
-v="/opt/app/rap2-easy-end/redis/log/:/var/log/redis/" \
sayhub/rap2-easy-end:20180520

```

# 外置 Nginx 代理转发

发现许多问题还是官方的项目存在一些问题,导致不能按路径部署(eg:/mock/)这样的方式访问.

目前只能以顶级的路径,比如 example.com 或者 example.com:8080 等这样方式代理,这个问题看后续是否有相关的解决方案.
