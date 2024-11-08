package terra1.dto.requests;

import lombok.Getter;
import lombok.Setter;

@Setter
@Getter
public class AppUserRequest {
    private String username;
    private String password;
    private String email;
}
