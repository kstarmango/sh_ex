package egovframework.mango.config;

import java.util.Locale;
import java.util.ResourceBundle;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

public class SHResource {
	private static Logger logger = LogManager.getLogger(SHResource.class);
	private static ResourceBundle resource = ResourceBundle.getBundle("system", Locale.getDefault());;
	private static String PROFILE_NAME = "";
	static {
		try {
			resource = ResourceBundle.getBundle("system", Locale.getDefault());

			PROFILE_NAME = resource.getString("spring.profiles.active");
			if (PROFILE_NAME != null) {
				PROFILE_NAME = "-" + PROFILE_NAME;
			}

			String systemProfile = System.getProperty("spring.profiles.active");

			if (systemProfile == null) {
				systemProfile = "";
			}

			if (!systemProfile.equals("")) {
				PROFILE_NAME = "-" + systemProfile;
			}

		} catch (NullPointerException e) {
			logger.debug(e);
		} catch (Exception e) {
			logger.debug(e);
		}
	}

	private static ResourceBundle prodResource = ResourceBundle.getBundle("system" + PROFILE_NAME, Locale.getDefault());

	public static String getValue(String key) {
		try {
			return getValue(key, null);
		} catch (NullPointerException e) {
			logger.debug(e);
			return null;
		} catch (Exception e) {
			logger.debug(e);
			return null;
		}
	}

	public static String getValue(String key, String defaultVal) {
		String val = null;
		try {
			val = prodResource.getString(key);
			if (val == null) {
				val = resource.getString(key);
			}
			if (val == null) {
				return defaultVal;
			}
			return val;
		} catch (NullPointerException npe) {
			val = resource.getString(key);
			if (val == null) {
				return defaultVal;
			}
			return val;
		} catch (Exception e) {
			return defaultVal;
		}
	}
}
