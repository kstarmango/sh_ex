package egovframework.zaol.common.service.impl;

import java.util.List;

import org.springframework.stereotype.Repository;

import egovframework.zaol.common.OracleDAO;
import egovframework.zaol.common.service.ZipCodeVO;
 
@Repository( "zipCodeDAO" )
public class ZipCodeDAO extends OracleDAO {
	@SuppressWarnings("unchecked")
	public List< ZipCodeVO > selectZipCode( String name ) {
		return list( "eduWorkDAO.selectZipCode", name );
	}

	public int selectZipCodeCnt( String name ) {
		return ( Integer )selectByPk( "eduWorkDAO.selectZipCodeCnt", name );
	}

	@SuppressWarnings("unchecked")
	public List< ZipCodeVO > selectArea( String dong ) {
		return list( "board.selectAddr", dong );
	}
}
