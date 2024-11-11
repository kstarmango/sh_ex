package egovframework.syesd.cmmn.constants;

import egovframework.syesd.cmmn.util.EgovProperties;

public class Property {
	public static final String vworldKey 	= EgovProperties.getProperty("g.vworldKey");  //"A38B3266-0366-32E8-9A69-4D73B5947B5C";  //로컬 
	//public static final String vworldKey 	= "D8346912-366E-3927-B14D-768F1CF71346";  //운영
	public static final String geoserverDomain 	= EgovProperties.getProperty("g.geoserverURL"); 	//지오서버 도메인
	public static final String pinogeoUrl 		= EgovProperties.getProperty("g.pinogeoUrl"); 		//피노지오 도메인
	public static final String roadUrl 			= EgovProperties.getProperty("g.roadUrl"); 			//도로명주소 도메인
	public static final String vworldAddrUrl 	= EgovProperties.getProperty("g.vworldAddrUrl"); 	//브이월드 주소검색 도메인
	
	public static final String roadUrlKey		= EgovProperties.getProperty("g.roadUrlKey"); 		//도로명주소 api키
	
	//public static final String geoserverDomain 	= "localhost:38080/geoserver"; //지오서버 도메인
	public static final String wmsProxyUrl 	= "/getProxy.do";  //wms 프록시 매핑 uri
}
