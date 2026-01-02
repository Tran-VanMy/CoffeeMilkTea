package Controller;

import javax.imageio.ImageIO;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.awt.*;
import java.awt.image.BufferedImage;
import java.io.IOException;
import java.util.Random;

@WebServlet("/captcha")
public class CaptchaServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
	
    private static final int WIDTH = 150;
    private static final int HEIGHT = 50;

    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        resp.setHeader("Cache-Control", "no-store");
        resp.setContentType("image/png");

        String chars = "ABCDEFGHJKLMNPQRSTUVWXYZ23456789";
        Random rand = new Random();
        StringBuilder sb = new StringBuilder();
        for (int i = 0; i < 6; i++) sb.append(chars.charAt(rand.nextInt(chars.length())));
        String captcha = sb.toString();

        HttpSession session = req.getSession();
        session.setAttribute("CAPTCHA", captcha);

        BufferedImage img = new BufferedImage(WIDTH, HEIGHT, BufferedImage.TYPE_INT_RGB);
        Graphics2D g = img.createGraphics();
        g.setColor(Color.WHITE);
        g.fillRect(0, 0, WIDTH, HEIGHT);

        for (int i = 0; i < 40; i++) {
            int x1 = rand.nextInt(WIDTH), y1 = rand.nextInt(HEIGHT);
            int x2 = rand.nextInt(WIDTH), y2 = rand.nextInt(HEIGHT);
            g.setColor(new Color(rand.nextInt(150), rand.nextInt(150), rand.nextInt(150)));
            g.drawLine(x1, y1, x2, y2);
        }

        g.setFont(new Font("Arial", Font.BOLD, 28));
        for (int i = 0; i < captcha.length(); i++) {
            g.setColor(new Color(rand.nextInt(120), rand.nextInt(120), rand.nextInt(120)));
            int x = 15 + i * 20 + rand.nextInt(8);
            int y = 30 + rand.nextInt(10);
            g.drawString(String.valueOf(captcha.charAt(i)), x, y);
        }

        g.dispose();
        ImageIO.write(img, "png", resp.getOutputStream());
    }
}