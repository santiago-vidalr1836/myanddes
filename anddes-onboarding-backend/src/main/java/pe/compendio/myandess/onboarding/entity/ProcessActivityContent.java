package pe.compendio.myandess.onboarding.entity;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.util.List;

@Getter
@Setter
@NoArgsConstructor
@Entity
@Table(name = "process_activity_content")
public class ProcessActivityContent {
  @Id
  @SequenceGenerator(name="process_activity_id_seq",
    sequenceName="process_activity_id_seq",
    allocationSize=1)
  @GeneratedValue(strategy = GenerationType.SEQUENCE,
    generator = "process_activity_id_seq")
  private Long id;

  @ManyToOne
  @JoinColumn(referencedColumnName = "id")
  private ELearningContent content;

  @ManyToOne
  @JoinColumn(referencedColumnName = "id")
  private ProcessActivity processActivity;

  private Integer result;
  private Integer progress;
  private String status;
  private Integer passingScore;

  @OneToMany(mappedBy = "processActivityContent", cascade = CascadeType.ALL)
  @OrderBy("id")
  private List<ProcessActivityContentCard> cards;
}
