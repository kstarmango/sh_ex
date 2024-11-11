package egovframework.mango.util;

import java.awt.AlphaComposite;
import java.awt.Color;
import java.awt.Graphics2D;
import java.awt.Rectangle;
import java.awt.RenderingHints;
import java.awt.image.BufferedImage;
import java.util.HashMap;
import java.util.Map;

import org.geotools.coverage.GridSampleDimension;
import org.geotools.coverage.grid.GridCoverage2D;
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
import org.geotools.process.spatialstatistics.RasterToImageProcessFactory;
import org.geotools.process.spatialstatistics.core.FeatureTypes;
import org.geotools.process.spatialstatistics.core.MapToImageParam;
import org.geotools.process.spatialstatistics.core.StatisticsVisitor;
import org.geotools.process.spatialstatistics.core.StatisticsVisitorResult;
import org.geotools.process.spatialstatistics.core.StatisticsVisitor.DoubleStrategy;
import org.geotools.process.spatialstatistics.core.StatisticsVisitor.StatisticsStrategy;
import org.geotools.process.spatialstatistics.gridcoverage.RasterHelper;
import org.geotools.renderer.GTRenderer;
import org.geotools.renderer.lite.StreamingRenderer;
import org.geotools.styling.ChannelSelection;
import org.geotools.styling.ColorMap;
import org.geotools.styling.ContrastEnhancement;
import org.geotools.styling.RasterSymbolizer;
import org.geotools.styling.SLD;
import org.geotools.styling.SelectedChannelType;
import org.geotools.styling.Stroke;
import org.geotools.styling.Style;
import org.geotools.styling.StyleBuilder;
import org.geotools.styling.StyleFactory;
import org.opengis.feature.simple.SimpleFeature;
import org.opengis.feature.simple.SimpleFeatureType;
import org.opengis.feature.type.AttributeDescriptor;
import org.opengis.feature.type.GeometryDescriptor;
import org.opengis.filter.Filter;
import org.opengis.filter.FilterFactory2;
import org.opengis.referencing.crs.CoordinateReferenceSystem;
import org.opengis.style.ContrastMethod;

public class SHImageHelper {
	static final FilterFactory2 ff = CommonFactoryFinder.getFilterFactory2(null);

	static final StyleFactory sf = CommonFactoryFinder.getStyleFactory(null);

    static final Color LINE_COLOR = new Color(110, 110, 110);

    static final float LINE_WIDTH = 0.5f;

    private static float opacity = 1.0f;

    private static Stroke lineStroke;

    private static SimpleFeatureType featureType = null;

    private static String geometryField = null;
	
	public static BufferedImage getImage(GridCoverage2D coverage, String bbox, CoordinateReferenceSystem crs, 
			Style style, Integer width, Integer height, String format, 
			Boolean transparent, String bgColor) throws NullPointerException, Exception {
		
		RasterToImageProcessFactory factory = new RasterToImageProcessFactory();
		org.geotools.process.Process process = factory.create();
		Map<String, Object> param = new HashMap<>();
		
		param.put(RasterToImageProcessFactory.coverage.key, coverage);
		param.put(RasterToImageProcessFactory.bbox.key, bbox);
		param.put(RasterToImageProcessFactory.crs.key, crs);
		param.put(RasterToImageProcessFactory.style.key, style);
		param.put(RasterToImageProcessFactory.width.key, width);
		param.put(RasterToImageProcessFactory.height.key, height);
		param.put(RasterToImageProcessFactory.format.key, format);
		param.put(RasterToImageProcessFactory.transparent.key, transparent);
		param.put(RasterToImageProcessFactory.bgColor.key, bgColor);
		
		Map<String, Object> resultMap = process.execute(param, null);
		
		MapToImageParam mapImage = (MapToImageParam) resultMap
				.get(RasterToImageProcessFactory.RESULT.key);
		
		
		BufferedImage result = getBufferedImage(mapImage);
		
		return result;
	}

