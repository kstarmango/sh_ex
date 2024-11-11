package egovframework.syesd.cmmn.util.test;

import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.io.OutputStreamWriter;
import java.util.Scanner;
import java.util.concurrent.Executors;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import java.lang.ProcessBuilder.Redirect;

public class ProcessTest2 {
	
	private static Logger logger = LogManager.getLogger(ProcessTest2.class);
	
    public static void main(String[] args)
            throws IOException, InterruptedException {
	    ProcessTest2 runner = new ProcessTest2();

    	/*String[] command = new String[] { "echo", "hello" };
	    runner.byRuntime(command);
	    runner.byProcessBuilder(command);
	    runner.byProcessBuilderRedirect(command);*/

    	/*String[] command = new String[] { "gdalsrsinfo", "e:/주거환경관리사업.prj", "-o",  "epsg"};
	    runner.byProcessBuilderRedirect(command);

	    Process process = Runtime.getRuntime().exec(String.join(" ", command));
	    InputStream stdout = process.getInputStream();
    	try
    	{
    		String line;
    		BufferedReader reader = new BufferedReader(new InputStreamReader(stdout));
    		while ((line = reader.readLine()) != null) {
    			System.out.println(line);
    		}

    		process.destroy();
    	}
    	catch (IOException e) {
    	}*/

	    logger.info("PID = " + runner.getProcessID(8081));
	}

    public int getProcessID(int port) throws IOException {
    	try {
            Process ps = new ProcessBuilder("cmd", "/c", "netstat -a -o").start();
            
            try (BufferedReader br = new BufferedReader(new InputStreamReader(ps.getInputStream(), "EUC-KR"))) {
                String line;
                while ((line = br.readLine()) != null) {
                    logger.info(line);
                    if (line.contains(":" + port)) {
                        while (line.contains("  ")) {
                            line = line.replaceAll("  ", " ");
                        }
                        int pid = Integer.parseInt(line.split(" ")[5]);
                        ps.destroy();
                        return pid;
                    }
                }
            } catch (IOException e) {
                logger.error("Error reading process output", e);
            } finally {
                ps.destroy();
            }
    	} catch (IOException e) {
            logger.error("Error starting process");
        }
    	
        /*Process ps = new ProcessBuilder("cmd", "/c", "netstat -a -o").start();
        BufferedReader br = new BufferedReader(new InputStreamReader(ps.getInputStream(), "EUC-KR"));
        String line;
        while ((line = br.readLine()) != null) {
        	logger.info(line);
            if (line.contains(":" + port)) {
                while (line.contains("  ")) {
                    line = line.replaceAll("  ", " ");
                }
                int pid = Integer.valueOf(line.split(" ")[5]);
                ps.destroy();
                return pid;
            }
        }*/
    	
        return -1;
    }


    public void byRuntime(String[] command)
            throws IOException, InterruptedException {
	    Runtime runtime = Runtime.getRuntime();
	    Process process = runtime.exec(command);
	    printStream(process);
    }

	public void byProcessBuilder(String[] command)
	            throws IOException,InterruptedException {
	    ProcessBuilder builder = new ProcessBuilder(command);
	    Process process = builder.start();
	    printStream(process);
	}

	private void printStream(Process process)
	            throws IOException, InterruptedException {
	    process.waitFor();
	    try (InputStream psout = process.getInputStream()) {
	        copy(psout, System.out);
	    }
	}

	public void copy(InputStream input, OutputStream output) throws IOException {
	    byte[] buffer = new byte[1024];
	    int n = 0;
	    while ((n = input.read(buffer)) != -1) {
	        output.write(buffer, 0, n);
	    }
	}

	public void byCommonsExec(String[] command)
	        throws IOException,InterruptedException {
	    /*DefaultExecutor executor = new DefaultExecutor();
	    CommandLine cmdLine = CommandLine.parse(command[0]);
	    for (int i=1, n=command.length ; i<n ; i++ ) {
	        cmdLine.addArgument(command[i]);
	    }
	    executor.execute(cmdLine);*/
	}

