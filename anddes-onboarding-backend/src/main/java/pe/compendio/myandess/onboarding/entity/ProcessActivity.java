package pe.compendio.myandess.onboarding.entity;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.time.LocalDate;
import java.time.LocalDateTime;

@Getter
@Setter
@NoArgsConstructor
@Entity
@Table(name = "process_activity")
public class ProcessActivity {
  @Id
  @SequenceGenerator(name="process_activity_id_seq",
    sequenceName="process_activity_id_seq",
    allocationSize=1)
  @GeneratedValue(strategy = GenerationType.SEQUENCE,
    generator = "process_activity_id_seq")
  private Long id;

  @ManyToOne
  @JoinColumn(referencedColumnName = "id")
  private Activity activity;

  @ManyToOne
  @JoinColumn(referencedColumnName = "id")
  private Process process;

  private boolean completed;
  private LocalDateTime completionDate;

  private Integer result;
}
