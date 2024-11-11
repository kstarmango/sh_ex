package egovframework.mango.analysis.process;

import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

import org.geotools.data.collection.ListFeatureCollection;
import org.geotools.data.simple.SimpleFeatureCollection;
import org.geotools.data.simple.SimpleFeatureIterator;
import org.geotools.factory.CommonFactoryFinder;
import org.geotools.feature.simple.SimpleFeatureBuilder;
import org.geotools.geometry.jts.GeometryCoordinateSequenceTransformer;
import org.geotools.geometry.jts.JTS;
import org.geotools.geometry.jts.JTSFactoryFinder;
import org.geotools.process.spatialstatistics.core.FeatureTypes;
import org.geotools.referencing.CRS;
import org.geotools.util.logging.Logging;
import org.locationtech.jts.geom.Geometry;
import org.locationtech.jts.geom.GeometryCollection;
import org.locationtech.jts.geom.GeometryComponentFilter;
import org.locationtech.jts.geom.GeometryFactory;
import org.locationtech.jts.geom.LineString;
import org.locationtech.jts.geom.MultiLineString;
import org.locationtech.jts.geom.MultiPoint;
import org.locationtech.jts.geom.MultiPolygon;
import org.locationtech.jts.geom.Point;
import org.locationtech.jts.geom.Polygon;
import org.locationtech.jts.operation.overlayng.CoverageUnion;
import org.locationtech.jts.operation.overlayng.OverlayNG;
import org.locationtech.jts.operation.overlayng.OverlayNGRobust;
import org.locationtech.jts.operation.union.CascadedPolygonUnion;
import org.opengis.feature.simple.SimpleFeature;
import org.opengis.feature.simple.SimpleFeatureType;
import org.opengis.filter.Filter;
import org.opengis.filter.FilterFactory2;
import org.opengis.referencing.FactoryException;
import org.opengis.referencing.crs.CoordinateReferenceSystem;
import org.opengis.referencing.operation.MathTransform;
import org.opengis.referencing.operation.TransformException;

/**
 * Geometry & Features Utilities
 * 
 * A utility class for handling operations with Geometries and Features using GeoTools and JTS. Provides functionality for masking, clipping, merging,
 * intersecting, and transforming geometries.
 * 
 * @author MangoSystem
 */
public class FeatureUtils {
    protected static final Logger LOGGER = Logging.getLogger(FeatureUtils.class);

    static final GeometryFactory gf = JTSFactoryFinder.getGeometryFactory(null);

    static final FilterFactory2 ff = CommonFactoryFinder.getFilterFactory2(null);

    static final String ID_FIELD = "id";

    //@FunctionalInterface
    //private interface OverlayMethod {
    //    Geometry apply(Geometry a, Geometry b);
   // }
    
    interface OverlayMethod {
        Geometry apply(Geometry a, Geometry b);
    }

    public static SimpleFeatureCollection maskFeatures(SimpleFeatureCollection source,
            Geometry maskArea) {
        Filter maskFilter = getIntersectionFilter(source.getSchema(), maskArea);
        return source.subCollection(maskFilter);
    }

    public static Filter getIntersectionFilter(SimpleFeatureType schema, Geometry searchGeometry) {
        String geomField = schema.getGeometryDescriptor().getLocalName();
        return ff.and(ff.bbox(ff.property(geomField), JTS.toEnvelope(searchGeometry)),
                ff.intersects(ff.property(geomField), ff.literal(searchGeometry)));
    }

    public static SimpleFeatureType createTemplateSchema(String typeName, Class<?> geometryBinding,
            CoordinateReferenceSystem crs) {
        SimpleFeatureType schema = FeatureTypes.getDefaultType(typeName, geometryBinding, crs);
        return FeatureTypes.add(schema, ID_FIELD, Integer.class, 5);
    }

