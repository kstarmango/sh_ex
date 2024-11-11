package egovframework.mango.analysis.cmmn.web;

import java.awt.image.BufferedImage;
import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.OutputStream;
import java.util.Arrays;
import java.util.List;

import javax.annotation.PostConstruct;
import javax.imageio.ImageIO;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.geotools.coverage.grid.GridCoverage2D;
import org.geotools.process.spatialstatistics.enumeration.KernelType;
import org.geotools.process.spatialstatistics.styler.SSStyleBuilder;
import org.geotools.referencing.CRS;
import org.geotools.styling.Style;
import org.json.simple.JSONArray;
import org.opengis.referencing.crs.CoordinateReferenceSystem;
import org.opengis.referencing.operation.MathTransform;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import com.fasterxml.jackson.core.JsonEncoding;
import com.fasterxml.jackson.core.JsonFactory;
import com.fasterxml.jackson.core.JsonGenerator;
import com.fasterxml.jackson.databind.DeserializationFeature;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.PropertyNamingStrategy;

import egovframework.mango.analysis.cmmn.service.AnalysisCmmnService;
import egovframework.mango.util.SHImageHelper;
import egovframework.mango.util.Util;
import egovframework.syesd.cmmn.constants.RequestMappingConstants;
import egovframework.zaol.common.web.BaseController;

@Controller
public class AnalysisCmmnController extends BaseController {

	private static Logger logger = LogManager.getLogger(AnalysisCmmnController.class);

	private ObjectMapper mapper;

	@Autowired
	private AnalysisCmmnService anCmmnService;

	@PostConstruct
	public void initIt() throws NullPointerException, Exception {
		mapper = new ObjectMapper();
		mapper.setPropertyNamingStrategy(PropertyNamingStrategy.SNAKE_CASE);
		mapper.configure(DeserializationFeature.FAIL_ON_UNKNOWN_PROPERTIES, false);
	}

	// 버퍼 분석
	@RequestMapping(value = { RequestMappingConstants.WEB_ANAL_CMMN_BUFFER }, method = { RequestMethod.POST })
	public void buffer(HttpServletRequest request, HttpServletResponse response,
			@RequestParam(value = "schema", required = false) String schema,
			@RequestParam(value = "inputFeatures", required = true) String inputFeatures,
			@RequestParam(value = "distance", required = true) String distance,
			@RequestParam(value = "unit", required = false) String distanceUnit,
			@RequestParam(value = "outsideOnly", required = false) String outsideOnly,
			@RequestParam(value = "dissolve", required = false) String dissolve)
			throws NullPointerException, Exception {

		boolean boutsideOnly = true;
		boolean bdissolve = false;

		if (outsideOnly != null) {
			try {
				boutsideOnly = Boolean.valueOf(outsideOnly);
			} catch (NullPointerException e) {
				logger.debug(e);
			} catch (Exception e) {
				logger.debug(e);
			}
		}

		if (dissolve != null) {
			try {
				bdissolve = Boolean.valueOf(dissolve);
			} catch (NullPointerException e) {
				logger.debug(e);
			} catch (Exception e) {
				logger.debug(e);
			}
		}
		String exportId = getResultExportId();
		response.setHeader("export_key", exportId);
		JSONArray result = anCmmnService.getBufferFeatures(exportId, schema, inputFeatures, distance, distanceUnit,
				boutsideOnly, bdissolve);

		response.setContentType("application/json");
		response.setCharacterEncoding("UTF-8");

		JsonFactory jsonFactory = new JsonFactory();
		try (JsonGenerator jsonGenerator = jsonFactory.createGenerator(response.getOutputStream(), JsonEncoding.UTF8)) {
			ObjectMapper objectMapper = new ObjectMapper();
			jsonGenerator.writeStartArray();

			int size = result.size();
			for (int i = 0; i < size; i++) {
				objectMapper.writeValue(jsonGenerator, result.get(i));
				jsonGenerator.flush(); // 데이터를 강제로 플러시하여 전송
			}

			jsonGenerator.writeEndArray();
			jsonGenerator.flush();
		}

	}

