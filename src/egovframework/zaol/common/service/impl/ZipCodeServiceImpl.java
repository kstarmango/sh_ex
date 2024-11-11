package egovframework.zaol.common.service.impl;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;
 
import egovframework.zaol.common.service.ZipCodeService;
import egovframework.zaol.common.service.ZipCodeVO;

@Service( "zipCodeService" )
public class ZipCodeServiceImpl implements ZipCodeService {

	@Resource( name="zipCodeDAO" )
	private ZipCodeDAO zipCodeDAO;
	
	public List< ZipCodeVO > selectZipCode( String name ) throws Exception {
		/*List< ZipCodeVO > list = ( List< ZipCodeVO > ) zipCodeDAO.selectZipCode( name );
		HashMap< String, String > map = new HashMap< String, String >();
		
		if( list != null ) {
			for( int i=0; i<list.size(); i++ ) {
				ZipCodeVO obj = list.get(i);
				if( obj.getZipcode().length() == 7 ) {
					map.put( "zipcode1" , obj.getZipcode().substring( 0, 3 ) );
					map.put( "zipcode2" , obj.getZipcode().substring( 3, 6 ) );
				} else {
					map.put( "zipcode1" , obj.getZipcode() );
					map.put( "zipcode2" , "" );
				}
				
				map.put( "address", obj.getSido() +" "+ obj.getGugun() +" "+ obj.getDong() +" "+ obj.getBunji() );
				map.put( "sido", obj.getSido() );
				map.put( "gugun", obj.getGugun() );
				map.put( "dong", obj.getDong() );
				map.put( "bunji", obj.getBunji() );
			}
		}
		
		return map;*/
		
		List< ZipCodeVO > list = ( List< ZipCodeVO > ) zipCodeDAO.selectZipCode( name );
		List< ZipCodeVO > result = new ArrayList< ZipCodeVO >();
		
		if( list != null ) {
			for( int i=0; i<list.size(); i++ ) {
				ZipCodeVO obj = list.get(i);
				if( obj.getZipcode().length() == 7 ) {
					obj.setZipcode1( obj.getZipcode().substring( 0, 3 ) );
					obj.setZipcode2( obj.getZipcode().substring( 4, 7 ) );
				} else {
					obj.setZipcode1( obj.getZipcode() );
					obj.setZipcode2( "" );
				}
				
				if( obj.getBunji() == null ) {
					obj.setAddress( obj.getSido() +" "+ obj.getGugun() +" "+ obj.getDong()+" " );
				} else {
					obj.setAddress( obj.getSido() +" "+ obj.getGugun() +" "+ obj.getDong() +" "+ obj.getBunji()+" " );
				}
				
				obj.setSido( obj.getSido() );
				obj.setGugun( obj.getGugun() );
				obj.setDong( obj.getDong() );
				obj.setBunji( obj.getBunji() );
				
				result.add( obj );
			}
		}
		
		return result;
	}
	
	public int selectZipCodeCnt( String name ) throws Exception {
		return zipCodeDAO.selectZipCodeCnt( name );
	}

	
	public List<ZipCodeVO> selectArea(String dong) throws Exception {
		// TODO Auto-generated method stub
		return zipCodeDAO.selectArea(dong);
	}
}
