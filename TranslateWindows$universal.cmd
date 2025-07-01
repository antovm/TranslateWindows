@echo off
title Language Pack Installer
cls

:: ===================== MENU =====================
echo ==============================================
echo         Select a language to install
echo ==============================================
echo  1 - Arabic (ar-SA)             20 - Korean (ko-KR)
echo  2 - Bulgarian (bg-BG)          21 - Lithuanian (lt-LT)
echo  3 - Czech (cs-CZ)              22 - Latvian (lv-LV)
echo  4 - Danish (da-DK)             23 - Norwegian Bokmal (nb-NO)
echo  5 - German (de-DE)             24 - Dutch (nl-NL)
echo  6 - Greek (el-GR)              25 - Polish (pl-PL)
echo  7 - English - UK (en-GB)       26 - Portuguese - Brazil (pt-BR)
echo  8 - English - US (en-US)       27 - Portuguese - Portugal (pt-PT)
echo  9 - Spanish (es-ES)            28 - Romanian (ro-RO)
echo 10 - Spanish - Mexico (es-MX)   29 - Russian (ru-RU)
echo 11 - Estonian (et-EE)           30 - Slovak (sk-SK)
echo 12 - Finnish (fi-FI)            31 - Slovenian (sl-SI)
echo 13 - French - Canada (fr-CA)    32 - Serbian Latin (sr-Latn-RS)
echo 14 - French (fr-FR)             33 - Swedish (sv-SE)
echo 15 - Hebrew (he-IL)             34 - Thai (th-TH)
echo 16 - Croatian (hr-HR)           35 - Turkish (tr-TR)
echo 17 - Hungarian (hu-HU)          36 - Ukrainian (uk-UA)
echo 18 - Italian (it-IT)            37 - Chinese - Simplified (zh-CN)
echo 19 - Japanese (ja-JP)           38 - Chinese - Traditional (zh-TW)
echo ==============================================

set /p choice=Enter the number of your selection: 

:: =========== LANGUAGE MAPPING ===========
if "%choice%"=="1"  set lang=ar-SA& set langCode=1025
if "%choice%"=="2"  set lang=bg-BG& set langCode=1026
if "%choice%"=="3"  set lang=cs-CZ& set langCode=1029
if "%choice%"=="4"  set lang=da-DK& set langCode=1030
if "%choice%"=="5"  set lang=de-DE& set langCode=1031
if "%choice%"=="6"  set lang=el-GR& set langCode=1032
if "%choice%"=="7"  set lang=en-GB& set langCode=2057
if "%choice%"=="8"  set lang=en-US& set langCode=1033
if "%choice%"=="9"  set lang=es-ES& set langCode=3082
if "%choice%"=="10" set lang=es-MX& set langCode=2058
if "%choice%"=="11" set lang=et-EE& set langCode=1061
if "%choice%"=="12" set lang=fi-FI& set langCode=1035
if "%choice%"=="13" set lang=fr-CA& set langCode=3084
if "%choice%"=="14" set lang=fr-FR& set langCode=1036
if "%choice%"=="15" set lang=he-IL& set langCode=1037
if "%choice%"=="16" set lang=hr-HR& set langCode=1050
if "%choice%"=="17" set lang=hu-HU& set langCode=1038
if "%choice%"=="18" set lang=it-IT& set langCode=1040
if "%choice%"=="19" set lang=ja-JP& set langCode=1041
if "%choice%"=="20" set lang=ko-KR& set langCode=1042
if "%choice%"=="21" set lang=lt-LT& set langCode=1063
if "%choice%"=="22" set lang=lv-LV& set langCode=1062
if "%choice%"=="23" set lang=nb-NO& set langCode=1044
if "%choice%"=="24" set lang=nl-NL& set langCode=1043
if "%choice%"=="25" set lang=pl-PL& set langCode=1045
if "%choice%"=="26" set lang=pt-BR& set langCode=1046
if "%choice%"=="27" set lang=pt-PT& set langCode=2070
if "%choice%"=="28" set lang=ro-RO& set langCode=1048
if "%choice%"=="29" set lang=ru-RU& set langCode=1049
if "%choice%"=="30" set lang=sk-SK& set langCode=1051
if "%choice%"=="31" set lang=sl-SI& set langCode=1060
if "%choice%"=="32" set lang=sr-Latn-RS& set langCode=2074
if "%choice%"=="33" set lang=sv-SE& set langCode=1053
if "%choice%"=="34" set lang=th-TH& set langCode=1054
if "%choice%"=="35" set lang=tr-TR& set langCode=1055
if "%choice%"=="36" set lang=uk-UA& set langCode=1058
if "%choice%"=="37" set lang=zh-CN& set langCode=2052
if "%choice%"=="38" set lang=zh-TW& set langCode=1028

if not defined lang (
    echo Invalid selection. Exiting...
    pause
    exit /b
)

:: =========== INSTALLATION ===========
echo.
echo Installing Language Pack: %lang% ...

dism /Online /Add-Capability /CapabilityName:Language.Basic~~~%lang%~0.0.1.0
dism /Online /Add-Capability /CapabilityName:Language.Handwriting~~~%lang%~0.0.1.0
dism /Online /Add-Capability /CapabilityName:Language.OCR~~~%lang%~0.0.1.0
dism /Online /Add-Capability /CapabilityName:Language.Speech~~~%lang%~0.0.1.0
dism /Online /Set-Lang:%lang%

:: =========== LANGUAGE SETTINGS ===========
powershell -Command Install-Language %lang% -CopyToSettings
powershell -Command Set-WinUserLanguageList %lang% -Force
powershell -Command "Set-WinUILanguageOverride -Language %lang%"
powershell -Command "Set-WinSystemLocale %lang%"
powershell -Command "Set-Culture %lang%"

:: =========== REGISTRY ===========
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Nls\Language" /v InstallLanguage /t REG_SZ /d %langCode% /f
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Nls\Language" /v Default /t REG_SZ /d %langCode% /f
reg add "HKU\.DEFAULT\Control Panel\International" /v LocaleName /t REG_SZ /d %lang% /f

:: =========== REBOOT ===========
echo.
echo Restart required to apply changes.
pause
shutdown /r /t 0