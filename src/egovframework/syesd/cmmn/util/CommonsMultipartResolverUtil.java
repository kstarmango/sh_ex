package egovframework.syesd.cmmn.util;

import java.io.UnsupportedEncodingException;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import org.apache.commons.fileupload.FileItem;
import org.springframework.util.StringUtils;
import org.springframework.web.multipart.commons.CommonsMultipartFile;
import org.springframework.web.multipart.commons.CommonsMultipartResolver;

public class CommonsMultipartResolverUtil extends CommonsMultipartResolver {
	@Override
	@SuppressWarnings({ "rawtypes", "unchecked" })
	protected MultipartParsingResult parseFileItems(List fileItems, String encoding) {

		int index = 1;
		Map multipartFiles = new HashMap();
		Map multipartParameters = new HashMap();
		if (logger.isDebugEnabled()) {
			logger.debug(" parseFileItems - fileItems size [" + fileItems.size() + "] , encoding [" + encoding + "]");

		}

		// Extract multipart files and multipart parameters.
		for (Iterator it = fileItems.iterator(); it.hasNext();) {
			FileItem fileItem = (FileItem) it.next();
			if (fileItem.isFormField()) {
				String value = null;
				if (encoding != null) {
					try {
						value = fileItem.getString(encoding);
					} catch (UnsupportedEncodingException ex) {
						if (logger.isWarnEnabled()) {
							logger.warn("Could not decode multipart item '" + fileItem.getFieldName() + "' with encoding '" + encoding
									+ "': using platform default");
						}
						value = fileItem.getString();
					}
				} else {
					value = fileItem.getString();
				}

				String[] curParam = (String[]) multipartParameters.get(fileItem.getFieldName());
				if (curParam == null) {
					// simple form field
					multipartParameters.put(fileItem.getFieldName(), new String[] { value });
				} else {
					// array of simple form fields
					String[] newParam = StringUtils.addStringToArray(curParam, value);
					multipartParameters.put(fileItem.getFieldName(), newParam);
				}

				if (logger.isDebugEnabled()) {
					logger.debug("fileItem.getContentType() [" + fileItem.getContentType() + "] , fileItem.getString() [" + fileItem.getString()
							+ "] , fileItem.getFieldName() [" + fileItem.getFieldName() + "]");
				}
			} else {
				CommonsMultipartFile file = new CommonsMultipartFile(fileItem);

				if (multipartFiles.containsKey(file.getName())) {
					multipartFiles.put(index + "dupl_" + file.getName(), file);
					index++;
				} else {
					multipartFiles.put(file.getName(), file);
				}

				if (logger.isDebugEnabled()) {
					logger.debug("Found multipart file [" + file.getName() + "] of size " + file.getSize() + " bytes with original filename ["
							+ file.getOriginalFilename() + "], stored " + file.getStorageDescription());
				}
			}
		}// for

		if (logger.isDebugEnabled()) {
			logger.debug(" multipartFiles.toString() [" + multipartFiles.toString() + "] , multipartFiles.size [" + multipartFiles.size()
					+ "] , multipartParameters.size [" + multipartParameters.size() + "]");
		}

		return new MultipartParsingResult(multipartFiles, multipartParameters);
	}
}
