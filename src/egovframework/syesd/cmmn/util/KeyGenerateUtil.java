package egovframework.syesd.cmmn.util;

import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.lang.reflect.InvocationTargetException;
import java.security.InvalidKeyException;
import java.security.NoSuchAlgorithmException;
import java.security.SecureRandom;
import java.sql.SQLException;
import java.util.Arrays;
import java.util.Collections;
import java.util.List;

import javax.crypto.BadPaddingException;
import javax.crypto.Cipher;
import javax.crypto.IllegalBlockSizeException;
import javax.crypto.KeyGenerator;
import javax.crypto.NoSuchPaddingException;
import javax.crypto.spec.SecretKeySpec;

import org.apache.commons.codec.DecoderException;
import org.apache.commons.codec.binary.Hex;
import org.apache.commons.lang3.RandomStringUtils;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

public class KeyGenerateUtil {
	private static Logger logger = LogManager.getLogger(KeyGenerateUtil.class);
	
    private static final String NUMBER = "0123456789";
	private static final String CHAR_LOWER = "abcdefghijklmnopqrstuvwxyz";
    private static final String CHAR_UPPER = CHAR_LOWER.toUpperCase();
    private static final String OTHER_CHAR = "!@#$%&*()_+-=[]?";

    private static final String PASSWORD_ALLOW_BASE = CHAR_LOWER + CHAR_UPPER + NUMBER + OTHER_CHAR;

    private static final String ALPHANUMERIC_ALLOW_BASE = CHAR_LOWER + CHAR_UPPER + NUMBER;

    public final static String shuffleString(int len) {
    	return RandomStringUtils.random(len, PASSWORD_ALLOW_BASE);
    }

    public final static String shuffleStringAlphanumeric(int len) {
    	return RandomStringUtils.random(len, ALPHANUMERIC_ALLOW_BASE);
    }

	public final static String encodeHex(byte[] input) {
		return new String(Hex.encodeHex(input));
	}

	public final static byte[] decodeHex(String input) {
		try {
			return Hex.decodeHex(input.toCharArray());
		} catch (DecoderException e) {
			throw new IllegalStateException("Hex Decoder exception", e);
		}
	}

	// 지정한 시드 문자열로 보안 키를 생성한다.
	public final static byte[] generateRawKey(String seed_string) throws IOException, NoSuchAlgorithmException {
		SecureRandom secure_random = SecureRandom.getInstance("SHA1PRNG");
		secure_random.setSeed(seed_string.getBytes("UTF-8"));

		KeyGenerator key_generator = KeyGenerator.getInstance("AES");
		key_generator.init(128, secure_random);

		return (key_generator.generateKey()).getEncoded();
	}

	// 3번 ~ 4번 과정에 해당하는 코드
	// 지정한 모드와 시드 문자열로 javax.crypto.Cipher 객체를 초기화해 반환한다.
	public final static Cipher getCipher(int mode, String seed_string) throws IOException, NoSuchAlgorithmException, NoSuchPaddingException, InvalidKeyException {
		SecretKeySpec key_spec = new SecretKeySpec(generateRawKey(seed_string), "AES");
		Cipher cipher = Cipher.getInstance("AES");
		cipher.init(mode, key_spec);
		return cipher;
	}

	// 바이트 배열을 지정한 키 시드 문자열과 AES 알고리즘으로 암호화한다.
	public final static byte[] encrypt(byte[] data, String seed_string)  {
		Cipher cipher = null;
		try {
			cipher = getCipher(Cipher.ENCRYPT_MODE, seed_string);
		} catch (IOException | NoSuchAlgorithmException | NoSuchPaddingException | InvalidKeyException e) {
			logger.error("encrypt Exception error");
		}
		try {
			return cipher.doFinal(data);
		} catch (IllegalBlockSizeException e) {
			logger.error("encrypt IllegalBlockSizeException error");
		} catch (BadPaddingException e) {
			logger.error("encrypt BadPaddingException error");
		}

		return null;
	}

	// 바이트 배열을 지정한 키 시드 문자열과 AES 알고리즘으로 복호화한다.
	public final static byte[] decrypt(byte[] data, String seed_string)  {
		Cipher cipher = null;
		try {
			cipher = getCipher(Cipher.DECRYPT_MODE, seed_string);
		} catch (IOException | NoSuchAlgorithmException | NoSuchPaddingException | InvalidKeyException e) {
			logger.error("decrypt Exception error");
		}
		try {
			return cipher.doFinal(data);
		} catch (IllegalBlockSizeException e) {
			logger.error("decrypt IllegalBlockSizeException error");
		} catch (BadPaddingException e) {
			logger.error("decrypt BadPaddingException error");
		}

		return null;
	}

}
