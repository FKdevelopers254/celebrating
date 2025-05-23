@echo off
set BASE_DIR=C:\Users\User\Documents\springprojects\celebrating-microservices-main

echo Starting all microservices in the correct order...

echo Starting Config Server...
cd %BASE_DIR%\config-server
start "Config Server" cmd /k "gradlew.bat bootRun"

echo Waiting for Config Server to start...
timeout /t 15 /nobreak

echo Starting Service Registry (Eureka)...
cd %BASE_DIR%\service-registry
start "Service Registry" cmd /k "gradlew.bat bootRun"

echo Waiting for Service Registry to start...
timeout /t 15 /nobreak

echo Starting Auth Service...
cd %BASE_DIR%\auth-service
start "Auth Service" cmd /k "gradlew.bat bootRun"

echo Waiting for Auth Service to start...
timeout /t 10 /nobreak

echo Starting User Service...
cd %BASE_DIR%\user-service
start "User Service" cmd /k "gradlew.bat bootRun"

echo Waiting for User Service to start...
timeout /t 10 /nobreak

echo Starting Post Service...
cd %BASE_DIR%\post-service
start "Post Service" cmd /k "gradlew.bat bootRun"

echo Waiting for Post Service to start...
timeout /t 10 /nobreak

echo Starting Messaging Service...
cd %BASE_DIR%\messaging-service
start "Messaging Service" cmd /k "gradlew.bat bootRun"

echo Waiting for Messaging Service to start...
timeout /t 10 /nobreak

echo Starting API Gateway...
cd %BASE_DIR%\api-gateway
start "API Gateway" cmd /k "gradlew.bat bootRun"

echo Waiting for API Gateway to start...
timeout /t 10 /nobreak

echo Starting Flutter Web App...
cd %BASE_DIR%\celebrate
start "Flutter Web App" cmd /k "flutter run -d chrome"

cd %BASE_DIR%

echo All services started! Please wait for each service to fully initialize.
echo You can access:
echo - Config Server: http://localhost:8888/actuator/health
echo - Eureka Dashboard: http://localhost:8761
echo - API Gateway: http://localhost:8080
echo - Flutter Web App: http://localhost:53042

echo To view logs, check the corresponding .log files in this directory.

type config-server.log
type service-registry.log 