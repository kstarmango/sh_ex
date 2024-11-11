package egovframework.mango.util;

import java.io.File;
import java.io.IOException;
import java.io.Serializable;
import java.nio.charset.Charset;
import java.nio.charset.StandardCharsets;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.time.temporal.ChronoUnit;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;

import org.apache.commons.io.FileDeleteStrategy;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.geotools.coverage.grid.GridCoverage2D;
import org.geotools.data.DataStore;
import org.geotools.data.DefaultTransaction;
import org.geotools.data.FeatureWriter;
import org.geotools.data.Transaction;
import org.geotools.data.collection.ListFeatureCollection;
import org.geotools.data.shapefile.ShapefileDataStore;
import org.geotools.data.shapefile.ShapefileDataStoreFactory;
import org.geotools.data.shapefile.ShapefileDumper;
import org.geotools.data.simple.SimpleFeatureCollection;
import org.geotools.data.simple.SimpleFeatureIterator;
import org.geotools.feature.simple.SimpleFeatureBuilder;
import org.geotools.feature.simple.SimpleFeatureTypeBuilder;
import org.geotools.gce.geotiff.GeoTiffWriter;
import org.geotools.geometry.jts.JTS;
import org.geotools.geometry.jts.JTSFactoryFinder;
import org.geotools.process.spatialstatistics.storage.DataStoreFactory;
import org.geotools.process.spatialstatistics.storage.ShapeExportOperation;
import org.geotools.referencing.CRS;
import org.locationtech.jts.geom.Coordinate;
import org.locationtech.jts.geom.Geometry;
import org.locationtech.jts.geom.GeometryFactory;
import org.locationtech.jts.geom.LineString;
import org.locationtech.jts.geom.MultiLineString;
import org.locationtech.jts.geom.MultiPoint;
import org.locationtech.jts.geom.MultiPolygon;
import org.locationtech.jts.geom.Point;
import org.locationtech.jts.geom.Polygon;
import org.opengis.feature.Property;
import org.opengis.feature.simple.SimpleFeature;
import org.opengis.feature.simple.SimpleFeatureType;
import org.opengis.feature.type.AttributeDescriptor;
import org.opengis.feature.type.GeometryDescriptor;
import org.opengis.referencing.FactoryException;
import org.opengis.referencing.crs.CoordinateReferenceSystem;
import org.opengis.referencing.operation.MathTransform;

import com.fasterxml.jackson.databind.ObjectMapper;

import egovframework.mango.config.SHResource;
import egovframework.mango.link.bld.web.LinkBldController;

public class Util {
	private static Logger logger = LogManager.getLogger(Util.class);

	public static double transformUnit(int sourceCRSCode, int targetCRSCode, double distance) throws NullPointerException, Exception {
		CoordinateReferenceSystem sourceCRS = CRS.decode("EPSG:" + sourceCRSCode);
		CoordinateReferenceSystem targetCRS = CRS.decode("EPSG:" + targetCRSCode);

		return transformUnit(sourceCRS, targetCRS, distance);
	}

	public static double transformUnit(CoordinateReferenceSystem sourceCRS, CoordinateReferenceSystem targetCRS,
			double distance) {
		try {
			double x = 0;
			double y = 0;

			GeometryFactory geometryFactory = JTSFactoryFinder.getGeometryFactory();

			MathTransform transform = CRS.findMathTransform(sourceCRS, targetCRS, true);

			Point startPoint = geometryFactory.createPoint(new Coordinate(x, y));
			Point endPointX = geometryFactory.createPoint(new Coordinate(x + distance, y));
			Point endPointY = geometryFactory.createPoint(new Coordinate(x, y + distance));

			Point startPointTransformed = (Point) JTS.transform(startPoint, transform);
			Point endPointXTransformed = (Point) JTS.transform(endPointX, transform);
			Point endPointYTransformed = (Point) JTS.transform(endPointY, transform);

			// 변환 후 경도/위도 차이 계산
			double deltaLongitude = endPointXTransformed.getX() - startPointTransformed.getX();
			double deltaLatitude = endPointYTransformed.getY() - startPointTransformed.getY();

			return deltaLongitude;

		} catch (NullPointerException e) {
			return 0;
		} catch (Exception e) {
			return 0;
		}
	}

	public static File resultFileMake(String exportId) {
		String demPath = SHResource.getValue("dem.file.path");
		File demFile = new File(demPath);
		File zipFile = new File(demFile.getParentFile().getParentFile().getAbsolutePath() + File.separator + "zip");

		String resultDate = exportId.substring(0, exportId.indexOf("-"));
		String resultUUID = exportId.substring(exportId.indexOf("-") + 1, exportId.length());
		File resultFile = new File(
				zipFile.getAbsolutePath() + File.separator + resultDate + File.separator + resultUUID);
		if (!resultFile.exists()) {
			resultFile.setExecutable(false);
			resultFile.setReadable(true);
			resultFile.setWritable(false, true);
			resultFile.mkdirs();
		}

		return resultFile;
	}

