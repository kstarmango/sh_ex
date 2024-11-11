package egovframework.mango.util;

import java.io.IOException;
import java.io.StringWriter;
import java.util.Collection;
import java.util.HashMap;
import java.util.Map;
import java.util.Set;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.geotools.data.collection.ListFeatureCollection;
import org.geotools.data.simple.SimpleFeatureCollection;
import org.geotools.data.simple.SimpleFeatureIterator;
import org.geotools.feature.simple.SimpleFeatureBuilder;
import org.geotools.feature.simple.SimpleFeatureTypeBuilder;
import org.geotools.geojson.feature.FeatureJSON;
import org.geotools.geojson.geom.GeometryJSON;
import org.geotools.geometry.jts.WKTReader2;
import org.geotools.process.spatialstatistics.core.FeatureTypes;
import org.geotools.referencing.crs.DefaultGeographicCRS;
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.locationtech.jts.geom.Geometry;
import org.locationtech.jts.geom.MultiPolygon;
import org.locationtech.jts.geom.Point;
import org.locationtech.jts.geom.Polygon;
import org.locationtech.jts.io.ParseException;
import org.opengis.feature.Property;
import org.opengis.feature.simple.SimpleFeature;
import org.opengis.feature.simple.SimpleFeatureType;

import egovframework.mango.link.hous.web.LinkHousController;

public class SHJsonHelper {
	
	private static Logger logger = LogManager.getLogger(SHJsonHelper.class);

   public static final String DATA_NAME_ATT_TITLE = "title";
   public static final String DATA_NAME_ATT_NAME = "name";
   public static final String DATA_NAME_ATT_VALUE = "value";
   public static final String DATA_NAME_DATA = "data";
   public static final String DATA_NAME_BODY = "body";
   public static final String DATA_NAME_HEAD = "header";
   public static final String DATA_NAME_ATT_GEOM = "geometry";
   public static final String DATA_NAME_ATT_TYPE = "type";
   public static final String DATA_REFACTOR_TYPE_NAME = "refactor_type";
   public static final String DATA_REFACTOR_TYPE_ATT_NAME = "attribute";
   public static final String DATA_REFACTOR_TYPE_DATA_TITLE = "json_data";
   public static final String DATA_REFACTOR_FOMULAR = "fomular";
   public static final String DATA_REFACTOR_RESULT = "result";
   
   @SuppressWarnings({ "unchecked", "rawtypes" })
   public static SimpleFeatureType createSimpleFeatureType(String name, JSONObject jo) {
      SimpleFeatureType sft = FeatureTypes.getDefaultType(name, Geometry.class, null);
      Set<Object> keys = jo.keySet();
      for (Object key : keys) {
         Class claz = String.class;
         try {
            String type = "String";
            type = (String) ((JSONObject) jo.get(key)).get(DATA_REFACTOR_TYPE_NAME);
            claz = getBinding(type);
         } catch (NullPointerException e) {
 			logger.debug(e);
 		} catch (Exception e) {
 			logger.debug(e);
 		}
         sft = FeatureTypes.add(sft, (String) key, claz, 100);
      }

      return sft;
   }

   @SuppressWarnings("rawtypes")
   private static Class getBinding(String type) {
      if (type.equalsIgnoreCase("String")) {
         return String.class;
      } else if (type.equalsIgnoreCase("Integer")) {
         return Integer.class;
      } else if (type.equalsIgnoreCase("Double")) {
         return Double.class;
      } else if (type.equalsIgnoreCase("Long")) {
         return Long.class;
      } else if (type.equalsIgnoreCase("Float")) {
         return Float.class;
      } else if (type.equalsIgnoreCase("Boolean")) {
         return Boolean.class;
      } else {
         return String.class;
      }
   }

