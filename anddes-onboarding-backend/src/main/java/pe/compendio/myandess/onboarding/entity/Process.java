package pe.compendio.myandess.onboarding.entity;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import pe.compendio.myandess.onboarding.util.ListToStringConverter;

import java.time.LocalDate;
import java.util.List;

@Getter
@Setter
@NoArgsConstructor
@Entity
@Table(name = "process")
public class Process {
  @Id
  @SequenceGenerator(name="process_id_seq",
    sequenceName="process_id_seq",
    allocationSize=1)
  @GeneratedValue(strategy = GenerationType.SEQUENCE,
    generator = "process_id_seq")
  private Long id;

  @ManyToOne
  @JoinColumn(referencedColumnName = "id")
  private User user;

  private LocalDate startDate;

  private Integer status;

  @Column(name="results")
  @Convert(converter = ListToStringConverter.class)
  private List<String> results;

  private boolean finished;
  private boolean delayed;
  private boolean welcomed;
  private String hourOnsite;
  private String placeOnsite;
  private String hourRemote;
  private String linkRemote;

}
