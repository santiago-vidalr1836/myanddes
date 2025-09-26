package pe.compendio.myandess.onboarding.repository;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import pe.compendio.myandess.onboarding.entity.User;

import java.util.List;
import java.util.Optional;

@Repository
public interface UserRepository extends JpaRepository<User,Long> {
    Optional<User> findByEmail(String email);
    Optional<User> findByDni(String dni);
    Optional<User> findByFullnameIgnoreCase(String fullname);
    Page<User> findByFullnameContainsIgnoreCaseAndDeletedFalse(String filter, Pageable pageable);
    Long countByBoss_Id(Long bossId);

    Page<User> findByFullnameContainsIgnoreCaseAndOnItineraryAndDeletedFalse(String filter,boolean onItinerary, PageRequest pageRequest);
    List<User> findByBoss_Id(Long id);
}
