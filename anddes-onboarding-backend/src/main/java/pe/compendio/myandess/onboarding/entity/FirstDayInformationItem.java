package pe.compendio.myandess.onboarding.entity;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
@Entity
@Table(name = "first_day_information_item")
public class FirstDayInformationItem {
  @Id
  @SequenceGenerator(name="first_day_information_item_id_seq",
    sequenceName="first_day_information_item_id_seq",
    allocationSize=1)
  @GeneratedValue(strategy = GenerationType.SEQUENCE,
    generator = "first_day_information_item_id_seq")
  private Long id;

  private String title;
  private String description;
  private String body;
  private boolean addFromServices;
  private String type;
  private String icon;
}
