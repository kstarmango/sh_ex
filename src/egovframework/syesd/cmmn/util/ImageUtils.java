package egovframework.syesd.cmmn.util;

import java.awt.Graphics2D;
import java.awt.Image;
import java.awt.image.BufferedImage;
import java.io.ByteArrayInputStream;
import java.io.File;
import java.io.IOException;
import javax.imageio.ImageIO;
import javax.xml.bind.DatatypeConverter;

public class ImageUtils {

	public static boolean decode(String base64, File file) {
		String[] data = base64.split(",");
		String ext = data[0].split(";")[0].split("/")[1];
		byte[] imageBytes = DatatypeConverter.parseBase64Binary(data[1]);
		
		try 
		{
			ByteArrayInputStream bis = new ByteArrayInputStream(imageBytes);
			BufferedImage bufImg = ImageIO.read(bis);
			
			ImageIO.write(bufImg, ext, file);
		} 
		catch (IOException e) 
		{
			return false;
		}
		
		return true;
	}
	
	public static BufferedImage resize(BufferedImage img, int height, int width) {
        Image tmp = img.getScaledInstance(width, height, Image.SCALE_SMOOTH);
        
        BufferedImage resized = new BufferedImage(width, height, BufferedImage.TYPE_INT_ARGB);        
        
        Graphics2D g2d = resized.createGraphics();
        g2d.drawImage(tmp, 0, 0, null);
        g2d.dispose();
        
        return resized;
    }
	
}
