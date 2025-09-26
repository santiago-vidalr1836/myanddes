package pe.compendio.myandess.onboarding.entity;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import org.hibernate.annotations.SQLRestriction;

@Getter
@Setter
@NoArgsConstructor
@Entity
@Table(name = "elearning_content_card_option")
public class ELearningContentCardOption {
  @Id
  @SequenceGenerator(name="elearning_content_card_option_id_seq",
    sequenceName="elearning_content_card_option_id_seq",
    allocationSize=1)
  @GeneratedValue(strategy = GenerationType.SEQUENCE,
    generator = "elearning_content_card_option_id_seq")
  private Long id;
  private String description;
  private boolean correct;
  private boolean deleted;

  @ManyToOne
  @JoinColumn(referencedColumnName = "id",name = "elearning_content_card_id")
  private ELearningContentCard eLearningContentCard;
}
