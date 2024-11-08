package terra1.repositories;


import org.springframework.data.jpa.repository.JpaRepository;
import terra1.model.AppUser;

public interface AppUserRepository extends JpaRepository<AppUser, Long> {
}
