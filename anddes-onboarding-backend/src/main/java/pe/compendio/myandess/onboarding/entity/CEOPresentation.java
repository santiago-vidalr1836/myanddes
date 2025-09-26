package pe.compendio.myandess.onboarding.entity;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
@Entity
@Table(name = "ceo_presentation")
public class CEOPresentation {
  @Id
  @SequenceGenerator(name="ceo_presentation_id_seq",
    sequenceName="ceo_presentation_id_seq",
    allocationSize=1)
  @GeneratedValue(strategy = GenerationType.SEQUENCE,
    generator = "ceo_presentation_id_seq")
  private Long id;
  private String urlVideo;
  private String urlPoster;
}
