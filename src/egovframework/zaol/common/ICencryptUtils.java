/**
 * Copyright(C) 2017 Seoul Metropolitan Government all rights reserved.
 */
package egovframework.zaol.common;

import java.io.UnsupportedEncodingException;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;

import org.apache.commons.codec.binary.Base64;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;


/**
 * 
 * 암호화 처리 유틸 클래스
 *
 */
public class ICencryptUtils
{
    private static final Logger LOGGER    = LoggerFactory.getLogger(ICencryptUtils.class);

    //문자열 CHK String.
    private static final String SALT      = "SH-USER";
    private static final int    ITERATION = 1000;

    /**
     * 패스워드 암호화 (암호화 방식 : SHA-256)
     * 
     * @param password 사용자 패스워드
     * @return 암호화 된 사용자 패스워드
     */
    public static String encryption(String password)
    {   
        MessageDigest md;
        String encryptStr;

        try
        {
            md = MessageDigest.getInstance("SHA-256");
            md.reset();
            md.update(SALT.getBytes());

            byte[] mb = md.digest(password.getBytes("UTF-8"));

            for (int i = 0; i < ITERATION; i++)
            {
                md.reset();
                mb = md.digest(mb);
            }

            StringBuffer hexString = new StringBuffer();
            for (int i = 0; i < mb.length; i++)
            {
                hexString.append(Integer.toHexString(0xFF & mb[i]));
            }

            encryptStr = hexString.toString();
        }
        catch (NoSuchAlgorithmException nsae)
        {
            return null;
        }
        catch(UnsupportedEncodingException uee)
        {
            return null;
        }

        return encryptStr;
    }

    /**
     * 입력 문자열을 Base64로 Encode
     * 
     * @param str
     * @return
     */
    public static String base64Encode(String str)
    {
        LOGGER.debug("seoulCctvEncryptUtils.base64Encode() Called!!!");
        
        byte[] bytesEncoded = Base64.encodeBase64(str.getBytes());
        return new String(bytesEncoded);
    }

    /**
     * Base64로 Encoding된 입력 문자열을 Decode
     * 
     * @param str
     * @return
     */
    public static String base64Decode(String str)
    {
        LOGGER.debug("seoulCctvEncryptUtils.base64Decode() Called!!!");
        
        byte[] valueDecoded = Base64.decodeBase64(str.getBytes());
        return new String(valueDecoded);
    }
}