	public static void shpExport(String exportId, String shpName, SimpleFeatureCollection sfc) {
		ShapeExportOperation seo = new ShapeExportOperation();
		try {
			File resultFile = resultFileMake(exportId);
			seo.setOutputDataStore(DataStoreFactory.getShapefileDataStore(resultFile.getAbsolutePath()));
			seo.setOutputTypeName(shpName);

			SimpleFeatureTypeBuilder newTypeBuilder = new SimpleFeatureTypeBuilder();
			newTypeBuilder.init(sfc.getSchema());

			Class clazz = sfc.getSchema().getGeometryDescriptor().getType().getBinding();
			if (org.locationtech.jts.geom.Geometry.class.isAssignableFrom(clazz)) {
				SimpleFeatureIterator sfi = null;
				try {
					sfi = sfc.features();
					while (sfi.hasNext()) {
						SimpleFeature sf = sfi.next();
						org.locationtech.jts.geom.Geometry g = (org.locationtech.jts.geom.Geometry) sf
								.getDefaultGeometry();
						if (g != null) {
							Class taergetClazz = org.locationtech.jts.geom.Geometry.class;
							if (g instanceof Point) {
								taergetClazz = Point.class;
							} else if (g instanceof LineString) {
								taergetClazz = LineString.class;
							} else if (g instanceof Polygon) {
								taergetClazz = Polygon.class;
							} else if (g instanceof MultiPoint) {
								taergetClazz = MultiPoint.class;
							} else if (g instanceof MultiLineString) {
								taergetClazz = MultiLineString.class;
							} else if (g instanceof MultiPolygon) {
								taergetClazz = MultiPolygon.class;
							}
							String geomName = sf.getDefaultGeometryProperty().getName().getLocalPart();
							newTypeBuilder.remove(geomName);
							newTypeBuilder.add(geomName, taergetClazz, sfc.getSchema().getCoordinateReferenceSystem());
							break;
						}
					}
				} finally {
					try {
						if (sfi != null) {
							sfi.close();
						}
					} catch (NullPointerException e) {
						sfi = null;
					} catch (Exception e) {
						sfi = null;
					}
				}
			}

			SimpleFeatureType newSchema = newTypeBuilder.buildFeatureType();

			ListFeatureCollection lfc = new ListFeatureCollection(newSchema);
			SimpleFeatureBuilder sfb = new SimpleFeatureBuilder(newSchema);

			SimpleFeatureIterator sfi = null;
			try {
				sfi = sfc.features();
				int id = 0;
				while (sfi.hasNext()) {
					id++;
					SimpleFeature sf = sfi.next();
					SimpleFeature tgSf = fixForShapeFile(id, sf, sfb);
					lfc.add(tgSf);
				}
			} finally {
				try {
					if (sfi != null) {
						sfi.close();
					}
				} catch (NullPointerException e) {
					sfi = null;
				} catch (Exception e) {
					sfi = null;
				}
			}

			seo.execute(lfc);
		} catch (NullPointerException e) {
			seo = null;
		} catch (Exception e) {
			seo = null;
		}
//		try {
//			File resultFile = resultFileMake(exportId);
//
//			File shpFile = new File(resultFile.getAbsolutePath() + File.separator + shpName + ".shp");
//			ShapefileDataStoreFactory dataStoreFactory = new ShapefileDataStoreFactory();
//			Map<String, Serializable> params = new HashMap<>();
//			params.put("url", shpFile.toURI().toURL());
//			params.put("create spatial index", Boolean.TRUE);
//
//			ShapefileDataStore dataStore = (ShapefileDataStore) dataStoreFactory.createDataStore(params);
//
//			SimpleFeatureType featureType = sfc.getSchema();
//			dataStore.createSchema(featureType);
//
//			dataStore.setCharset(StandardCharsets.UTF_8);
//
//			Transaction transaction = new DefaultTransaction("create");
//			FeatureWriter<SimpleFeatureType, SimpleFeature> featureWriter = dataStore
//					.getFeatureWriterAppend(transaction);
//
//			try {
//				SimpleFeatureIterator iterator = sfc.features();
//				while (iterator.hasNext()) {
//					SimpleFeature feature = iterator.next();
//					SimpleFeature toWrite = featureWriter.next();
//					
//					toWrite.setAttributes(feature.getAttributes());
//					featureWriter.write();
//				}
//				iterator.close();
//				transaction.commit();
//			} catch (Exception e) {
//				transaction.rollback();
//				throw e;
//			} finally {
//				featureWriter.close();
//				transaction.close();
//			}
//
//		} catch (IOException ioe) {
//
//		} catch (Exception e) {
//			e.printStackTrace();
//		}
	}