	public void byProcessBuilderRedirect(String[] command)
	        throws IOException, InterruptedException {
	    ProcessBuilder builder = new ProcessBuilder(command);
	    builder.redirectOutput(Redirect.INHERIT);
	    builder.redirectError(Redirect.INHERIT);
	    builder.start();
	}

	public static void main_(String[] args) {
		try {
		  //Linux의 경우는 /bin/bash
		  //Process process = Runtime.getRuntime().exec("/bin/bash");
		  Process process = Runtime.getRuntime().exec("cmd");
		  //Process의 각 stream을 받는다.
		  //process의 입력 stream
		  final OutputStream stdin = process.getOutputStream();
		  //process의 에러 stream
		  final InputStream stderr = process.getErrorStream();
		  //process의 출력 stream
		  final InputStream stdout = process.getInputStream();

		  //쓰레드 풀을 이용해서 3개의 stream을 대기시킨다.

		  //출력 stream을 BufferedReader로 받아서 라인 변경이 있을 경우 console 화면에 출력시킨다.
		  Executors.newCachedThreadPool().execute(new Runnable() {
			@Override
			public void run() {
			    // 문자 깨짐이 발생할 경우 InputStreamReader(stdout)에 인코딩 타입을 넣는다. ex) InputStreamReader(stdout, "euc-kr")
			    try (BufferedReader reader = new BufferedReader(new InputStreamReader(stdout, "euc-kr"))) {
			    //try (BufferedReader reader = new BufferedReader(new InputStreamReader(stdout))) {
			      String line;
			      while ((line = reader.readLine()) != null) {
			    	  logger.info(line);
			      }
			    } catch (IOException e) {
			      // TODO Auto-generated catch block
			    	logger.error("ProcessTest2 run IOException error");
			    }
			  }
		});

		  //에러 stream을 BufferedReader로 받아서 에러가 발생할 경우 console 화면에 출력시킨다.
		  Executors.newCachedThreadPool().execute(new Runnable() {
			@Override
			public void run() {
			    // 문자 깨짐이 발생할 경우 InputStreamReader(stdout)에 인코딩 타입을 넣는다. ex) InputStreamReader(stdout, "euc-kr")
			    // try (BufferedReader reader = new BufferedReader(new InputStreamReader(stderr, "euc-kr"))) {
			    try (BufferedReader reader = new BufferedReader(new InputStreamReader(stderr))) {
			      String line;
			      while ((line = reader.readLine()) != null) {
			    	  logger.info("err " + line);
			      }
			    } catch (IOException e) {
			      // TODO Auto-generated catch block
			    	logger.error("ProcessTest2 run IOException error");
			    }
			  }
		});

		  //입력 stream을 BufferedWriter로 받아서 콘솔로부터 받은 입력을 Process 클래스로 실행시킨다.
		  Executors.newCachedThreadPool().execute(new Runnable() {
			@Override
			public void run() {
			    // Scanner 클래스는 콘솔로 부터 입력을 받기 위한 클래스 입니다.
			    try (Scanner scan = new Scanner(System.in)) {
			      try (BufferedWriter writer = new BufferedWriter(new OutputStreamWriter(stdin))) {
			        while (true) {
			          // 콘솔로 부터 엔터가 포함되면 input String 변수로 값이 입력됩니다.
			          String input = scan.nextLine();
			          // 콘솔에서 \n가 포함되어야 실행된다.(엔터의 의미인듯 싶습니다.)
			          input += "\n";
			          writer.write(input);
			          // Process로 명령어 입력
			          writer.flush();
			          // exit 명령어가 들어올 경우에는 프로그램을 종료합니다.
			          if ("exit\n".equals(input)) {
			            System.exit(0);
			          }
			        }
			      } catch (IOException e) {
			        // TODO Auto-generated catch block
			    	  logger.error("ProcessTest2 run IOException error");
			      } finally {
			    	    // System.exit() 대신 while 문을 탈출해 finally 블록에서 명시적으로 자원 해제
			    	    try {
			    	        stdin.close();
			    	    } catch (IOException e) {
			    	        logger.error("Error closing stdin");
			    	    }
			    	}
			    }
			  }
		});

		} catch (Throwable e) {
		  // TODO Auto-generated catch block
			logger.error("ProcessTest2 run Throwable error");
		}
	}
}
