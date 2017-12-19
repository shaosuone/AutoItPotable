@echo off
title AutoIt输出EXE一键瘦身工具
color 27
pushd %~dp0
echo 开始解包文件%1
upx.exe  -d -q %1
echo 开始删除无用字符串
..\Extras\OtherEXE\ResHacker.exe  -delete "%1", "%1", StringTable,, 
echo 开始删除无用对话框
..\Extras\OtherEXE\ResHacker.exe   -delete "%1", "%1", Dialog,, 
echo 开始删除无用菜单
..\Extras\OtherEXE\ResHacker.exe   -delete "%1", "%1", Menu,, 
del/s/f/q ..\Extras\OtherEXE\ResHacker.log
del/s/f/q ..\Extras\OtherEXE\ResHacker.ini
upx.exe -9 -q %1
echo 操作完成..按任意键退出>nul 2>nul && pause
