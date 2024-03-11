%%a %%a %%a %%a %%a %%a %%a %%a %%a %%a %%a %%a %%a %%a %%a %%a %%a %%a %%a %%a %%a %%a %%a %%a %%a %%a %%a %%a %%a %%a %%a %%a %%a %%a %%a %%a %%a %%a %%a %%a %%a %%a %%a %%a %%a %%a %%a %%a %%a %%a %%a %%a %%a %%a %%a %%a %%a %%a %%a %%a %%a %%a %%a %%a %%a %%a %%a %%a %%a %%a %%a %%a %%a %%a %%a %%a %%a %%a %%a %%a %%a %%a %%a %%a %%a %%a %%a %%a %%a %%a %%a %%a %%a %%a %%a %%a %%a %%a %%a %%a %%a %%a %%a %%a %%a %%a %%a %%a %%a %%a %%a %%a %%a %%a %%a %%a %%a %%a %%a %%a %%a %%a %%a %%a %%a %%a %%a %%a %%a  
cls 
@echo off
chcp 65001 > nul
setlocal enabledelayedexpansion
echo.
echo  SFW 网页客户端
echo.
timeout /t 2 > nul
set "inputFile=sub.txt"
set "outputFile=config.json"
set "firstLine="
set /P firstLine=<"%inputFile%"
if not defined firstLine (
    echo 当前订阅文件sub.txt 第一行为空或者无内容，直接使用自定义config.json配置
    timeout /t 3 > nul
) else (
    echo. >%outputFile%
    set "lastHttpsUrl="
    for /f "tokens=*" %%a in (%inputFile%) do (
        set "url=%%a"
        set "httpsFound=false"
        echo !url! | findstr /i "https" >nul && set "httpsFound=true"
        if !httpsFound! equ true (
            set "lastHttpsUrl=!url!"
        )
    )
    if defined lastHttpsUrl (
        echo 下载最后一行订阅链接地址: !lastHttpsUrl!
        powershell.exe -Command "Invoke-WebRequest -Uri '!lastHttpsUrl!' -OutFile 'config.json' >$null"
        cls
        echo 下载完成，配置保存到 config.json 
        echo 启动 SFW 网页客户端
        timeout /t 3 > nul
    ) else (
        echo 没有包含 "https" 的订阅链接，脚本退出
        timeout /t 3 > nul
        exit /b 0
    )
)
for /f %%a in ('type "config.json" ^| find /v /c ""') do set "fileSize=%%a"
if %fileSize% leq 0 (
    echo config.json文件为空，脚本退出
    timeout /t 3 > nul
    exit /b 0
)
start /min sing-box.exe run
start http://127.0.0.1:9090