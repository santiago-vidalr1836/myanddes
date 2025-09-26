package pe.compendio.myandess.onboarding.entity;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.time.LocalDateTime;

@Getter
@Setter
@NoArgsConstructor
@Entity
@Table(name = "process_activity_content_card")
public class ProcessActivityContentCard {
  @Id
  @SequenceGenerator(name="process_activity_content_card_id_seq",
    sequenceName="process_activity_content_card_id_seq",
    allocationSize=1)
  @GeneratedValue(strategy = GenerationType.SEQUENCE,
    generator = "process_activity_content_card_id_seq")
  private Long id;

  @ManyToOne
  @JoinColumn(referencedColumnName = "id")
  private ProcessActivityContent processActivityContent;

  @ManyToOne
  @JoinColumn(referencedColumnName = "id")
  private ELearningContentCard card;

  @ManyToOne
  @JoinColumn(referencedColumnName = "id",name = "option_id_selected")
  private ELearningContentCardOption answer;

  private LocalDateTime readDateMobile;
  private LocalDateTime readDateServer;
  private Integer points;
}