	// 커널 타입 목록
//	@RequestMapping(value = { RequestMappingConstants.WEB_ANAL_CMMN_DENSITY_KERNEL_TYPES }, method = { RequestMethod.POST, RequestMethod.GET })
//	public void kernelTypes(HttpServletRequest request, HttpServletResponse response)
//			throws NullPointerException, Exception {
//
//		List<KernelType> enumList = Arrays.asList(KernelType.values());
//		response.setContentType("application/json");
//		response.setCharacterEncoding("UTF-8");
//		
//		JsonFactory jsonFactory = new JsonFactory();
//		try (JsonGenerator jsonGenerator = jsonFactory.createGenerator(response.getOutputStream(), JsonEncoding.UTF8)) {
//			ObjectMapper objectMapper = new ObjectMapper();
//			jsonGenerator.writeStartArray();
//
//			int size = enumList.size();
//			for (int i = 0; i < size; i++) {
//				objectMapper.writeValue(jsonGenerator, enumList.get(i));
//				jsonGenerator.flush(); // 데이터를 강제로 플러시하여 전송
//			}
//
//			jsonGenerator.writeEndArray();
//			jsonGenerator.flush();
//		}
//
//	}

	// 밀도분석
	@RequestMapping(value = { RequestMappingConstants.WEB_ANAL_CMMN_DENSITY }, method = { RequestMethod.POST,
			RequestMethod.GET })
	public void density(HttpServletRequest request, HttpServletResponse response,
			@RequestParam(value = "schema", required = false) String schema,
			@RequestParam(value = "inputFeatures", required = true) String inputFeatures,
			@RequestParam(value = "kernelType", required = false) KernelType kernelType,
			@RequestParam(value = "populationField", required = false) String populationField,
			@RequestParam(value = "searchRadius", required = false) String searchRadius,
			@RequestParam(value = "cellSize", required = false) String cellSize,
			@RequestParam(value = "minX", required = false) Double minX,
			@RequestParam(value = "maxX", required = false) Double maxX,
			@RequestParam(value = "minY", required = false) Double minY,
			@RequestParam(value = "maxY", required = false) Double maxY,
			@RequestParam(value = "width", required = true) int width,
			@RequestParam(value = "height", required = true) int height,
			@RequestParam(value = "bgColor", required = false) String bgColor) throws NullPointerException, Exception {

		double dcellSize = 0;
		if (cellSize != null) {
			try {
				dcellSize = Double.parseDouble(cellSize);
			} catch (NullPointerException e) {
				logger.debug(e);
			} catch (Exception e) {
				logger.debug(e);
			}
		}

		// double dminx = 0, dmaxx = 0, dminy =0, dmaxy = 0;
		//
		// if (minX != null) {
		// dminx = Double.parseDouble(minX);
		// }
		// if (maxX != null) {
		// dmaxx = Double.parseDouble(maxX);
		// }
		// if (minY != null) {
		// dminy = Double.parseDouble(minY);
		// }
		// if (maxY != null) {
		// dmaxy = Double.parseDouble(maxY);
		// }
		String exportId = getResultExportId();
		response.setHeader("export_key", exportId);

		CoordinateReferenceSystem sourceCrs = CRS.decode("EPSG:3857");
		CoordinateReferenceSystem targetCrs = CRS.decode("EPSG:4326");

		MathTransform mt = CRS.findMathTransform(sourceCrs, targetCrs);

		double[] sourcePoint = new double[4];
		double[] targetPoint = new double[4];
		sourcePoint[0] = minX;
		sourcePoint[1] = minY;
		sourcePoint[2] = maxX;
		sourcePoint[3] = maxY;

		mt.transform(sourcePoint, 0, targetPoint, 0, 2);

		GridCoverage2D grid = anCmmnService.getDensity(exportId, schema, inputFeatures, kernelType, populationField,
				searchRadius, dcellSize, targetPoint[0], targetPoint[2], targetPoint[1], targetPoint[3]);

		SSStyleBuilder styleBuilder = new SSStyleBuilder(null);
		Style style = styleBuilder.createRGBStyle(grid);
		style = SHImageHelper.getDefaultGridCoverageStyle(grid);

		BufferedImage image = SHImageHelper.getImage(grid, null, null, style, width, height, "image/png", true,
				bgColor);

		ByteArrayOutputStream baos = null;
		try {
			baos = new ByteArrayOutputStream();
			// write image
			ImageIO.write(image, "png", baos);
			byte[] imageBytes = baos.toByteArray();
			response.setContentType("image/png");
			response.setContentLength(imageBytes.length);

			String imgName = inputFeatures;
			response.setHeader("Content-Disposition", "attachment; filename=" + imgName + ".png");
			response.getOutputStream().write(imageBytes);
		} finally {
			try {
				if (baos != null) {
					baos.close();
				}
			} catch (NullPointerException e) {
				log.debug("Null 오류 ");
			} catch (Exception e) {
				log.debug("Null 오류 ");
			}
		}

		// return new HttpEntity<byte[]>(baos.getByteArray(), headers);
	}

