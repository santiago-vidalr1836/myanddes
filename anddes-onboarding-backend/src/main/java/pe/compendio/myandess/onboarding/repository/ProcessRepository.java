package pe.compendio.myandess.onboarding.repository;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import pe.compendio.myandess.onboarding.entity.Process;

import java.time.LocalDate;
import java.util.List;
import java.util.Optional;

@Repository
public interface ProcessRepository extends JpaRepository<Process,Long> {

  int countByStartDateBetween(LocalDate startDate, LocalDate endDate);
  int countByStartDateBetweenAndFinishedIsTrue(LocalDate startDate, LocalDate endDate);
  int countByStartDateBetweenAndFinishedIsFalseAndDelayedIsTrue(LocalDate startDate, LocalDate endDate);

  List<Process> findByStartDateBeforeAndFinishedIsFalseAndDelayedIsFalse(LocalDate date);

  List<Process> findByFinishedIsTrue();

  List<Process> findByFinishedIsTrueOrderByIdDesc();
  List<Process> findByOrderByIdDesc();
  Optional<Process> findByUser_Id(Long idUser);

  @Query("""
      SELECT p FROM Process p
      WHERE p.startDate BETWEEN :startDate AND :endDate
        AND LOWER(p.user.fullname) LIKE CONCAT('%', LOWER(:fullname), '%')
      """)
  Page<Process> findAllByStartDateBetweenAndUser_FullnameContainingIgnoreCase(@Param("startDate") LocalDate startDate,
                                                                              @Param("endDate") LocalDate endDate,
                                                                              @Param("fullname") String fullname,
                                                                              Pageable pageable);

  @Query("""
      SELECT p FROM Process p
      WHERE p.startDate BETWEEN :startDate AND :endDate
        AND p.finished = TRUE
        AND LOWER(p.user.fullname) LIKE CONCAT('%', LOWER(:fullname), '%')
      """)
  Page<Process> findAllByStartDateBetweenAndFinishedIsTrueAndUser_FullnameContainingIgnoreCase(@Param("startDate") LocalDate startDate,
                                                                                                @Param("endDate") LocalDate endDate,
                                                                                                @Param("fullname") String fullname,
                                                                                                Pageable pageable);

  @Query("""
      SELECT p FROM Process p
      WHERE p.startDate BETWEEN :startDate AND :endDate
        AND p.finished = FALSE
        AND LOWER(p.user.fullname) LIKE CONCAT('%', LOWER(:fullname), '%')
      """)
  Page<Process> findAllByStartDateBetweenAndFinishedIsFalseAndUser_FullnameContainingIgnoreCase(@Param("startDate") LocalDate startDate,
                                                                                                @Param("endDate") LocalDate endDate,
                                                                                                @Param("fullname") String fullname,
                                                                                                Pageable pageable);

  @Query("""
      SELECT p FROM Process p
      WHERE p.startDate BETWEEN :startDate AND :endDate
        AND p.delayed = TRUE
        AND LOWER(p.user.fullname) LIKE CONCAT('%', LOWER(:fullname), '%')
      """)
  Page<Process> findAllByStartDateBetweenAndDelayedIsTrueAndUser_FullnameContainingIgnoreCase(@Param("startDate") LocalDate startDate,
                                                                                               @Param("endDate") LocalDate endDate,
                                                                                               @Param("fullname") String fullname,
                                                                                               Pageable pageable);
}
