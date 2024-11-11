package egovframework.zaol.mbersbscrb.service;

import java.util.List;
import egovframework.zaol.mbersbscrb.service.MbersbscrbVO;

public interface MbersbscrbService {

	public MbersbscrbVO userIdDplctAjax01     (MbersbscrbVO mbersbscrbVO) throws Exception;
	public void         userInfoInsert        (MbersbscrbVO mbersbscrbVO) throws Exception;
	public List         selectUserIdList      (MbersbscrbVO mbersbscrbVO) throws Exception;
	public void         selectLoginOutHist    (MbersbscrbVO mbersbscrbVO) throws Exception;
	
}