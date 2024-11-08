package terra1.services;

import lombok.AllArgsConstructor;
import org.modelmapper.ModelMapper;
import org.springframework.stereotype.Service;
import terra1.dto.requests.AppUserRequest;
import terra1.dto.responses.AppUserResponse;
import terra1.model.AppUser;
import terra1.repositories.AppUserRepository;

@Service
@AllArgsConstructor
public class AppUserServiceImpl implements AppUserService{


    private final ModelMapper mapper;
    private  final AppUserRepository appUserRepository;
    @Override
    public AppUserResponse register(AppUserRequest appUserRequest) {
        AppUser appUser = mapper.map(appUserRequest, AppUser.class);
        appUserRepository.save(appUser);
        AppUserResponse response = mapper.map(appUser, AppUserResponse.class);
        response.setMessage("Successful");
        return response;

    }
}
