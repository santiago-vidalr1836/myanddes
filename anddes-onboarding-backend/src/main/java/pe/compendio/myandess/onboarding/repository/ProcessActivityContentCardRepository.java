package pe.compendio.myandess.onboarding.repository;

import org.springframework.data.repository.CrudRepository;
import org.springframework.stereotype.Repository;
import pe.compendio.myandess.onboarding.entity.ProcessActivityContentCard;

import java.util.List;

@Repository
public interface ProcessActivityContentCardRepository extends CrudRepository<ProcessActivityContentCard,Long> {
  List<ProcessActivityContentCard> findByCard_TypeAndAnswerIsNotNull(String type);
  List<ProcessActivityContentCard> findByCard_Type(String type);
}