	public static BufferedImage getBufferedImage(MapToImageParam info) throws NullPointerException, Exception {
		
		// prepare map context
        MapContent mapContent = new MapContent();
        mapContent.getViewport().setCoordinateReferenceSystem(info.getSrs());
        
        Style style = info.getStyle();
        if (info.getInputFeatures() == null) {
            mapContent.layers().add(new GridCoverageLayer(info.getInputCoverage(), style));
        } else {
            // convert string type to number type
            Filter filter = info.getFilter();
            SimpleFeatureCollection sfc = info.getInputFeatures();
            if (filter != Filter.INCLUDE && filter != null) {
                sfc = retypeCheck(info.getInputFeatures()).subCollection(filter);
            }
            mapContent.layers().add(new FeatureLayer(sfc, style));
        }
        mapContent.getViewport().setBounds(info.getMapExtent());

        // export map
        GTRenderer renderer = new StreamingRenderer();
        renderer.setMapContent(mapContent);

        RenderingHints hints = new RenderingHints(RenderingHints.KEY_ANTIALIASING,
                RenderingHints.VALUE_ANTIALIAS_ON);
        renderer.setJava2DHints(hints);

        Map<Object, Object> rendererParams = new HashMap<Object, Object>();
        rendererParams.put("optimizedDataLoadingEnabled", Boolean.TRUE);
        renderer.setRendererHints(rendererParams);

        BufferedImage image = new BufferedImage(info.getWidth(), info.getHeight(),
                BufferedImage.TYPE_INT_ARGB);
        Graphics2D graphics = image.createGraphics();
        
        graphics.setRenderingHints(hints);

        Rectangle paintArea = new Rectangle(0, 0, info.getWidth(), info.getHeight());
        ReferencedEnvelope mapArea = mapContent.getViewport().getBounds();
        if (info.getTransparent()) {
        	graphics.setComposite(AlphaComposite.Clear);
            graphics.fillRect(0, 0, info.getWidth(), info.getHeight());
            graphics.setComposite(AlphaComposite.SrcOver);
            renderer.paint(graphics, paintArea, mapArea);
        } else {
            graphics.setPaint(info.getBackgroundColor());
            graphics.fill(paintArea);
            renderer.paint(graphics, paintArea, mapArea);
        }

        // cleanup
        graphics.dispose();
        mapContent.dispose();
        
        return image;
		
	}
	
	private static SimpleFeatureCollection retypeCheck(SimpleFeatureCollection sfc) {
        SimpleFeatureType schema = sfc.getSchema();

        // 1. check value
        Map<String, String> fieldMap = new HashMap<String, String>();
        SimpleFeatureIterator featureIter = sfc.features();
        try {
            while (featureIter.hasNext()) {
                SimpleFeature feature = featureIter.next();
                for (AttributeDescriptor descriptor : schema.getAttributeDescriptors()) {
                    if (descriptor instanceof GeometryDescriptor) {
                        continue;
                    } else {
                        final String propertyName = descriptor.getLocalName();
                        Object val = feature.getAttribute(propertyName);
                        try {
                            if (val != null) {
                                Double.parseDouble(val.toString().trim());
                                fieldMap.put(propertyName, propertyName);
                            }
                        } catch (NumberFormatException e) {
                        	continue;
                        }
                    }
                }
                break;
            }
        } finally {
            featureIter.close();
        }

        // 2. if required, retype schema
        if (fieldMap.size() > 0) {
            SimpleFeatureTypeBuilder sftBuilder = new SimpleFeatureTypeBuilder();
            sftBuilder.setNamespaceURI(FeatureTypes.NAMESPACE_URL);
            sftBuilder.setName(schema.getName());
            sftBuilder.setCRS(schema.getCoordinateReferenceSystem());

            for (AttributeDescriptor descriptor : schema.getAttributeDescriptors()) {
                if (descriptor instanceof GeometryDescriptor) {
                    sftBuilder.add(descriptor);
                } else {
                    final String propertyName = descriptor.getLocalName();
                    if (fieldMap.containsKey(propertyName)) {
                        sftBuilder.add(propertyName, Number.class);
                    } else {
                        sftBuilder.add(descriptor);
                    }
                }
            }

            // return retyping features
            SimpleFeatureType retypeSchema = sftBuilder.buildFeatureType();
            ListFeatureCollection featureCollection = new ListFeatureCollection(retypeSchema);
            SimpleFeatureBuilder builder = new SimpleFeatureBuilder(retypeSchema);

            featureIter = sfc.features();
            try {
                while (featureIter.hasNext()) {
                    SimpleFeature feature = featureIter.next();
                    SimpleFeature newFeature = builder.buildFeature(feature.getID());
                    for (AttributeDescriptor descriptor : retypeSchema.getAttributeDescriptors()) {
                        String name = descriptor.getLocalName();
                        if (descriptor instanceof GeometryDescriptor) {
                            newFeature.setDefaultGeometry(feature.getDefaultGeometry());
                        } else {
                            Object val = feature.getAttribute(name);
                            if (descriptor.getType().getBinding().isAssignableFrom(Number.class)) {
                                newFeature.setAttribute(name, Double.parseDouble(val.toString()));
                            } else {
                                newFeature.setAttribute(name, val);
                            }
                        }
                    }
                    featureCollection.add(newFeature);
                }
            } finally {
                featureIter.close();
            }
            return featureCollection;
        }
        return sfc;
    }
	
