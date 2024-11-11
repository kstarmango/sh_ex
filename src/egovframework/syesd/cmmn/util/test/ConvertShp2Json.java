package egovframework.syesd.cmmn.util.test;

import org.gdal.ogr.Geometry;

import egovframework.syesd.cmmn.util.ogr2ogr;
import egovframework.syesd.cmmn.util.ogrinfo;

public class ConvertShp2Json {

    public static void main(String[] args)
    {
    	String[] cmd0 = {"-s_srs", "EPSG:5174",
						 "-t_srs", "EPSG:4326",
						 "-f",     "GeoJSON",
						 		   "E:/2020년_프로젝트/001_SH서울주택도시공사/998_테스트/DGM_LICENS_v0.2_EPSG4326.json",
						           "E:/2020년_프로젝트/001_SH서울주택도시공사/998_테스트/DGM_LICENS_v0.2.shp",
						 "-lco",   "ENCODING=UTF-8"};

    	ogr2ogr.main(cmd0);

    	String[] cmd1 = {"-s_srs", "EPSG:5174",
				 		 "-t_srs", "EPSG:4326",
    					 "-f",     "ESRI Shapefile",
    					 		   "E:/2020년_프로젝트/001_SH서울주택도시공사/998_테스트/DGM_LICENS_v0.2_EPSG4326.shp",
    					 		   "E:/2020년_프로젝트/001_SH서울주택도시공사/998_테스트/DGM_LICENS_v0.2_EPSG4326.json",
						 "-lco",   "ENCODING=UTF-8"};

    	//ogr2ogr.main(cmd1);


    	//String[] cmd11 = {"E:/2020년_프로젝트/001_SH서울주택도시공사/998_테스트/DGM_LICENS_v0.2_EPSG4326.shp", "-sql", "alter table DGM_LICENS_v0.2_EPSG4326 rename column newX to newX_"};
    	String[] cmd12 = {"E:/2020년_프로젝트/001_SH서울주택도시공사/998_테스트/DGM_LICENS_v0.2_EPSG4326.shp", "-sql", "alter table DGM_LICENS_v0.2_EPSG4326 add column newX double"};
    	//String[] cmd13 = {"E:/2020년_프로젝트/001_SH서울주택도시공사/998_테스트/DGM_LICENS_v0.2_EPSG4326.shp", "-sql", "alter table DGM_LICENS_v0.2_EPSG4326 rename column newY to newY_"};
    	String[] cmd14 = {"E:/2020년_프로젝트/001_SH서울주택도시공사/998_테스트/DGM_LICENS_v0.2_EPSG4326.shp", "-sql", "alter table DGM_LICENS_v0.2_EPSG4326 add column newY double"};
    	//ogrinfo.main(cmd11);
    	ogrinfo.main(cmd12);
    	//ogrinfo.main(cmd13);
    	ogrinfo.main(cmd14);

    	//String[] cmd21 = {"E:/2020년_프로젝트/001_SH서울주택도시공사/998_테스트/TEST1.dbf", "-sql", "alter table TEST1 rename column newX to newX_"};
    	String[] cmd22 = {"E:/2020년_프로젝트/001_SH서울주택도시공사/998_테스트/TEST1.dbf", "-sql", "alter table TEST1 add column newX double"};
    	//String[] cmd23 = {"E:/2020년_프로젝트/001_SH서울주택도시공사/998_테스트/TEST1.dbf", "-sql", "alter table TEST1 rename column newY to newY_"};
    	String[] cmd24 = {"E:/2020년_프로젝트/001_SH서울주택도시공사/998_테스트/TEST1.dbf", "-sql", "alter table TEST1 add column newY double"};
    	//ogrinfo.main(cmd21);
    	ogrinfo.main(cmd22);
    	//ogrinfo.main(cmd23);
    	ogrinfo.main(cmd24);

    	/*
    	String wkt = "POINT(47.0 19.2)";
    	Geometry geom = Geometry.CreateFromWkt(wkt);
        int wkbSize = geom.WkbSize();
        byte[] wkb = geom.ExportToWkb();
        if (wkb.length != wkbSize)
        {
            System.exit(-1);
        }
        if (wkbSize > 0)
        {
            System.out.print( "wkt-->wkb: ");
            for(int i=0;i<wkbSize;i++)
            {
                if (i>0)
                    System.out.print("-");
                int val = wkb[i];
                if (val < 0)
                    val = 256 + val;
                String hexVal = Integer.toHexString(val);
                if (hexVal.length() == 1)
                    System.out.print("0");
                System.out.print(hexVal);
            }
            System.out.print("\n");

            // wkb --> wkt (reverse test)
            Geometry geom2 = Geometry.CreateFromWkb(wkb);
            String geom_wkt = geom2.ExportToWkt();
            System.out.println( "wkb->wkt: " + geom_wkt );
        }

        // wkt -- gml transformation
        String gml = geom.ExportToGML();
        System.out.println( "wkt->gml: " + gml );

        Geometry geom3 = Geometry.CreateFromGML(gml);
        String geom_wkt2 = geom3.ExportToWkt();
        System.out.println( "gml->wkt: " + geom_wkt2 );
        */

        /*
        wkt-->wkb: 00-00-00-00-01-40-47-80-00-00-00-00-00-40-33-33-33-33-33-33-33
        wkb->wkt: POINT (47.0 19.2)
        gml->wkt: POINT (47.0 19.2)
         */
    }
}
