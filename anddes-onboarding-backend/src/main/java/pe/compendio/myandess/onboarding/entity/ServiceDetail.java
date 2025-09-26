package pe.compendio.myandess.onboarding.entity;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
@Entity
@Table(name = "service_detail")
public class ServiceDetail {
  @Id
  @SequenceGenerator(name="service_detail_id_seq",
    sequenceName="service_detail_id_seq",
    allocationSize=1)
  @GeneratedValue(strategy = GenerationType.SEQUENCE,
    generator = "service_detail_id_seq")
  private Long id;

  private String description;

  private String title;

  @ManyToOne
  @JoinColumn(referencedColumnName = "id")
  private Service service;

  private boolean hidden;

  private String icon;
}
