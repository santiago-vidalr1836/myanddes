package pe.compendio.myandess.onboarding.entity;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
@Entity
@Table(name = "notification_email_template")
public class NotificationEmailTemplate {
    @Id
    @SequenceGenerator(name = "notification_email_template_id_seq",
            sequenceName = "notification_email_template_id_seq",
            allocationSize = 1)
    @GeneratedValue(strategy = GenerationType.SEQUENCE,
            generator = "notification_email_template_id_seq")
    private Long id;
    private String name;
    private String subject;
    private String bodyTemplate;
    private String additionalMessage;
    private String purpose;
}
