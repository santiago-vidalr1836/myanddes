package pe.compendio.myandess.onboarding.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.repository.CrudRepository;
import org.springframework.stereotype.Repository;
import pe.compendio.myandess.onboarding.entity.FirstDayInformationItem;

@Repository
public interface FirstDayInformationItemRepository extends JpaRepository<FirstDayInformationItem,Long> {
}
