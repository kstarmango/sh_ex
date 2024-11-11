package egovframework.zaol.util.service;

import java.util.Calendar;

import org.springframework.stereotype.Component;


@Component("dateUtil")
public class DateUtil {

	public int year(){
		Calendar aCalendar = Calendar.getInstance();
		return  aCalendar.get(Calendar.YEAR);
	}

	public int month(){
		Calendar aCalendar = Calendar.getInstance();
		return  aCalendar.get(Calendar.MONTH)+1;
	}

	public int day(){
		Calendar aCalendar = Calendar.getInstance();
		return  aCalendar.get(Calendar.DAY_OF_MONTH);
	}

	public String zeromonth(){
		String month = Integer.toString(month());

		if (month.length() == 1)
			month = "0" + month;

		return month;
	}

	public String zeromonthPlus(int value){
		String month = Integer.toString(month()+value);

		if (month.length() == 1)
			month = "0" + month;

		return month;
	}
	
	public String zeroday(){
		String day = Integer.toString(day());

		if (day.length() == 1)
			day = "0" + day;

		return day;
	}

}
