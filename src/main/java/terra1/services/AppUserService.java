package terra1.services;


import terra1.dto.requests.AppUserRequest;
import terra1.dto.responses.AppUserResponse;

public interface AppUserService {

    AppUserResponse register(AppUserRequest appUserRequest);
}
