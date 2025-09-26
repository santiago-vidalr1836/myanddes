package pe.compendio.myandess.onboarding.entity;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
@Entity
@Table(name = "remote_induction")
public class RemoteInduction {
  @Id
  @SequenceGenerator(name="remote_induction_id_seq",
    sequenceName="remote_induction_id_seq",
    allocationSize=1)
  @GeneratedValue(strategy = GenerationType.SEQUENCE,
    generator = "remote_induction_id_seq")
  private Long id;

  private String description;
}