	// 포인트 집계
	@RequestMapping(value = { RequestMappingConstants.WEB_ANAL_CMMN_POINT }, method = { RequestMethod.POST })
	public void pointStatistics(HttpServletRequest request, HttpServletResponse response,
			@RequestParam(value = "inputSchema", required = false) String inputSchema,
			@RequestParam(value = "overlaySchema", required = false) String overlaySchema,
			@RequestParam(value = "polygonFeatures", required = true) String polygonFeatures,
			@RequestParam(value = "pointFeatures", required = true) String pointFeatures,
			@RequestParam(value = "countField", required = false) String countField,
			@RequestParam(value = "statisticsFields", required = false) String statisticsFields)
			throws NullPointerException, Exception {

		String exportId = getResultExportId();
		response.setHeader("export_key", exportId);

		JSONArray result = anCmmnService.getPointStatistics(exportId, inputSchema, overlaySchema, polygonFeatures,
				pointFeatures, countField, statisticsFields);

		response.setContentType("application/json");
		response.setCharacterEncoding("UTF-8");

		JsonFactory jsonFactory = new JsonFactory();
		try {
			JsonGenerator jsonGenerator = jsonFactory.createGenerator(response.getOutputStream(), JsonEncoding.UTF8);
			ObjectMapper objectMapper = new ObjectMapper();
			jsonGenerator.writeStartArray();

			int size = result.size();
			for (int i = 0; i < size; i++) {

				objectMapper.writeValue(jsonGenerator, result.get(i));
				jsonGenerator.flush(); // 데이터를 강제로 플러시하여 전송
			}

			jsonGenerator.writeEndArray();
			jsonGenerator.flush();
		} catch (NullPointerException e) {
			logger.debug(e);
		} catch (Exception e) {
			logger.debug(e);
		}

	}

	@RequestMapping(value = { RequestMappingConstants.WEB_ANAL_CMMN_SHP_DN }, method = { RequestMethod.POST,
			RequestMethod.GET })
	public void resultDownload(HttpServletRequest request, HttpServletResponse response,
			@RequestParam(value = "result_id", required = true) String resultId)
			throws NullPointerException, Exception {

		FileInputStream fis = null;

		try {
			response.setContentType("application/octet-stream");
			response.setHeader("Content-Transfer-Encoding", "binary");
			response.setHeader("Content-Disposition", "attachment; filename=\"result\"");

			String zipPath = Util.makeResultZip(resultId);
			File zipFile = new File(zipPath);

			response.setContentLength((int) zipFile.length());

			fis = new FileInputStream(zipFile);
			byte[] b = new byte[4098];
			int read = -1;
			OutputStream outStream = response.getOutputStream();
			while ((read = fis.read(b)) != -1) {
				outStream.write(b, 0, read);
			}
			outStream.flush();

			// 2일전 결과 생성파일 지우기
			Util.cleanResult(resultId, 2);

		} catch (NullPointerException e) {
			logger.debug(e);
		} catch (Exception e) {
			logger.debug(e);
		} finally {

			if (fis != null) {
				try {
					fis.close();
				} catch (NullPointerException e) {
					logger.debug(e);
				} catch (Exception e) {
					logger.debug(e);
				}
			}
		}
	}
	// #endregion 분석

}
