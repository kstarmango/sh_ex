package egovframework.zaol.util.service;

/**
 * 콤보박스를 위한 model객체
 * @author eh
 *
 */
public class DataList {
	
	private String strText;
	private String strValue;
	private String div1;
	
	public DataList() {
		strText = null;
		strValue = null;
		div1 = null;
	}

	public String getDiv1() {
		return div1;
	}

	public void setDiv1(String div1) {
		this.div1 = div1;
	}

	public String getStrText() {
		return strText;
	}

	public void setStrText(String strText) {
		this.strText = strText;
	}

	public String getStrValue() {
		return strValue;
	}

	public void setStrValue(String strValue) {
		this.strValue = strValue;
	}
	
}
