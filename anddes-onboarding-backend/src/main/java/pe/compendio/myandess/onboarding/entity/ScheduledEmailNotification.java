package pe.compendio.myandess.onboarding.entity;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.util.Date;

@Getter
@Setter
@NoArgsConstructor
@Entity
@Table(name = "scheduled_email_notification")
public class ScheduledEmailNotification {
    @Id
    @SequenceGenerator(name="scheduled_email_notification_id_seq",
            sequenceName="scheduled_email_notification_id_seq",
            allocationSize=1)
    @GeneratedValue(strategy = GenerationType.SEQUENCE,
            generator = "scheduled_email_notification_id_seq")
    private Long id;
    @ManyToOne
    @JoinColumn(referencedColumnName = "id")
    private NotificationEmailTemplate notificationEmailTemplate;
    @ManyToOne
    @JoinColumn(referencedColumnName = "id")
    private User user;
    @Temporal(TemporalType.DATE)
    private Date scheduledDate;
    private Date dispatchDate;
    private String status; //PENDING, DISCARDED
    private Date createdAt;
}