   @SuppressWarnings({ "unchecked", "rawtypes" })
   public static SimpleFeature jsonToSimpleFeature(int primaryIdx, String name, JSONObject jo, SimpleFeatureType sft) {
      if (sft == null) {
         sft = createSimpleFeatureType(name, jo);
      }
      SimpleFeatureBuilder sfb = new SimpleFeatureBuilder(sft);
      SimpleFeature sf = sfb.buildFeature("" + primaryIdx);

      Set<Object> keys = jo.keySet();
      for (Object key : keys) {
         if(key != null && key.toString().equalsIgnoreCase(DATA_NAME_ATT_GEOM)) {
            continue;
         }
         Object value = ((JSONObject) jo.get(key)).get(DATA_NAME_ATT_VALUE);
         try {
            Class claz = sf.getProperty((String) key).getType().getBinding();
            value = ((String) value).trim();
            
            value = getBindingValue((String) value, claz);
         } catch (NullPointerException e) {
 			logger.debug(e);
 		} catch (Exception e) {
 			logger.debug(e);
 		}
         sf.setAttribute((String) key, value);
      }
      if(keys.contains(DATA_NAME_ATT_GEOM)) {
         try {
            String geomWKT = (String) ((JSONObject) jo.get(DATA_NAME_ATT_GEOM)).get(DATA_NAME_ATT_VALUE);
            WKTReader2 wktReader = new WKTReader2();
         
            Geometry g = wktReader.read(geomWKT);
            sf.setDefaultGeometry(g);
         } catch (ParseException e) {
        	 logger.debug("파싱오류 ");
         }
      }
      return sf;
   }

   @SuppressWarnings({ "rawtypes", "unchecked" })
   private static Object getBindingValue(String value, Class binding) {
      if (binding.isAssignableFrom(String.class)) {
         return value;
      } else if (binding.isAssignableFrom(Integer.class)) {
         return Integer.parseInt(value);
      } else if (binding.isAssignableFrom(Double.class)) {
         return Double.parseDouble(value);
      } else if (binding.isAssignableFrom(Long.class)) {
         return Long.parseLong(value);
      } else if (binding.isAssignableFrom(Float.class)) {
         return Float.parseFloat(value);
      } else if (binding.isAssignableFrom(Boolean.class)) {
         return Boolean.parseBoolean(value);
      }

      return value;
   }

   public static SimpleFeatureCollection jsonToSimpleFeatureCollection(String name, JSONArray ja) {
      JSONObject jo = (JSONObject) ja.get(0);
      SimpleFeatureType sft = createSimpleFeatureType(name, jo);
      SimpleFeatureCollection sfc = new ListFeatureCollection(sft);
      int size = ja.size();
      for (int i = 0; i < size; i++) {
         jo = (JSONObject) ja.get(i);
         SimpleFeature sf = jsonToSimpleFeature(i, name, jo, sft);
         ((ListFeatureCollection) sfc).add(sf);
      }

      return sfc;
   }

   @SuppressWarnings({ "unchecked", "rawtypes" })
   public static Map<String, SimpleFeatureCollection> jsonToSimpleFeatureCollectionMap(JSONObject joMap) {
      Map<String, SimpleFeatureCollection> collectionMap = new HashMap();
      Set<Object> mapKeys = joMap.keySet();
      for (Object mapKey : mapKeys) {
         JSONObject jo = (JSONObject) joMap.get(mapKey);
         Set<Object> keys = jo.keySet();
         for (Object key : keys) {
            JSONArray dataJa = (JSONArray) jo.get(key);
            SimpleFeatureCollection sfc = jsonToSimpleFeatureCollection((String) key, dataJa);
            collectionMap.put((String) key, sfc);
         }
      }

      return collectionMap;
   }

   public static JSONObject refactorDataTableMapForKEI(String jsonStr) throws NullPointerException, Exception {
      JSONParser jParser = new JSONParser();
      Object o = jParser.parse(jsonStr);
      JSONArray ja = (JSONArray) o;
      return refactorDataTableMapForKEI(ja);
   }
   
