@echo off

set JAV_PATH=C:\Java\jdk1.6.0_30\bin
set CAT_PATH=C:\home\tomcat-6.0.9-SP1\lib
set SSO_PATH=C:\home\tomcat-6.0.9-SP1\webapps\ssoagent\WEB-INF\lib

%JAV_PATH%\java -cp %SSO_PATH%\MagicJCrypto-v2.0.0.0.jar;%SSO_PATH%\jcaos-1.4.9.6.jar;%SSO_PATH%\magicsso-agent-4.0.0.2.jar;%SSO_PATH%\magicsso-agadd-4.0.0.2.jar;%CAT_PATH%\servlet-api.jar -Dfile.encoding=UTF-8 com.dreamsecurity.sso.agent.config.InitConfig

set JAV_PATH=
set CAT_PATH=
set SSO_PATH=
