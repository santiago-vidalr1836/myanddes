package pe.compendio.myandess.onboarding.service;

import io.micrometer.common.util.StringUtils;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Service;
import pe.compendio.myandess.onboarding.entity.Constants;
import pe.compendio.myandess.onboarding.entity.User;
import pe.compendio.myandess.onboarding.repository.UserRepository;

import java.util.*;
import java.util.stream.Collectors;

@Service
@Slf4j
public class UserService {
  @Autowired
  UserRepository userRepository;
  public boolean existUserWithEmail(String email)
  {
    return userRepository
            .findByEmail(email)
            .isPresent();
  }
  public User findUserByEmail(String email){
    var optional=userRepository.findByEmail(email);
    return optional.orElse(null);
  }

  public void update(User user) {
    var optional=userRepository.findById(user.getId());
    if(optional.isPresent()){
      var userToModify=optional.get();
      userToModify.setFullname(user.getFullname());
      userToModify.setEmail(user.getEmail());
      userToModify.setJob(user.getJob());

      userToModify.setRoles(user.getRoles());
      userToModify.setImage(user.getImage());
      if(Objects.nonNull(user.getBoss()) &&
        Objects.nonNull(user.getBoss().getId())){
        var optionalBoss=userRepository.findById(user.getBoss().getId());
        userToModify.setBoss(optionalBoss.orElse(null));
      }
      userRepository.save(userToModify);
    }
  }
  public void updateFromLoad(User user) {
    var optional=userRepository.findById(user.getId());
    if(optional.isPresent()){
      var userToModify=optional.get();
      userToModify.setFullname(user.getFullname());
      userToModify.setEmail(user.getEmail());
      userToModify.setJob(user.getJob());

      if(Objects.nonNull(user.getBoss()) &&
        Objects.nonNull(user.getBoss().getId())){
        var optionalBoss=userRepository.findById(user.getBoss().getId());
        userToModify.setBoss(optionalBoss.orElse(null));
      }
      userRepository.save(userToModify);
    }
  }
  public List<User>[] load(List<User> users){
    List<User>[] array=new ArrayList[3];
    Optional<User> optional;
    List<User> newUsers=new ArrayList<>();
    List<User> modifiedUsers=new ArrayList<>();
    List<User> errorUser = new ArrayList<>();
    for (User user:users){
      try {
        optional = userRepository.findByDni(user.getDni());
        if (Objects.nonNull(user.getBoss()) &&
          StringUtils.isNotEmpty(user.getBoss().getFullname())) {
          var optionalBoss = userRepository.findByFullnameIgnoreCase(user.getBoss().getFullname());
          user.setBoss(optionalBoss.orElse(null));
        }
        if (optional.isPresent()) {
          user.setId(optional.get().getId());
          updateFromLoad(user);
          modifiedUsers.add(user);
        } else {
          user.setRoles(Collections.singletonList(Constants.ROLE_COLABORADOR));
          user = userRepository.save(user);
          newUsers.add(user);
        }
      }catch (Exception e){
        log.error("Error al cargar usuario "+user.getFullname(),e);
        errorUser.add(user);
      }
    }
    array[0]=newUsers;
    array[1]=modifiedUsers;
    array[2]=errorUser;
    return array;
  }

  public Page<User> findByFilter(String filter,Integer page,Integer pageSize,String orderBy,String direction) {
    PageRequest pageRequest= PageRequest.of(page,pageSize, Sort.Direction.fromString(direction),orderBy);
    return userRepository.findByFullnameContainsIgnoreCaseAndDeletedFalse(filter,pageRequest);
  }

  public void delete(Long userId) {
    var optional=userRepository.findById(userId);
    if(optional.isPresent()){
      var userToDelete = optional.get();
      userToDelete.setDeleted(false);
      userRepository.save(userToDelete);
    }
  }
  public Page<User> findByOnItineraryAndFilter(boolean onItinerary, String filter, Integer page, Integer pageSize, String orderBy, String direction) {
    PageRequest pageRequest= PageRequest.of(page,pageSize, Sort.Direction.fromString(direction),orderBy);
    return userRepository.findByFullnameContainsIgnoreCaseAndOnItineraryAndDeletedFalse(filter,onItinerary,pageRequest);
  }

  public List<User> findTeam_ByUserId(Long userId) {
    var team = new ArrayList<User>();
    var optional = userRepository.findById(userId);
    if(optional.isPresent()){
      var user = optional.get();
      if(Objects.nonNull(user.getBoss())){
        team.add(user.getBoss());
        team.addAll(userRepository
                                  .findByBoss_Id(user.getBoss().getId())
                                  .stream()
                                  .filter(u->!u.getId().equals(user.getId()))
                                  .collect(Collectors.toSet())
                  );
      }
    }
    return team;
  }

  public void updateProfile(User user) {
    var optional = userRepository.findById(user.getId());
    if(optional.isPresent()){
      var userToUpdate = optional.get();
      userToUpdate.setHobbies(user.getHobbies());
      userToUpdate.setNickname(user.getNickname());
      userToUpdate.setImage(user.getImage());
      userRepository.save(userToUpdate);
    }
  }
}
