package pe.compendio.myandess.onboarding.entity;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
@Entity
@Table(name = "activity")
public class Activity {
  @Id
  @SequenceGenerator(name="activity_id_seq",
    sequenceName="activity_id_seq",
    allocationSize=1)
  @GeneratedValue(strategy = GenerationType.SEQUENCE,
    generator = "activity_id_seq")
  private Long id;
  private String code;
  private String name;
  private String parent;
  private String parentCode;
  private boolean editableInWeb;
  private boolean mandatory;
  private boolean manual;
}
