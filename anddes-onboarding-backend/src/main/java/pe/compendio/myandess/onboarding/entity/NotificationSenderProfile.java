package pe.compendio.myandess.onboarding.entity;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
@Entity
@Table(name = "notification_sender_profile")
public class NotificationSenderProfile {
    @Id
    @SequenceGenerator(name = "notification_sender_profile_id_seq",
            sequenceName = "notification_sender_profile_id_seq",
            allocationSize = 1)
    @GeneratedValue(strategy = GenerationType.SEQUENCE,
            generator = "notification_sender_profile_id_seq")
    private Long id;
    private String fullname;
    private String position;
    private String address;
    private String urlPhoto;
    private Integer remindersNumber;
}
