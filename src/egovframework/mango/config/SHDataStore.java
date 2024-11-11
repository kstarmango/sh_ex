package egovframework.mango.config;

import java.net.URI;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.geotools.data.DataStore;
import org.geotools.data.DataStoreFinder;
import org.geotools.data.simple.SimpleFeatureCollection;
import org.geotools.data.simple.SimpleFeatureSource;
import org.geotools.factory.CommonFactoryFinder;
import org.opengis.feature.type.AttributeDescriptor;
import org.opengis.filter.FilterFactory2;
import org.opengis.filter.PropertyIsEqualTo;
import org.opengis.filter.PropertyIsLike;
import org.springframework.beans.BeanWrapper;
import org.springframework.beans.BeanWrapperImpl;
import org.springframework.context.ApplicationContext;
import org.springframework.jdbc.datasource.SimpleDriverDataSource;

import egovframework.mango.util.SHJsonHelper;

public class SHDataStore {
	private static String dbtype = null;
	private static String host = null;
	private static Integer port = null;
	private static String dbname = null;
	private static String schema = null;
	private static String username = null;
	private static String password = null;

	private static DataStore dataStore = null;
	private static Logger logger = LogManager.getLogger(SHDataStore.class);

	static {
		getProperties();
	}

	public static void getProperties() {
		try {
			ApplicationContext context = SHApplicationContextProvider.getApplicationContext();

			if (context != null) {
				SimpleDriverDataSource dataSource = (SimpleDriverDataSource) context.getBean("dataSourcePOSTGRESQL");

				BeanWrapper wrapper = new BeanWrapperImpl(dataSource);
				String url = (String) wrapper.getPropertyValue("url");
				URI dbUrl = new URI(url.substring(5));
				host = dbUrl.getHost();
				port = dbUrl.getPort();
				dbname = dbUrl.getPath().substring(1);
				dbtype = "postgis";
				username = (String) wrapper.getPropertyValue("username");
				password = (String) wrapper.getPropertyValue("password");

				//System.out.println("URL: " + url);
				//System.out.println("Username: " + username);
				//System.out.println("Password: " + password);
//				System.out.println("xxx: " + SHResource.getValue("sh.server.url"));
//				System.out.println("xxx: " + SHResource.getValue("test.val"));
			} 
		} catch (NullPointerException e) {
			logger.debug(e);
		} catch (Exception e) {
			logger.debug(e);
		}
	}

	@SuppressWarnings("rawtypes")
	public static synchronized DataStore getDataStore() {
		Map<String, Object> params = new HashMap<String, Object>();
		// if (dataStore != null) {
		// return dataStore;
		// }

		params.put("dbtype", dbtype);
		params.put("host", host);
		params.put("port", port);
		params.put("database", dbname);
		params.put("schema", schema);
		params.put("user", username);
		params.put("passwd", password);

//		for( Iterator i=DataStoreFinder.getAvailableDataStores(); i.hasNext(); ){
//		    DataStoreFactorySpi factory = (DataStoreFactorySpi) i.next();
//
//		    System.out.println( factory.getDisplayName());
//		}

		try {
			dataStore = DataStoreFinder.getDataStore(params);
		} catch (NullPointerException e) {
			logger.debug(e);
		} catch (Exception e) {
			logger.debug(e);
		}
		return dataStore;
	}

	@SuppressWarnings("rawtypes")
	public static synchronized DataStore getNewDataStore(String newSchema) {
		Map<String, Object> params = new HashMap<String, Object>();
		// if (dataStore != null) {
		// return dataStore;
		// }

		if(newSchema == null) {
			newSchema = schema;
		}
		
		params.put("dbtype", dbtype);
		params.put("host", host);
		params.put("port", port);
		params.put("database", dbname);
		params.put("schema", newSchema);
		params.put("user", username);
		params.put("passwd", password);

//		for( Iterator i=DataStoreFinder.getAvailableDataStores(); i.hasNext(); ){
//		    DataStoreFactorySpi factory = (DataStoreFactorySpi) i.next();
//
//		    System.out.println( factory.getDisplayName());
//		}

		try {
			dataStore = DataStoreFinder.getDataStore(params);
		} catch (NullPointerException e) {
			logger.debug(e);
		} catch (Exception e) {
			logger.debug(e);
		}
		return dataStore;
	}

	public static void dispose(DataStore dataStore) {
		if (dataStore != null) {
			try {
				dataStore.dispose();
				dataStore = null;
			} catch (NullPointerException e) {
				dataStore = null;
				logger.debug(e);
			} catch (Exception e) {
				dataStore = null;
				logger.debug(e);
			}
		}
	}

	public static SimpleFeatureCollection getSimpleFeatureCollection(String typeName) throws NullPointerException, Exception {
		return getDataStore().getFeatureSource(typeName).getFeatures();
	}

	public static String getSearchedFeatures(String layrNm, String fieldNm, String searchTxt) {
		DataStore ds = null;
		String jsonStr = "[]";
		try {
			String[] layerNms = layrNm.split("[.]");
			String schema = layerNms[0];
			String layer = layerNms[1];
			
			ds = getNewDataStore(schema);
			SimpleFeatureSource sfs = ds.getFeatureSource(layer);

			FilterFactory2 ff = CommonFactoryFinder.getFilterFactory2();

			Boolean numStat = false;
			
			try {
				AttributeDescriptor adsc = sfs.getSchema().getDescriptor(fieldNm);
				
				Class clazz = adsc.getType().getBinding();
				if(Number.class.isAssignableFrom(clazz)) {
					numStat = true;
				}
			} catch (NullPointerException e) {
				numStat = false;
				logger.debug(e);
			} catch (Exception e) {
				numStat = false;
				logger.debug(e);
			}	
			SimpleFeatureCollection sfc = null;
			if(numStat) {
				PropertyIsEqualTo pil = ff.equals(ff.property(fieldNm), ff.literal(Double.parseDouble(searchTxt)));	
				sfc = sfs.getFeatures(pil);
			}else {
				PropertyIsLike pil = ff.like(ff.property(fieldNm), "%" + searchTxt + "%");				
				sfc = sfs.getFeatures(pil);
			}


			jsonStr = SHJsonHelper.featureCollectionToGeoJson(sfc);
		} catch (NullPointerException e) {
			logger.debug(e);
		} catch (Exception e) {
			logger.debug(e);
		} finally {
			dispose(ds);
		}

		return jsonStr;
	}
}
