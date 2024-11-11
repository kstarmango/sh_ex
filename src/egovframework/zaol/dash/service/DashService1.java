package egovframework.zaol.dash.service;

import java.util.List;

import org.springframework.transaction.annotation.Transactional;

import egovframework.zaol.home.service.HomeVO;

public interface DashService1 {

    
    public List   dashBoard_List(DashVO vo) throws Exception; //시군구 중심 좌표
    
    public List   dashBoard_data1(DashVO vo) throws Exception; //통계자료1
    public List   dashBoard_data2(DashVO vo) throws Exception; //통계자료2
    public List   dashBoard_data3(DashVO vo) throws Exception; //통계자료3
    public List   dashBoard_data4(DashVO vo) throws Exception; //통계자료4
}
