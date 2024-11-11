package egovframework.mango.analysis.developer.web;

import java.awt.image.BufferedImage;
import java.io.ByteArrayOutputStream;
import java.io.PrintWriter;
import java.util.HashMap;
import java.util.Map;

import javax.annotation.PostConstruct;
import javax.imageio.ImageIO;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.geotools.coverage.grid.GridCoverage2D;
import org.geotools.process.spatialstatistics.enumeration.SlopeType;
import org.geotools.process.spatialstatistics.gridcoverage.RasterHelper;
import org.geotools.process.spatialstatistics.styler.SSStyleBuilder;
import org.geotools.styling.Style;
import org.locationtech.jts.geom.Geometry;
import org.locationtech.jts.geom.GeometryFactory;
import org.locationtech.jts.io.WKTReader;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import com.fasterxml.jackson.databind.DeserializationFeature;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.PropertyNamingStrategy;

import egovframework.mango.analysis.developer.service.AnalysisDeveloperService;
import egovframework.mango.util.SHImageHelper;
import egovframework.syesd.cmmn.constants.RequestMappingConstants;
import egovframework.zaol.common.web.BaseController;
import net.sf.json.JSONObject;

import egovframework.mango.config.SHResource;

@Controller
public class AnalysisDeveloperController extends BaseController {

	private static Logger logger = LogManager.getLogger(AnalysisDeveloperController.class);

	private ObjectMapper mapper;

	@Autowired
	private AnalysisDeveloperService analyDevService;

	@PostConstruct
	public void initIt() throws NullPointerException, Exception {
		mapper = new ObjectMapper();
		mapper.setPropertyNamingStrategy(PropertyNamingStrategy.SNAKE_CASE);
		mapper.configure(DeserializationFeature.FAIL_ON_UNKNOWN_PROPERTIES, false);
	}

	@RequestMapping(value = { RequestMappingConstants.WEB_ANAL_DEV_SLOPE }, method = { RequestMethod.GET })
	public void slope(HttpServletRequest request, HttpServletResponse response,
			@RequestParam(value = "inputFeature", required = false) String inputFeature,
			@RequestParam(value = "zFactor", required = false) Double zFactor,
			@RequestParam(value = "width", required = false) Integer width,
			@RequestParam(value = "height", required = false) Integer height, ModelMap model) throws NullPointerException, Exception {

		try {
			String exportId = getResultExportId();
			response.setHeader("export_key", exportId);

			GeometryFactory gf = new GeometryFactory();

			WKTReader reader = new WKTReader();
			Geometry geom = reader.read(inputFeature);
			SlopeType type = SlopeType.Degree;

			GridCoverage2D coverage = RasterHelper.openGeoTiffFile(SHResource.getValue("slope.file.path"));
			GridCoverage2D resultCoverage = analyDevService.rasterSlope(exportId, coverage, geom, type, zFactor);

			SSStyleBuilder styleBuilder = new SSStyleBuilder(null);
			Style style = styleBuilder.createRGBStyle(resultCoverage);
			style = SHImageHelper.getDefaultGridCoverageStyle(resultCoverage);

			resultCoverage.getEnvelope2D().getMinX();
			BufferedImage image = SHImageHelper.getImage(resultCoverage, null, null, style, width, height, "image/png",
					true, null);

			ByteArrayOutputStream baos = null;
			try {
				baos = new ByteArrayOutputStream();
				// write image
				ImageIO.write(image, "png", baos);
				byte[] imageBytes = baos.toByteArray();

				response.setContentType("image/png");
				response.setContentLength(imageBytes.length);

				String imgName = "dev_analy";
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

		} catch (NullPointerException e) {
			logger.debug(e);
		} catch (Exception e) {
			logger.debug(e);
		}

	}

	@RequestMapping(value = { RequestMappingConstants.WEB_ANAL_DEV_SLOPE_RESULT }, method = { RequestMethod.POST })
	public String slopeResult(HttpServletRequest request, HttpServletResponse response,
			@RequestParam(value = "inputFeature", required = false) String inputFeature,
			@RequestParam(value = "slopeType", required = false) SlopeType slopeType,
			@RequestParam(value = "zFactor", required = false) Double zFactor, ModelMap model) throws NullPointerException, Exception {

		try {
			String exportId = getResultExportId();
			response.setHeader("export_key", exportId);

			GeometryFactory gf = new GeometryFactory();

			WKTReader reader = new WKTReader();
			Geometry geom = reader.read(inputFeature);

			SlopeType type = SlopeType.Degree;

			GridCoverage2D coverage = RasterHelper.openGeoTiffFile(SHResource.getValue("slope.file.path"));

			Map<String, Object> result = analyDevService.rasterSlopeResult(exportId, coverage, geom, slopeType,
					zFactor);

			JSONObject obj = new JSONObject();
			obj.put("result", result);

			PrintWriter out = response.getWriter();
			out.println(obj.toString());
			model.addAttribute("resultData", obj);
		} catch (NullPointerException e) {
			logger.debug(e);
		} catch (Exception e) {
			logger.debug(e);
		}
		return "analysis/developer/popup/slopePopup.part";
	}

	// 개발행위 가능 분석
	@RequestMapping(value = { RequestMappingConstants.WEB_ANAL_DEV_AVAIL_RESULT + "_" }, method = { RequestMethod.GET,
			RequestMethod.POST })
	public void analysisDevelopment1(HttpServletRequest request, HttpServletResponse response,
			@RequestParam(value = "userArea", required = false) String userArea, ModelMap model) throws NullPointerException, Exception {

		try {
			String exportId = getResultExportId();
			response.setHeader("export_key", exportId);

			Map<String, Object> result = analyDevService.analysisDevelopment(exportId, userArea);
			response.setContentType("application/json; charset=UTF-8");
			response.setCharacterEncoding("UTF-8");
			JSONObject obj = new JSONObject();
			obj.put("result", result);

			PrintWriter out = response.getWriter();
			out.println(obj.toString());
		} catch (NullPointerException e) {
			logger.debug(e);
		} catch (Exception e) {
			logger.debug(e);
		}

	}

	// 개발행위 가능 분석
	@RequestMapping(value = { RequestMappingConstants.WEB_ANAL_DEV_AVAIL_RESULT }, method = { RequestMethod.GET,
			RequestMethod.POST })
	public String analysisDevelopment(HttpServletRequest request, HttpServletResponse response,
			@RequestParam(value = "userArea", required = false) String userArea, ModelMap model) throws NullPointerException, Exception {

		try {
			String exportId = getResultExportId();
			response.setHeader("export_key", exportId);

			Map<String, Object> result = new HashMap<>(); 
			if((userArea!= null)  && (userArea.length() > 0)) {
				result = analyDevService.analysisDevelopmentNew(exportId, userArea);
			} else {
				throw new NullPointerException("userArea가 Null 입니다.");
			}
			
			response.setContentType("application/json; charset=UTF-8");
			response.setCharacterEncoding("UTF-8");
			JSONObject obj = new JSONObject();
			obj.put("result", result);
			
			model.addAttribute("resultData", obj);

			PrintWriter out = response.getWriter();
			out.println(obj.toString());
		} catch (NullPointerException e) {
			logger.debug(e);
		} catch (Exception e) {
			logger.debug(e);
		}
		return "analysis/developer/popup/analysisDeveloperPopup.part";

	}
}
