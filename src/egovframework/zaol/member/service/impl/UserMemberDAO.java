package egovframework.zaol.member.service.impl;

import java.util.List;

import org.springframework.stereotype.Repository;

import egovframework.zaol.common.OracleDAO;
import egovframework.zaol.member.service.MemberVO;

@Repository("userMemberDAO")
public class UserMemberDAO extends OracleDAO {

	/**
	 * 사용자 로그인 정보를 조회한다.
	 * @param vo
	 * @return 조회 결과 VO
	 * @throws Exception
	 */
	public MemberVO duplicateCheck(MemberVO vo) throws Exception {
		return (MemberVO)selectByPk("userMemberDAO.selectUserInfoCnt", vo);
	}

	/**
	 * 사용자 상세정보 조회
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	public MemberVO selectUserDetail(MemberVO vo) throws Exception {
		return (MemberVO)selectByPk("userMemberDAO.selectUserDetailInfo", vo);
	}

	/**
	 * 사용자 전체정보 조회
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	public MemberVO selectUserFull(MemberVO vo) throws Exception {
		return (MemberVO)selectByPk("userMemberDAO.selectUserFullInfo", vo);
	}

	/**
	 * 사용자 기본정보 조회
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	public MemberVO selectUserMaster(MemberVO vo) throws Exception {
		return (MemberVO)selectByPk("userMemberDAO.selectUserMasterInfo", vo);
	}

	/**
	 * 사용자 기본정보 조회(쪽지용 사용자 검색)
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	public List selectMsgUserMaster(MemberVO vo) throws Exception {
		return list("userMemberDAO.selectMsgUserMaster", vo);
	}

	/**
	 * 회원 기본정보 생성
	 * @param vo
	 * @throws Exception
	 */
	public void createUserMaster(MemberVO vo) throws Exception {
		insert( "userMemberDAO.createUserMaster", vo );
	}

	/**
	 * 회원 상세정보생성
	 * @param vo
	 * @throws Exception
	 */
	public void createUserDetail(MemberVO vo) throws Exception {
		insert( "userMemberDAO.createUserDetail", vo );
	}

	/**
	 * 회원 기본정보 수정
	 * @param vo
	 * @throws Exception
	 */
	public int updateUserMaster(MemberVO vo) throws Exception {
		return update( "userMemberDAO.updateUserMaster", vo );
	}

	/**
	 * 회원 상세정보 수정
	 * @param vo
	 * @throws Exception
	 */
	public int updateUserDetail(MemberVO vo) throws Exception {
		return update( "userMemberDAO.updateUserDetail", vo );
	}

	/**
	 * 회원 계정 활성/비활성 처리
	 * @param vo
	 * @throws Exception
	 */
	public int updateWebUserActivation(MemberVO vo) throws Exception {
		return update( "userMemberDAO.updateWebUserActivation", vo );
	}


	/**
	 * 아이디 비밀번호 찾기
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	public MemberVO findUserIdPwd(MemberVO vo) throws Exception {
		return (MemberVO)selectByPk("userMemberDAO.findUserIdPwd", vo);
	}

	/**
	 * 회원 탈퇴 처리
	 * @param vo
	 * @throws Exception
	 */
	public void reqMemberOut(MemberVO vo) throws Exception {
		insert( "userMemberDAO.reqMemberOut", vo );
	}

}