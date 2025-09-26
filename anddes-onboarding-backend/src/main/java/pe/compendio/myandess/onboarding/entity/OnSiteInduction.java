package pe.compendio.myandess.onboarding.entity;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
@Entity
@Table(name = "on_site_induction")
public class OnSiteInduction {
  @Id
  @SequenceGenerator(name="on_site_induction_id_seq",
    sequenceName="on_site_induction_id_seq",
    allocationSize=1)
  @GeneratedValue(strategy = GenerationType.SEQUENCE,
    generator = "on_site_induction_id_seq")
  private Long id;

  private String description;
}