   @SuppressWarnings("unchecked")
   public static JSONObject refactorDataTableMapForKEI(JSONArray ja) throws NullPointerException, Exception {
      JSONObject jsonMap = new JSONObject();
      for (int jaIdx = 0; jaIdx < ja.size(); jaIdx++) {
         JSONObject jaData = (JSONObject) ja.get(jaIdx);
         String dtTitle = (String) jaData.get(DATA_NAME_ATT_TITLE);
         JSONArray subJa = refactorDataSubTableForKEI(jaData);
         jsonMap.put(dtTitle, subJa);
      }
      return jsonMap;
   }

   @SuppressWarnings("unchecked")
   public static JSONArray refactorDataSubTableForKEI(JSONObject jo) throws NullPointerException, Exception {
      JSONObject joData = (JSONObject) jo.get(DATA_NAME_DATA);
      JSONArray jaBody = (JSONArray) joData.get(DATA_NAME_BODY);
      JSONArray jaHeader = (JSONArray) joData.get(DATA_NAME_HEAD);

      JSONArray refactoryJA = new JSONArray();
      for (int i = 0; i < jaBody.size(); i++) {
         JSONArray jaData = (JSONArray) jaBody.get(i);
         JSONObject refactoryJO = new JSONObject();
         for (int j = 0; j < jaHeader.size(); j++) {
            JSONObject joHeader = (JSONObject) jaHeader.get(j);
            String title = (String) joHeader.get(DATA_NAME_ATT_TITLE);
            ((JSONObject) jaData.get(j)).put(DATA_REFACTOR_TYPE_NAME, joHeader.get(DATA_NAME_ATT_TYPE));
            refactoryJO.put(title, jaData.get(j));
         }
         refactoryJA.add(refactoryJO);
      }

      return refactoryJA;
   }

   public static JSONArray refactorDataTableForKEI(String jsonStr) throws NullPointerException, Exception {
      JSONParser jParser = new JSONParser();
      Object o = jParser.parse(jsonStr);

      return refactorDataSubTableForKEI((JSONObject) o);
   }
   
   @SuppressWarnings("unchecked")
   public static JSONArray simpleFeatureCollectionToJson(SimpleFeatureCollection sfc) {
      SimpleFeatureIterator sfi = sfc.features();
      JSONArray ja = new JSONArray();
      while(sfi.hasNext()) {
         SimpleFeature sf = sfi.next();
         JSONObject jo = simpleFeatureToJson(sf);
         ja.add(jo);
      }
      return ja;
   }
   
   @SuppressWarnings("unchecked")
   public static JSONArray simpleFeatureCollectionToJson2(SimpleFeatureCollection sfc) {
      SimpleFeatureIterator sfi = sfc.features();
      JSONArray ja = new JSONArray();
      while(sfi.hasNext()) {
         SimpleFeature sf = sfi.next();
         JSONObject jo = simpleFeatureToJson2(sf);
         ja.add(jo);
      }
      return ja;
   }
   
   public static String featureCollectionToGeoJson(SimpleFeatureCollection sfc) {
	   GeometryJSON GeometryJson = new GeometryJSON(15);
      FeatureJSON featureJSON = new FeatureJSON(GeometryJson);
        StringWriter writer = new StringWriter();
        try {
            featureJSON.writeFeatureCollection(sfc, writer);
            String geoJson = writer.toString();
            
            return geoJson;
        } catch (IOException e) {
        	logger.debug("파싱오류 ");
        }
        
        return null;
   }
   
   public static String featureToGeoJson(SimpleFeature sf) {
	   GeometryJSON GeometryJson = new GeometryJSON(15);
	      FeatureJSON featureJSON = new FeatureJSON(GeometryJson);
	        StringWriter writer = new StringWriter();
	        try {
	            featureJSON.writeFeature(sf, writer);
	            String geoJson = writer.toString();
	            
	            return geoJson;
	        } catch (IOException e) {
	        	logger.debug("파싱오류 ");
	        }
	        
	        return null;
	   }
   
