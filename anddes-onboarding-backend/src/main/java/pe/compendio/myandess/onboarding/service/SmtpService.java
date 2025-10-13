package pe.compendio.myandess.onboarding.service;

import jakarta.mail.MessagingException;
import jakarta.mail.internet.MimeMessage;
import lombok.extern.slf4j.Slf4j;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.stereotype.Service;

@Service
@Slf4j
public class SmtpService {

    private final JavaMailSender javaMailSender;

    public SmtpService(JavaMailSender javaMailSender) {
        this.javaMailSender = javaMailSender;
    }

    public boolean send(String to, String subject, String body) {
        try {
            MimeMessage message = javaMailSender.createMimeMessage();
            MimeMessageHelper helper = new MimeMessageHelper(message, true, "UTF-8"); // true for multipart, UTF-8 encoding

            helper.setFrom("notificaciones.anddes@anddes.com");
            helper.setTo(to);
            helper.setSubject(subject);
            helper.setText(body, true);

            javaMailSender.send(message);
        } catch (MessagingException e) {
            log.error(e.getMessage());
            return false;
        }

        return true;
    }

}