    public static SimpleFeatureCollection transformFeatures(SimpleFeatureCollection sourceFeatures,
            CoordinateReferenceSystem targetCRS) {
        SimpleFeatureType schema = sourceFeatures.getSchema();
        CoordinateReferenceSystem sourceCRS = schema.getCoordinateReferenceSystem();

        if (CRS.equalsIgnoreMetadata(sourceCRS, targetCRS)) {
            return sourceFeatures;
        }

        GeometryCoordinateSequenceTransformer transformer = getTransformer(sourceCRS, targetCRS,
                true);

        schema = FeatureTypes.build(schema, schema.getTypeName(), targetCRS);
        ListFeatureCollection features = new ListFeatureCollection(schema);
        
        SimpleFeatureBuilder builder = new SimpleFeatureBuilder(schema);
        
        try (SimpleFeatureIterator featureIter = sourceFeatures.features()) {
            while (featureIter.hasNext()) {
                SimpleFeature feature = featureIter.next();
                Geometry geometry = (Geometry) feature.getDefaultGeometry();
                if (geometry != null && !geometry.isEmpty()) {
                	for (Object attribute : feature.getAttributes()) {
                        if (attribute instanceof Geometry) {
                            try {
                                attribute = transformer.transform((Geometry) attribute);
                            } catch (TransformException e) {
                                String msg = "Error occured transforming " + attribute.toString();
                                LOGGER.log(Level.WARNING, msg);
                            }
                        }
                        builder.add(attribute);
                    }
                    features.add(builder.buildFeature(feature.getID()));
                }
            }
        }

        return features;
    }

    public static SimpleFeatureCollection clipFeatures(SimpleFeatureCollection sourceFeatures,
            Geometry clip) {
        SimpleFeatureType schema = sourceFeatures.getSchema();
        ListFeatureCollection features = new ListFeatureCollection(schema);

        try (SimpleFeatureIterator featureIter = sourceFeatures.features()) {
            while (featureIter.hasNext()) {
                SimpleFeature feature = featureIter.next();
                Geometry geometry = (Geometry) feature.getDefaultGeometry();
                Geometry clipped = intersect(geometry, clip, Polygon.class);
                if (clipped != null && !clipped.isEmpty()) {
                    feature.setDefaultGeometry(clipped);
                    features.add(feature);
                }
            }
        }

        return features;
    }

    public static double getArea(SimpleFeatureCollection sourceFeatures) {
        double area = 0.0d;
        try (SimpleFeatureIterator featureIter = sourceFeatures.features()) {
            while (featureIter.hasNext()) {
                SimpleFeature feature = featureIter.next();
                Geometry geometry = (Geometry) feature.getDefaultGeometry();
                if (geometry != null && !geometry.isEmpty()) {
                    area += geometry.getArea();
                }
            }
        }
        return area;
    }

    public static SimpleFeatureCollection buildFeatures(List<Geometry> geometries, String typeName,
            Class<?> geometryBinding, CoordinateReferenceSystem crs) {
        SimpleFeatureType schema = createTemplateSchema(typeName, geometryBinding, crs);
        ListFeatureCollection features = new ListFeatureCollection(schema);
        SimpleFeatureBuilder builder = new SimpleFeatureBuilder(schema);

        if (geometries == null || geometries.isEmpty()) {
            features.add(createEmptyFeature(builder, schema, 1));
            return features;
        }

        for (int index = 0; index < geometries.size(); index++) {
            Geometry geometry = geometries.get(index);
            if (geometry != null && !geometry.isEmpty()) {
                features.add(createFeature(builder, geometry, index + 1, crs));
            }
        }

        return features;
    }

    public static SimpleFeatureCollection buildFeatures(Geometry geometries, String typeName,
            Class<?> geometryBinding, CoordinateReferenceSystem crs) {
        SimpleFeatureType schema = createTemplateSchema(typeName, geometryBinding, crs);
        ListFeatureCollection features = new ListFeatureCollection(schema);
        SimpleFeatureBuilder builder = new SimpleFeatureBuilder(schema);

        if (geometries == null || geometries.isEmpty()) {
            features.add(createEmptyFeature(builder, schema, 1));
            return features;
        }

        for (int index = 0; index < geometries.getNumGeometries(); index++) {
            Geometry geometry = geometries.getGeometryN(index);
            if (geometry != null && !geometry.isEmpty()) {
                features.add(createFeature(builder, geometry, index + 1, crs));
            }
        }

        return features;
    }

    private static SimpleFeature createFeature(SimpleFeatureBuilder builder, Geometry geometry,
            int id, CoordinateReferenceSystem crs) {
        geometry.setUserData(crs);
        SimpleFeature newFeature = builder.buildFeature(ID_FIELD + "." + id);
        newFeature.setDefaultGeometry(geometry);
        newFeature.setAttribute(ID_FIELD, id);
        return newFeature;
    }

