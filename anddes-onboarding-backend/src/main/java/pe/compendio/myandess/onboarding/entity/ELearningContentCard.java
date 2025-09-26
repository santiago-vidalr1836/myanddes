package pe.compendio.myandess.onboarding.entity;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import org.hibernate.annotations.SQLRestriction;

import java.util.List;

@Getter
@Setter
@NoArgsConstructor
@Entity
@Table(name = "elearning_content_card")
public class ELearningContentCard {
  @Id
  @SequenceGenerator(name="elearning_content_card_id_seq",
    sequenceName="elearning_content_card_id_seq",
    allocationSize=1)
  @GeneratedValue(strategy = GenerationType.SEQUENCE,
    generator = "elearning_content_card_id_seq")
  private Long id;

  private String title;

  private String type;

  private boolean draft;

  private String content;

  private boolean deleted;

  private Integer position;

  @ManyToOne
  @JoinColumn(referencedColumnName = "id",name = "elearning_content_id")
  private ELearningContent eLearningContent;

  @OneToMany(mappedBy = "eLearningContentCard", cascade = CascadeType.ALL)
  @SQLRestriction("deleted = false")
  private List<ELearningContentCardOption> options;

  private String urlVideo;
  private String urlPoster;
}