	public static SimpleFeatureCollection simpleFeatureCollectionTypeFix(SimpleFeatureCollection sfc) {
		Class binding = sfc.getSchema().getGeometryDescriptor().getType().getBinding();
		if (!org.locationtech.jts.geom.Geometry.class.isAssignableFrom(binding)) {
			return sfc;
		}
		SimpleFeatureTypeBuilder newTypeBuilder = new SimpleFeatureTypeBuilder();
		newTypeBuilder.init(sfc.getSchema());

		// Class clazz = sfc.getSchema().getGeometryDescriptor().getType().getBinding();
		if (org.locationtech.jts.geom.Geometry.class.isAssignableFrom(binding)) {
			SimpleFeatureIterator sfi = null;
			try {
				sfi = sfc.features();
				while (sfi.hasNext()) {
					SimpleFeature sf = sfi.next();
					org.locationtech.jts.geom.Geometry g = (org.locationtech.jts.geom.Geometry) sf.getDefaultGeometry();
					if (g != null) {
						Class taergetClazz = org.locationtech.jts.geom.Geometry.class;
						if (g instanceof Point) {
							taergetClazz = Point.class;
						} else if (g instanceof LineString) {
							taergetClazz = LineString.class;
						} else if (g instanceof Polygon) {
							taergetClazz = Polygon.class;
						} else if (g instanceof MultiPoint) {
							taergetClazz = MultiPoint.class;
						} else if (g instanceof MultiLineString) {
							taergetClazz = MultiLineString.class;
						} else if (g instanceof MultiPolygon) {
							taergetClazz = MultiPolygon.class;
						}
						String geomName = sf.getDefaultGeometryProperty().getName().getLocalPart();
						newTypeBuilder.remove(geomName);
						newTypeBuilder.add(geomName, taergetClazz, sfc.getSchema().getCoordinateReferenceSystem());
						break;
					}
				}
			} finally {
				try {
					if (sfi != null) {
						sfi.close();
					}
				} catch (NullPointerException e) {
					sfi = null;
				} catch (Exception e) {
					sfi = null;
				}
			}

		}

		SimpleFeatureType newSchema = newTypeBuilder.buildFeatureType();

		ListFeatureCollection lfc = new ListFeatureCollection(newSchema);
		SimpleFeatureBuilder sfb = new SimpleFeatureBuilder(newSchema);

		SimpleFeatureIterator sfi = sfc.features();
		int id = 0;
		while (sfi.hasNext()) {
			id++;
			SimpleFeature sf = sfi.next();
			fixForShapeFile(id, sf, sfb);
			lfc.add(sf);
		}

		return lfc;
	}

	public static void tiffExport(String exportId, String mapNm, GridCoverage2D o) {
		try {
			File resultFile = resultFileMake(exportId);

			File tifFile = new File(resultFile.getAbsolutePath() + File.separator + mapNm + ".tif");
			GeoTiffWriter writer = null;

			try {
				writer = new GeoTiffWriter(tifFile);
				writer.write(o, null);
			} catch (IOException e) {
				logger.debug("IO 오류  ");
			} finally {
				if (writer != null) {
					try {
						writer.dispose();
					} catch (NullPointerException e) {
						logger.debug("Null 오류  ");
					} catch (Exception e) {
						logger.debug("오류  ");
					}
				}
			}
		} catch (NullPointerException ioe) {
			logger.debug("Null 오류  ");
		} catch (Exception e) {
			logger.debug("오류  ");
		}
	}

	public static void mapExport(String exportId, String mapNm, Object o) {
		try {
			File resultFile = resultFileMake(exportId);

			File jsonFile = new File(resultFile.getAbsolutePath() + File.separator + mapNm + ".txt");

			ObjectMapper objectMapper = new ObjectMapper();

			objectMapper.writeValue(jsonFile, o);
		} catch (NullPointerException e) {
			logger.debug(e);
		} catch (Exception e) {
			logger.debug(e);
		}
	}

	public static void deleteFolder(String path) {

		File folder = new File(path);
		try {
			if (folder.exists()) {
				File[] folder_list = folder.listFiles(); // 파일리스트 얻어오기

				for (int i = 0; i < folder_list.length; i++) {
					if (folder_list[i].isFile()) {
						FileDeleteStrategy.FORCE.delete(folder_list[i]);
//						folder_list[i].delete();
					} else {
						deleteFolder(folder_list[i].getPath()); // 재귀함수호출
					}
//					FileDeleteStrategy.FORCE.delete(folder_list[i]);
//					folder_list[i].delete();
				}
				FileDeleteStrategy.FORCE.delete(folder);
//				folder.delete(); // 폴더 삭제
			}
		} catch (NullPointerException e) {
			logger.debug(e);
		} catch (Exception e) {
			logger.debug(e);
		}
	}