	public static Style getDefaultGridCoverageStyle(GridCoverage2D coverage) {
        Style rasterStyle = null;
        int numBands = coverage.getNumSampleDimensions();

        if (numBands >= 3) {
            rasterStyle = createRGBStyle(coverage);
        } else {
        	 Color[] colors = new Color[] { new Color(0, 0, 0, 0), new Color(50,136,189, 255), new Color(102,194,165, 255),
             		new Color(171,221,164, 255), new Color(230,245,152, 255), new Color(255,255,191, 255), new Color(254,224,139, 255),
             		new Color(253,174,97, 255), new Color(244,109,67, 255), new Color(213,62,79, 255)};

             StatisticsStrategy strategy = new DoubleStrategy();
             strategy.setNoData(RasterHelper.getNoDataValue(coverage));

             StatisticsVisitor visitor = new StatisticsVisitor(strategy);
             visitor.visit(coverage, 0);
             StatisticsVisitorResult ret = visitor.getResult();

             String[] descs = new String[] { "No Data", "10", "20", "30", "40", "50", "60", "70", "80", "90" };

             double mean = ret.getMean();
             double nodata = Double.parseDouble(ret.getNoData().toString());
             double[] values = new double[] { nodata, 10,20,30,40,50,60,70,80,90 };

            StyleBuilder sb = new StyleBuilder();
            ColorMap colorMap = sb.createColorMap(descs, values, colors, ColorMap.TYPE_RAMP);
            rasterStyle = sb.createStyle(sb.createRasterSymbolizer(colorMap, 1.0));
        }

        return rasterStyle;
    }
	
	 public static Style createRGBStyle(GridCoverage2D coverage) {
	        // We need at least three bands to create an RGB style
	        int numBands = coverage.getNumSampleDimensions();
	        if (numBands < 3) {
	            return null;
	        }
	        // Get the names of the bands
	        String[] sampleDimensionNames = new String[numBands];
	        for (int i = 0; i < numBands; i++) {
	            GridSampleDimension dim = coverage.getSampleDimension(i);
	            sampleDimensionNames[i] = dim.getDescription().toString();
	        }

	        final int RED = 0, GREEN = 1, BLUE = 2;
	        int[] channelNum = { -1, -1, -1 };
	        // We examine the band names looking for "red...", "green...", "blue...".
	        // Note that the channel numbers we record are indexed from 1, not 0.
	        for (int i = 0; i < numBands; i++) {
	            String name = sampleDimensionNames[i].toLowerCase();
	            if (name != null) {
	                if (name.matches("red.*")) {
	                    channelNum[RED] = i + 1;
	                } else if (name.matches("green.*")) {
	                    channelNum[GREEN] = i + 1;
	                } else if (name.matches("blue.*")) {
	                    channelNum[BLUE] = i + 1;
	                }
	            }
	        }
	        // If we didn't find named bands "red...", "green...", "blue..."
	        // we fall back to using the first three bands in order
	        if (channelNum[RED] < 0 || channelNum[GREEN] < 0 || channelNum[BLUE] < 0) {
	            channelNum[RED] = 1;
	            channelNum[GREEN] = 2;
	            channelNum[BLUE] = 3;
	        }
	        // Now we create a RasterSymbolizer using the selected channels
	        SelectedChannelType[] sct = new SelectedChannelType[coverage.getNumSampleDimensions()];
	        ContrastEnhancement ce = sf.contrastEnhancement(ff.literal(1.0), ContrastMethod.NORMALIZE);
	        for (int i = 0; i < 3; i++) {
	            sct[i] = sf.createSelectedChannelType(String.valueOf(channelNum[i]), ce);
	        }
	        RasterSymbolizer sym = sf.getDefaultRasterSymbolizer();
	        ChannelSelection sel = sf.channelSelection(sct[RED], sct[GREEN], sct[BLUE]);
	        sym.setChannelSelection(sel);

	        return SLD.wrapSymbolizers(sym);
	    }
}
