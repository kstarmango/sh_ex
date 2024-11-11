package egovframework.syesd.cmmn.util.test;

import org.apache.commons.codec.binary.Hex;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import egovframework.syesd.cmmn.util.KeyGenerateUtil;

public class KeyGenerateTest {

	private static Logger logger = LogManager.getLogger(KeyGenerateTest.class);
	
	public static void main(String[] args)
	{
		try {
			byte[] raw1 = KeyGenerateUtil.encrypt("LANDSYS".getBytes(), "SHLM");
			String keyString1 = new String(Hex.encodeHex(raw1));
			logger.info(keyString1);

			raw1 = KeyGenerateUtil.decodeHex(keyString1);

			byte[] raw2 = KeyGenerateUtil.decrypt(raw1, "SHLM");
			String keyString2 = new String(raw2);
			logger.info(keyString2);
			//System.out.println(keyString2.toUpperCase());


			raw1 = KeyGenerateUtil.encrypt("NOPASSWORD".getBytes(), "SHLM");
			keyString1 = new String(Hex.encodeHex(raw1));
			logger.info(keyString1);
			//System.out.println(keyString1.toUpperCase());

			raw2 = KeyGenerateUtil.decrypt(raw1, "SHLM");
			keyString2 = new String(raw2);
			logger.info(keyString2);
			//System.out.println(keyString2.toUpperCase());
		} catch (NullPointerException e) {
			logger.info("KeyGenerateTest NullPointerException error");
		}
	}

}