    private static SimpleFeature createEmptyFeature(SimpleFeatureBuilder builder,
            SimpleFeatureType schema, int id) {
        SimpleFeature newFeature = builder.buildFeature(schema.getTypeName() + "." + id);
        newFeature.setAttribute(ID_FIELD, id);
        return newFeature;
    }

    //public static Geometry difference(Geometry source, Geometry overlay, Class<?> target) {
    //    return performOverlayOperation(source, overlay, target, OverlayNG.DIFFERENCE,
    //            Geometry::difference);
    //}

    //public static Geometry intersect(Geometry source, Geometry overlay, Class<?> target) {
    //    return performOverlayOperation(source, overlay, target, OverlayNG.INTERSECTION,
    //            Geometry::intersection);
    //}
    
    public static Geometry difference(Geometry source, Geometry overlay, Class<?> target) {
        return performOverlayOperation(source, overlay, target, OverlayNG.DIFFERENCE,
            new OverlayMethod() {
                @Override
                public Geometry apply(Geometry a, Geometry b) {
                    return a.difference(b);
                }
            });
    }

    public static Geometry intersect(Geometry source, Geometry overlay, Class<?> target) {
        return performOverlayOperation(source, overlay, target, OverlayNG.INTERSECTION,
            new OverlayMethod() {
                @Override
                public Geometry apply(Geometry a, Geometry b) {
                    return a.intersection(b);
                }
            });
    }

    private static Geometry performOverlayOperation(Geometry source, Geometry overlay,
            Class<?> target, int operation, OverlayMethod method) {
        if (overlay == null || overlay.isEmpty())
            return source;

        Geometry intersection = null;
        try {
            intersection = OverlayNGRobust.overlay(source.buffer(0), overlay.buffer(0), operation);
        } catch (NullPointerException e) {
        	 LOGGER.log(Level.INFO, "Null 오류 ");
             try {
                 intersection = method.apply(source, overlay);
             } catch (NullPointerException ee) {
                 LOGGER.log(Level.INFO, "Null 오류 ");
                 intersection = method.apply(source.buffer(0), overlay.buffer(0));
             } catch (Exception ee) {
                 LOGGER.log(Level.INFO, "Null 오류 ");
                 intersection = method.apply(source.buffer(0), overlay.buffer(0));
             }
    	} catch (Exception e) {
            LOGGER.log(Level.INFO, "Null 오류 ");
            try {
                intersection = method.apply(source, overlay);
            } catch (NullPointerException ee) {
                LOGGER.log(Level.INFO, "Null 오류 ");
                intersection = method.apply(source.buffer(0), overlay.buffer(0));
            } catch (Exception ee) {
                LOGGER.log(Level.INFO, "Null 오류 ");
                intersection = method.apply(source.buffer(0), overlay.buffer(0));
            }
        } 

        return mapToTargetType(intersection, target);
    }

    private static Geometry mapToTargetType(Geometry geometry, Class<?> target) {
        if (geometry == null || geometry.getNumGeometries() == 0) {
            return null;
        }

        if (target.isAssignableFrom(geometry.getClass())) {
            return geometry;
        }

        if (Point.class.isAssignableFrom(target) || MultiPoint.class.isAssignableFrom(target)
                || GeometryCollection.class.equals(target)) {
            return geometry;
        }

        List<Geometry> filteredGeometries = filterGeometries(geometry, target);
        if (filteredGeometries.isEmpty()) {
            return null;
        }

        return buildGeometryFromList(filteredGeometries, geometry.getFactory(), target);
    }

    private static List<Geometry> filterGeometries(Geometry geometry, final Class<?> target) {
        final List<Geometry> geometries = new ArrayList<Geometry>();
        geometry.apply(new GeometryComponentFilter() {
            @Override
            public void filter(Geometry geom) {
                if (target.isAssignableFrom(geom.getClass())) {
                    geometries.add(geom);
                }
            }
        });
        return geometries;
    }

    private static Geometry buildGeometryFromList(List<Geometry> geometries,
            GeometryFactory factory, Class<?> target)  throws IllegalArgumentException{
        if (LineString.class.isAssignableFrom(target)
                || MultiLineString.class.isAssignableFrom(target)) {
            return factory.createMultiLineString(geometries.toArray(new LineString[0]));
        } else if (Polygon.class.isAssignableFrom(target)
                || MultiPolygon.class.isAssignableFrom(target)) {
            return factory.createMultiPolygon(geometries.toArray(new Polygon[0]));
        } else {
            throw new IllegalArgumentException(
                    "Unrecognized target type: " + target.getCanonicalName());
        }
    }

