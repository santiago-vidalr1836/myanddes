package pe.compendio.myandess.onboarding.entity;

import jakarta.persistence.*;
import lombok.*;
import pe.compendio.myandess.onboarding.util.ListToStringConverter;

import java.time.LocalDate;
import java.util.List;

@Getter
@Setter
@Builder
@Entity
@Table(name = "user",schema = "public")
@NoArgsConstructor
@AllArgsConstructor
public class User {
    @Id
    @SequenceGenerator(name="user_id_seq",
                        sequenceName="user_id_seq",
                        allocationSize=1)
    @GeneratedValue(strategy = GenerationType.SEQUENCE,
                    generator = "user_id_seq")
    private Long id;

    @Column(nullable = false)
    private String fullname;

    @Column(unique = true,nullable = false)
    private String email;

    @Column
    private String job;

    @Column
    private LocalDate startDate;

    @Column
    private String image;

    @Column
    @Convert(converter = ListToStringConverter.class)
    private List<String> hobbies;

    @Column(name="roles")
    @Convert(converter = ListToStringConverter.class)
    private List<String> roles;

    @ManyToOne
    @JoinColumn(referencedColumnName = "id")
    private User boss;

    @Column(unique = true,nullable = false)
    private String dni;

    @Column
    private boolean deleted;

    @Column
    private boolean onItinerary;

    @Column
    private boolean finishedItinerary;

    @Column
    private String nickname;

    @Column
    private boolean admin;

    //@Column
    //private String processLoadGUID;//=java.util.UUID.randomUUID();
}
