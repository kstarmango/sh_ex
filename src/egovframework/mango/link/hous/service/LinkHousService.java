package egovframework.mango.link.hous.service;

import java.awt.Graphics2D;
import java.awt.Rectangle;
import java.awt.RenderingHints;
import java.awt.image.BufferedImage;
import java.io.ByteArrayOutputStream;
import java.util.HashMap;
import java.util.Map;
import java.util.logging.Level;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.apache.xalan.lib.sql.SQLQueryParser;

import javax.imageio.ImageIO;

import org.geotools.coverage.grid.GridCoverage2D;
import org.geotools.data.DataStore;
import org.geotools.data.collection.ListFeatureCollection;
import org.geotools.data.simple.SimpleFeatureCollection;
import org.geotools.data.simple.SimpleFeatureIterator;
import org.geotools.factory.CommonFactoryFinder;
import org.geotools.feature.simple.SimpleFeatureBuilder;
import org.geotools.feature.simple.SimpleFeatureTypeBuilder;
import org.geotools.geometry.jts.ReferencedEnvelope;
import org.geotools.map.FeatureLayer;
import org.geotools.map.GridCoverageLayer;
import org.geotools.map.MapContent;
import org.geotools.process.spatialstatistics.BufferExpressionProcessFactory;
import org.geotools.process.spatialstatistics.KernelDensityProcessFactory;
import org.geotools.process.spatialstatistics.MultipleRingBufferProcessFactory;
import org.geotools.process.spatialstatistics.PointStatisticsProcessFactory;
import org.geotools.process.spatialstatistics.RasterToImageProcessFactory;
import org.geotools.process.spatialstatistics.core.FeatureTypes;
import org.geotools.process.spatialstatistics.core.MapToImageParam;
import org.geotools.renderer.GTRenderer;
import org.geotools.renderer.lite.StreamingRenderer;
import org.geotools.styling.Style;
import org.json.simple.JSONArray;
import org.locationtech.jts.geom.Coordinate;
import org.locationtech.jts.geom.GeometryFactory;
import org.locationtech.jts.geom.LinearRing;
import org.locationtech.jts.geom.Polygon;
import org.opengis.feature.simple.SimpleFeature;
import org.opengis.feature.simple.SimpleFeatureType;
import org.opengis.feature.type.AttributeDescriptor;
import org.opengis.feature.type.GeometryDescriptor;
import org.opengis.filter.Filter;
import org.opengis.filter.FilterFactory2;
import org.opengis.referencing.crs.CoordinateReferenceSystem;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import egovframework.mango.link.hous.service.impl.LinkHousDAO;
import egovframework.mango.link.hous.web.LinkHousController;
import egovframework.mango.config.SHDataStore;
import egovframework.mango.util.SHImageHelper;
import egovframework.mango.util.SHJsonHelper;

@Service
public class LinkHousService {
	
	private static Logger logger = LogManager.getLogger(LinkHousService.class);

	@Autowired
	LinkHousDAO housDAO;

	
	
	
	
	
	
	

}