   @SuppressWarnings("unchecked")
   public static JSONObject simpleFeatureToJson(SimpleFeature sf) {
      JSONObject jo = new JSONObject();
      Collection<Property> properties = sf.getProperties();
      String title = sf.getName().getLocalPart();
      jo.put(DATA_NAME_ATT_TITLE, title);
      
      JSONArray ja = new JSONArray();
      for(Property p : properties) {
         JSONObject fieldJo = new JSONObject();
         String field = p.getName().getLocalPart();
         Object value = p.getValue();
         if(value != null && value instanceof Geometry) {
            value = ((Geometry) value).toText();
         }
         fieldJo.put(DATA_NAME_ATT_VALUE, value);
         fieldJo.put(DATA_NAME_ATT_TITLE, field);
         fieldJo.put(DATA_NAME_ATT_TYPE, p.getType().getBinding().getSimpleName());
         ja.add(fieldJo);
         //jo.put("data", fieldJo);
      }
      jo.put(DATA_REFACTOR_TYPE_ATT_NAME, ja);
      return jo;
   }
   
   @SuppressWarnings("unchecked")
   public static JSONObject simpleFeatureToJson2(SimpleFeature sf) {
      JSONObject jo = new JSONObject();
      Collection<Property> properties = sf.getProperties();
      String title = sf.getName().getLocalPart();
      jo.put(DATA_NAME_ATT_TITLE, title);
      
      //JSONArray ja = new JSONArray();
      for(Property p : properties) {
         String field = p.getName().getLocalPart();
         Object value = p.getValue();
         if(value != null && value instanceof Geometry) {
            value = ((Geometry) value).toText();
         }
         jo.put(field, value);
         jo.put(DATA_NAME_ATT_TYPE, p.getType().getBinding().getSimpleName());
         //jo.put("data", fieldJo);
      }
      return jo;
   }
	
	public static String geometryToGeoJson(Geometry geom) {
		GeometryJSON featureJSON = new GeometryJSON(15);
       StringWriter writer = new StringWriter();
       try {
           featureJSON.write(geom, writer);
           String geoJson = writer.toString();
           
           return geoJson;
       } catch (IOException e) {
    	   logger.debug("파싱오류 ");
       }
       
       return null;
	}
	
	public static SimpleFeature createPolygonFeature(String typeName, String geomName, String polygonWKT) throws NullPointerException, Exception{

		WKTReader2 reader = new WKTReader2();
		// Geometry geometry = reader.read(inputWKT);
		Geometry geometry = null;
		try {
			geometry = (Geometry) reader.read(polygonWKT);
		} catch (ParseException e) {
			throw e;
		} catch (ClassCastException e) {
			throw e;
		}

		SimpleFeatureTypeBuilder typeBuilder = new SimpleFeatureTypeBuilder();
		typeBuilder.setName(typeName);
		typeBuilder.setCRS(DefaultGeographicCRS.WGS84);

		if(geometry instanceof Polygon) {
			typeBuilder.add(geomName, Polygon.class);
		} else if(geometry instanceof MultiPolygon) {
			typeBuilder.add(geomName, MultiPolygon.class);
		} else {
			geometry = geometry.buffer(0.00000001);
			if(geometry instanceof Polygon) {
				typeBuilder.add(geomName, Polygon.class);
			} else if(geometry instanceof MultiPolygon) {
				typeBuilder.add(geomName, MultiPolygon.class);
			}
		}

		final SimpleFeatureType TYPE = typeBuilder.buildFeatureType();

		SimpleFeatureBuilder builder = new SimpleFeatureBuilder(TYPE);
		builder.add(geometry);

		SimpleFeature feature = builder.buildFeature(null);

		return feature;
	}
}