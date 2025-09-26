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
@Table(name = "elearning_content")
public class ELearningContent {
  @Id
  @SequenceGenerator(name="elearning_content_id_seq",
    sequenceName="elearning_content_id_seq",
    allocationSize=1)
  @GeneratedValue(strategy = GenerationType.SEQUENCE,
    generator = "elearning_content_id_seq")
  private Long id;

  private String name;

  private String image;

  @OneToMany(mappedBy = "eLearningContent", cascade = CascadeType.ALL)
  @SQLRestriction("deleted = false")
  @OrderBy("position")
  private List<ELearningContentCard> cards;

  private Integer position;
}
