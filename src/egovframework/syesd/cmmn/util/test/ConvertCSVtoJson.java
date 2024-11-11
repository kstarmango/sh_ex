package egovframework.syesd.cmmn.util.test;

import java.io.File;
import java.io.IOException;
import java.util.List;
import java.util.Map;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.SerializationFeature;
import com.fasterxml.jackson.dataformat.csv.CsvMapper;
import com.fasterxml.jackson.dataformat.csv.CsvSchema;

import egovframework.syesd.cmmn.util.ogrinfo;

public class ConvertCSVtoJson {

	@SuppressWarnings("unchecked")
	public static void main(String[] args) throws IOException {

		/* 방법 1 */
		String[] cmd1 = {"E:\\2020년_프로젝트\\001_SH서울주택도시공사\\000_설계\\sh_landsys_csv2json_data.csv", "-sql", "alter table sh_landsys_csv2json_data rename column newX to newX_"};
    	String[] cmd2 = {"E:\\2020년_프로젝트\\001_SH서울주택도시공사\\000_설계\\sh_landsys_csv2json_data.csv", "-sql", "alter table sh_landsys_csv2json_data add column newX double"};
    	String[] cmd3 = {"E:\\2020년_프로젝트\\001_SH서울주택도시공사\\000_설계\\sh_landsys_csv2json_data.csv", "-sql", "alter table sh_landsys_csv2json_data rename column newY to newY_"};
    	String[] cmd4 = {"E:\\2020년_프로젝트\\001_SH서울주택도시공사\\000_설계\\sh_landsys_csv2json_data.csv", "-sql", "alter table sh_landsys_csv2json_data add column newY double"};
    	ogrinfo.main(cmd1);
    	ogrinfo.main(cmd2);
    	ogrinfo.main(cmd3);
    	ogrinfo.main(cmd4);

		File input = new File("E:\\2020년_프로젝트\\001_SH서울주택도시공사\\000_설계\\sh_landsys_csv2json_data.csv");

		/* 방법 2 - x */
		CsvSchema csvSchema = CsvSchema.builder()
				//.addColumn("x", CsvSchema.ColumnType.NUMBER)
				//.addColumn("y", CsvSchema.ColumnType.NUMBER)
				.setUseHeader(true).build();
		CsvMapper csvMapper = new CsvMapper();

		// Read data from CSV file
		List<Object> readAll = csvMapper.readerFor(Map.class).with(csvSchema).readValues(input).readAll();

		ObjectMapper mapper = new ObjectMapper();

		mapper.enable(SerializationFeature.INDENT_OUTPUT);

		// Write JSON formated data to output.json file
		for (Object row : readAll) {

			Map<String, String> map = (Map<String, String>) row;

			/* 방법 3 - x */
			//map.put("x", "");
			//map.put("y", "");

			String fileName = map.get("fileName");

			File output = new File("E:\\2020년_프로젝트\\001_SH서울주택도시공사\\000_설계\\"+fileName+".json");

			mapper.writerWithDefaultPrettyPrinter().writeValue(output, map);
		}
    }
}