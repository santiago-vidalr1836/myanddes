package pe.compendio.myandess.onboarding.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.repository.CrudRepository;
import org.springframework.stereotype.Repository;
import pe.compendio.myandess.onboarding.entity.Process;

import java.time.LocalDate;
import java.time.LocalDateTime;
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
}
