@echo off

set JAV_PATH="C:\Program Files\Java\jdk1.8.0_202\bin"
set CAT_PATH="C:\Program Files\Apache Software Foundation\Tomcat 8.5\lib"
set SSO_PATH="C:\Users\sujin2\Desktop\shpack\WEB-INF\lib"

%JAV_PATH%\java -cp %SSO_PATH%\MagicJCrypto-v2.0.0.0.jar;%SSO_PATH%\jcaos-1.4.9.6.jar;%SSO_PATH%\magicsso-agent-4.0.0.2.jar;%SSO_PATH%\magicsso-agadd-4.0.0.2.jar;%CAT_PATH%\servlet-api.jar -Dfile.encoding=UTF-8 com.dreamsecurity.sso.agent.config.InitSSO

set JAV_PATH=
set CAT_PATH=
set SSO_PATH=
