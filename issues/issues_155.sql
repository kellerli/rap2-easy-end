use rap2;
alter table `Interfaces` change column `priority` `priority` bigint(20) not null default 1;
alter table `Modules` change column `priority` `priority` bigint(20) not null default 1;
alter table `Properties` change column `priority` `priority` bigint(20) not null default 1;
flush privileges;
exit;

/**
问题报告: https://github.com/thx/rap2-delos/issues/155

进入容器(eg):
docker exec -it rap2-easy-end bash
mysql -u root -p
输入密码(123456)
执行上面的语句

或者执行清理的脚本.

*/
