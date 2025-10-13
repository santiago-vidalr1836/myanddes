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

    public static final String ONBOARDING= "ONBOARDING";
    public static final String FIRST_DAY= "FIRST_DAY";
    public static final String ELEARNING_START= "ELEARNING_START";
    public static final String ELEARNING_INPROGRESS = "ELEARNING_INPROGRESS";
    public static final String ELEARNING_FINISH = "ELEARNING_FINISH";
    public static final String ELEARNING_REMIND = "ELEARNING_REMIND";
    public static final String BASE_TEMPLATE = "BASE_TEMPLATE";

    @Id
    private String id;
    private String name;
    private String subject;
    @Column(length = 2000)
    private String bodyTemplate;
    private String additionalMessage;
}
