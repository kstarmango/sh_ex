package egovframework.syesd.cmmn.util.test;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.util.zip.ZipEntry;
import java.util.zip.ZipInputStream;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;


public class UnzipTest {
	private static Logger logger = LogManager.getLogger(UnzipTest.class);
	
    public static void main(String[] args) throws IOException {
        File file = new File("e:/주거환경관리사업.zip");
        
        try (ZipInputStream in = new ZipInputStream(new FileInputStream(file), java.nio.charset.Charset.forName("EUC-KR"))) {
            ZipEntry entry;
            while ((entry = in.getNextEntry()) != null) {
                logger.info(entry.getName() + " 파일이 들어 있네요.");
            }
        } catch (IOException e) {
            logger.error("파일을 읽는 도중 오류가 발생했습니다.");
        }
        
        /*ZipInputStream in = new ZipInputStream(new FileInputStream(file),  java.nio.charset.Charset.forName("EUC-KR"));
        ZipEntry entry = null;
        while((entry = in.getNextEntry()) != null ){
        	logger.info(entry.getName()+" 파일이 들어 있네요.");
        }*/
    }
}
