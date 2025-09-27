@echo off
REM ----------------------------------------------------------------------------
REM Gradle startup script for Windows
REM ----------------------------------------------------------------------------

setlocal

set DEFAULT_JVM_OPTS=

if defined JAVA_HOME (
  set JAVA_EXE=%JAVA_HOME%\bin\java.exe
) else (
  set JAVA_EXE=java.exe
)

if exist "%JAVA_EXE%" (
  set JAVA_CMD="%JAVA_EXE%"
) else (
  set JAVA_CMD=java.exe
)

set APP_HOME=%~dp0
set GRADLE_JAR=%APP_HOME%gradle\wrapper\gradle-wrapper.jar

%JAVA_CMD% %DEFAULT_JVM_OPTS% -jar "%GRADLE_JAR%" %*