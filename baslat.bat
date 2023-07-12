rem Bu başlatma dosyası LewisLosa (losa.dev) tarafından hazırlanmıştır.
rem Paylaşılması durumunda izin almanız gerekir.
rem https://baslat.losa.dev

@ECHO OFF
setlocal enabledelayedexpansion

rem (GB) cinsinden sunucunun Ram boyutunu giriniz
set a=8

rem Sunucu başlatma yazılımının ismi nedir?
set b=sunucu.jar

rem Konsol renklerini kapatmak için 11. satırdaki "rem" ifadesini kaldırın

rem set c=nogui


rem - Başlatma kodu -
set before=-XX:+UseG1GC -XX:+ParallelRefProcEnabled -XX:MaxGCPauseMillis=200 -XX:+UnlockExperimentalVMOptions -XX:+DisableExplicitGC -XX:+AlwaysPreTouch -XX:G1NewSizePercent=30 -XX:G1MaxNewSizePercent=40 -XX:G1HeapRegionSize=8M -XX:G1ReservePercent=20 -XX:G1HeapWastePercent=5 -XX:G1MixedGCCountTarget=4 -XX:InitiatingHeapOccupancyPercent=15 -XX:G1MixedGCLiveThresholdPercent=90 -XX:G1RSetUpdatingPauseTimePercent=5 -XX:SurvivorRatio=32 -XX:+PerfDisableSharedMem -XX:MaxTenuringThreshold=1 -Dusing.aikars.flags=https://mcflags.emc.gs -Daikars.new.flags=true --add-modules=jdk.incubator.vector
set after=nogui


rem                 - Kod bölümü -

rem (Herhangi bir şey değiştirmeniz tavsiye edilmez.)
:re1
cls
set /a times2=0
set /a times=1
for /f %%a in (baslatma-sayisi.txt) do set /a times=%%a+1
echo %times% >baslatma-sayisi.txt
if %times%== %times2% goto a
set /a yu=%times2%-%times%
set /a var=%1+1
set /a var2=%var%-1
set "d=%~p0"
set "d=%d:\= %"
for %%a in (%d%) do set name=%%a
set /a var=%1+1
if %var2%==0 (set num= ) else (set num= Yeniden baslatildi !var2! )
set cnt=0
for /f "delims=" %%i in ('dir/b/a-d "plugins\*.jar" 2^>nul') do set /a cnt+=1
if defined cnt (set pl=!cnt! Eklenti Bulundu) else (set pl=Eklenti Bulundu)
title Sunucu: %name% - Ram: %a%GB%num% - %times%. Kez Baslatildi - %pl%
echo Sunucu dizini : %cd%
echo -------------------------------------------------
if "%PROCESSOR_ARCHITECTURE:~0,3%" equ "x86" (echo Isletim sistemi: %OS% - 32Bit) else (echo Isletim sistemi: %OS% - 64Bit)
echo Is Cekirdegi sayisi: %NUMBER_OF_PROCESSORS%
echo Kullanilacak Ram: %a%GB
echo %pl%
echo -------------------------------------------------
timeout 2 > nul
color 7
java -Xmx%a%G %before% -jar %b% %after% %c%
ping -n 1 127.1>nul
set ret=11
:re2

rem NEQ eşit değil anlamına gelir
if %var% NEQ 4 (goto re3) else (goto re4)

:re3
set /a ret=ret-1
ping -n 2 -w 500 127.1>nul
cls
color e
echo Sunucu dizini : %cd%
echo -------------------------------------------------
echo %ret% saniye sonra yeniden baslatilacaktir.
echo Sunucu toplam %times% kez Baslatildi
echo Yeniden baslatma denemesi: %var%
echo -------------------------------------------------
title Sunucu: %name% - Yeniden baslatma denemesi: %var%
if %ret%==0 (call :re1 %var%) else (goto re3)
color 7

:re4
cls
title %name% sunucusunda onemli bir uyari mevcut!
color c
echo -------------------------------------------------
echo ONEMLI UYARI!
echo %name% sunucusu %var% kez Yeniden baslatildi
echo Muhtemelen sunucuda bir hata olabilir
echo Lutfen log dosyasini kontrol edin
echo -------------------------------------------------
echo Hatayi yok saymak ve Yeniden baslatmak icin herhangi bir tusa basin & pause>nul
call :re1 %var%
color 7
