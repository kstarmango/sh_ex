package egovframework.mango.analysis.process;

import java.util.Map;

import org.geotools.data.simple.SimpleFeatureCollection;
import org.locationtech.jts.geom.Geometry;

/**
 * 개발행위 허가 분석 결과
 * 
 * @author MangoSystem
 */
public class DevPermitReport {
    // 분석 상태
    public Boolean status = false;

    // 개발행위 가능지역 면적
    public Double area = 0.0d;

    // 개발행위 가능지역 지오메트리
    public Geometry geometry = null;

    // 개발행위 가능지역 레이어
    public SimpleFeatureCollection permit = null;

    // 개발행위 가능지역 내 평균 표고
    public Double meanDem = 0.0d;

    // 개발행위 가능지역 내 평균 경사도
    public Double meanSlope = 0.0d;

    // 개발행위 가능지역 내 생태현황도  (비오톱 유형평가) 현황
    public Map<String, Double> biotopeTypesStat = null;

    // 개발행위 가능지역 내 생태현황도  (비오톱 유형평가)
    public SimpleFeatureCollection biotopeTypes = null;

    // 개발행위 가능지역 내 생태현황도  (개별비오톱평가) 현황
    public Map<String, Double> biotopeIndivisualsStat = null;

    // 개발행위 가능지역 내 생태현황도  (개별비오톱평가)
    public SimpleFeatureCollection biotopeIndivisuals = null;

    public DevPermitReport() {

    }

    public Boolean getStatus() {
        return status;
    }

    public void setStatus(Boolean status) {
        this.status = status;
    }

    public Double getArea() {
        return area;
    }

    public void setArea(Double area) {
        this.area = area;
    }

    public Geometry getGeometry() {
        return geometry;
    }

    public void setGeometry(Geometry geometry) {
        this.geometry = geometry;
    }

    public SimpleFeatureCollection getPermit() {
        return permit;
    }

    public void setPermit(SimpleFeatureCollection permit) {
        this.permit = permit;
    }

    public Double getMeanDem() {
        return meanDem;
    }

    public void setMeanDem(Double meanDem) {
        this.meanDem = meanDem;
    }

    public Double getMeanSlope() {
        return meanSlope;
    }

    public void setMeanSlope(Double meanSlope) {
        this.meanSlope = meanSlope;
    }

    public SimpleFeatureCollection getBiotopeTypes() {
        return biotopeTypes;
    }

    public void setBiotopeTypes(SimpleFeatureCollection biotopeTypes) {
        this.biotopeTypes = biotopeTypes;
    }

    public SimpleFeatureCollection getBiotopeIndivisuals() {
        return biotopeIndivisuals;
    }

    public void setBiotopeIndivisuals(SimpleFeatureCollection biotopeIndivisuals) {
        this.biotopeIndivisuals = biotopeIndivisuals;
    }

    public Map<String, Double> getBiotopeTypesStat() {
        return biotopeTypesStat;
    }

    public void setBiotopeTypesStat(Map<String, Double> biotopeTypesStat) {
        this.biotopeTypesStat = biotopeTypesStat;
    }

    public Map<String, Double> getBiotopeIndivisualsStat() {
        return biotopeIndivisualsStat;
    }

    public void setBiotopeIndivisualsStat(Map<String, Double> biotopeIndivisualsStat) {
        this.biotopeIndivisualsStat = biotopeIndivisualsStat;
    }

}