	public static String makeResultZip(String exportId) {
		File resultFile = null;
		try {
			resultFile = resultFileMake(exportId);

			String zipPath = resultFile.getAbsolutePath() + ".zip";
			File zipFile = new File(zipPath);
			if (zipFile.exists()) {
				return zipPath;
			}

			ArchiveUtils2 au = new ArchiveUtils2();
			au.zip(resultFile.getAbsolutePath(), zipPath);

			return zipPath;
		} catch (NullPointerException e) {
			logger.debug(e);
		} catch (Exception e) {
			logger.debug(e);
		} finally {
			try {
				deleteFolder(resultFile.getAbsolutePath());
			} catch (NullPointerException e) {
				logger.debug(e);
			} catch (Exception e) {
				logger.debug(e);
			}
		}

		return null;
	}

	public static void cleanResult(String exportId, int day) {
		File resultFile = null;
		try {
			resultFile = resultFileMake(exportId);
			File parentFile = resultFile.getParentFile().getParentFile();
			String[] restDates = parentFile.list();
			for (String r : restDates) {
				try {
					Integer.parseInt(r);

					DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyyMMdd");
					LocalDate inputDate = LocalDate.parse(r, formatter);
					LocalDate today = LocalDate.now();
					long daysDifference = ChronoUnit.DAYS.between(inputDate, today);
					if (daysDifference > day) {
						deleteFolder(parentFile.getAbsolutePath() + File.separator + r);
					}
				} catch (NumberFormatException npe) {
					logger.debug(npe);
				} catch (Exception e) {
					logger.debug(e);
				}
			}
		} catch (NullPointerException npe) {
			logger.debug(npe);
		} catch (Exception e) {
			logger.debug(e);
		}
	}

	public static Object castGeometry(Object obj, Class geomBinding) {
		try {
			if (Point.class.isAssignableFrom(geomBinding)) {
				return (Point) obj;
			} else if (MultiPoint.class.isAssignableFrom(geomBinding)) {
				return (MultiPoint) obj;
			} else if (LineString.class.isAssignableFrom(geomBinding)) {
				return (LineString) obj;
			} else if (MultiLineString.class.isAssignableFrom(geomBinding)) {
				return (MultiLineString) obj;
			} else if (Polygon.class.isAssignableFrom(geomBinding)) {
				return (Polygon) obj;
			} else if (MultiPolygon.class.isAssignableFrom(geomBinding)) {
				return (MultiPolygon) obj;
			}
			return obj;
		} catch (ClassCastException e) {
			return obj;
		} catch (Exception e) {
			return obj;
		}
	}

	public static SimpleFeature fixForShapeFile(int id, SimpleFeature targetSf, SimpleFeatureBuilder sfb) {
		SimpleFeature tgSf = sfb.buildFeature("" + id);
		for (AttributeDescriptor adesc : targetSf.getFeatureType().getAttributeDescriptors()) {
			if (adesc instanceof GeometryDescriptor) {
				Class geomBinding = sfb.getFeatureType().getGeometryDescriptor().getType().getBinding();
				Object o = castGeometry(targetSf.getDefaultGeometry(), geomBinding);
				targetSf.setAttribute(adesc.getLocalName(), o);
				tgSf.setAttribute(adesc.getLocalName(), o);

			} else {
				String localName = adesc.getLocalName();
				Object val = targetSf.getAttribute(localName);
				tgSf.setAttribute(localName, val);
				if (!(val instanceof String)) {
					continue;
				}
				String s = (String) val;
				if (s != null) {
					if (s.getBytes().length > 250) {

						byte[] byteArray = s.getBytes(Charset.forName("utf-8"));
						byte[] subArray = new byte[250];
						System.arraycopy(byteArray, 0, subArray, 0, subArray.length);
						s = new String(subArray, Charset.forName("utf-8"));

						tgSf.setAttribute(localName, s);
					}
				}
			}
		}
		return tgSf;
	}

	public static Geometry transform(CoordinateReferenceSystem source, CoordinateReferenceSystem target, Geometry roi)
			throws NullPointerException, Exception {
		MathTransform mt = getTransformation(source, target);
		Geometry transformedGeometry = JTS.transform(roi, mt);
		return transformedGeometry;
	}

	public static MathTransform getTransformation(CoordinateReferenceSystem source, CoordinateReferenceSystem target)
			throws FactoryException {
		MathTransform transform = CRS.findMathTransform(source, target);

		return transform;
	}
}
