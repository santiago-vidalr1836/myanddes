package pe.compendio.myandess.onboarding.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import pe.compendio.myandess.onboarding.entity.ProcessActivityContentCard;

import java.util.List;

@Repository
public interface ProcessActivityContentCardRepository extends JpaRepository<ProcessActivityContentCard, Long> {
    List<ProcessActivityContentCard> findByCard_TypeAndAnswerIsNotNull(String type);

    List<ProcessActivityContentCard> findByCard_Type(String type);

    List<ProcessActivityContentCard> findByProcessActivityContent_ProcessActivity_Process_IdIn(List<Long> processIds);

    @Query("select count(card) from ProcessActivityContentCard card " +
            "where card.processActivityContent.processActivity.process.id = :processId " +
            "and (card.readDateMobile is not null or card.readDateServer is not null)")
    long countReadCardsByProcessId(@Param("processId") Long processId);

    @Query("select count(card) from ProcessActivityContentCard card " +
            "where card.processActivityContent.processActivity.process.id = :processId " +
            "and card.answer is not null and card.answer.correct = true")
    long countCorrectAnswersByProcessId(@Param("processId") Long processId);
}