    public static Geometry mergeGeometries(List<SimpleFeatureCollection> featuresList,
            CoordinateReferenceSystem targetCRS) {
        List<Geometry> geometries = new ArrayList<Geometry>();
        for (SimpleFeatureCollection features : featuresList) {
            Geometry unionGeometry = unionGeometries(features, targetCRS);
            if (unionGeometry != null && !unionGeometry.isEmpty()) {
                geometries.add(unionGeometry);
            }
        }

        return geometries.isEmpty() ? null : unionGeometries(geometries);
    }

    public static Geometry calculateIntersection(Geometry... geometries) {
        Geometry intersection = geometries[0];
        for (int i = 1; i < geometries.length; i++) {
            intersection = intersect(intersection, geometries[i], Polygon.class);
            if (intersection == null || intersection.isEmpty()) {
                return null;
            }
        }
        return intersection;
    }

    public static Geometry unionGeometries(SimpleFeatureCollection features) {
        return unionGeometries(features, features.getSchema().getCoordinateReferenceSystem());
    }

    public static Geometry unionGeometries(SimpleFeatureCollection features,
            CoordinateReferenceSystem targetCRS) {
        List<Geometry> geometries = extractGeometries(features, targetCRS);
        return geometries.isEmpty() ? null : unionGeometries(geometries);
    }

    private static List<Geometry> extractGeometries(SimpleFeatureCollection features,
            CoordinateReferenceSystem targetCRS) {
        List<Geometry> geometries = new ArrayList<Geometry>();
        if (features == null) {
            return geometries;
        }

        CoordinateReferenceSystem sourceCRS = features.getSchema().getCoordinateReferenceSystem();
        if (!CRS.equalsIgnoreMetadata(sourceCRS, targetCRS)) {
            features = transformFeatures(features, targetCRS);
        }

        try (SimpleFeatureIterator featureIter = features.features()) {
            while (featureIter.hasNext()) {
                SimpleFeature feature = featureIter.next();
                Geometry geometry = (Geometry) feature.getDefaultGeometry();
                if (geometry != null && !geometry.isEmpty()) {
                    geometries.add(geometry);
                }
            }
        }
        return geometries;
    }

    public static Geometry unionGeometries(List<Geometry> geometries) {
        if (geometries.size() == 0) {
            return null;
        } else if (geometries.size() == 1) {
            return geometries.get(0);
        }

        try {
            return CoverageUnion.union(gf.buildGeometry(geometries));
        } catch (NullPointerException e) {
        	LOGGER.log(Level.INFO, "Null 오류 ");
            List<Geometry> geometries2 = new ArrayList<>();
            for(Geometry g : geometries) {
            	g = g.buffer(0);
            	geometries2.add(g);
            }
            return CascadedPolygonUnion.union(geometries2);
        } catch (Exception e) {
            LOGGER.log(Level.INFO, "Null 오류 ");
            List<Geometry> geometries2 = new ArrayList<>();
            for(Geometry g : geometries) {
            	g = g.buffer(0);
            	geometries2.add(g);
            }
            return CascadedPolygonUnion.union(geometries2);
        }
    }

    public static Geometry confirmTransform(Geometry input, CoordinateReferenceSystem sourceCRS,
            CoordinateReferenceSystem targetCRS) {
        if (!CRS.equalsIgnoreMetadata(sourceCRS, targetCRS)) {
            try {
                GeometryCoordinateSequenceTransformer trans = getTransformer(sourceCRS, targetCRS,
                        true);
                return trans.transform(input);
            } catch (TransformException e) {
                LOGGER.log(Level.WARNING, "Transformation failed: ", e);
            }
        }
        return input;
    }

    public static GeometryCoordinateSequenceTransformer getTransformer(
            CoordinateReferenceSystem sourceCRS, CoordinateReferenceSystem targetCRS,
            boolean lenient) throws IllegalArgumentException{
        try {
            MathTransform transform = CRS.findMathTransform(sourceCRS, targetCRS, lenient);
            GeometryCoordinateSequenceTransformer transformer = new GeometryCoordinateSequenceTransformer();
            transformer.setMathTransform(transform);
            transformer.setCoordinateReferenceSystem(targetCRS);
            return transformer;
        } catch (FactoryException e) {
            throw new IllegalArgumentException("Could not create math transform", e);
        }
    }
}
