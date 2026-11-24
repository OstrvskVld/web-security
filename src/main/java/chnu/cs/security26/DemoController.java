package chnu.cs.security26;

import jakarta.annotation.security.RolesAllowed;
import org.springframework.security.access.annotation.Secured;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.*;

import java.util.Map;

@RestController
@RequestMapping("/api")
public class DemoController {

    // 1. Open to everyone (permitAll in SecurityConfig)
    @GetMapping("/public")
    public Map<String, String> publicInfo() {
        return Map.of("message", "Public route, no login needed");
    }

    // 2. Any authenticated user
    @PreAuthorize("isAuthenticated()")
    @GetMapping("/me")
    public Map<String, Object> me(Authentication auth) {
        return Map.of("user", auth.getName(), "authorities", auth.getAuthorities().toString());
    }

    // 3. Role USER only
    @PreAuthorize("hasRole('USER')")
    @GetMapping("/user/profile")
    public Map<String, String> profile(Authentication auth) {
        return Map.of("profile", "Profile of " + auth.getName());
    }

    // 4. @Secured: ADMIN only
    @Secured("ROLE_ADMIN")
    @GetMapping("/admin/users")
    public Map<String, Object> allUsers() {
        return Map.of("users", new String[]{"admin", "user", "superadmin"});
    }

    // 5. @RolesAllowed (JSR-250): ADMIN only
    @RolesAllowed("ADMIN")
    @DeleteMapping("/admin/users/{id}")
    public Map<String, String> deleteUser(@PathVariable String id) {
        return Map.of("deleted", id);
    }

    // 6. SUPERADMIN only
    @PreAuthorize("hasRole('SUPERADMIN')")
    @GetMapping("/super/panel")
    public Map<String, String> superPanel() {
        return Map.of("panel", "Super admin panel");
    }

    // 7. SpEL: owner of the data or ADMIN
    @PreAuthorize("#username == authentication.name or hasRole('ADMIN')")
    @GetMapping("/users/{username}/data")
    public Map<String, String> userData(@PathVariable String username) {
        return Map.of("owner", username, "data", "Private data of " + username);
    }
}
