# security26

Method-level security with `@PreAuthorize`, `@Secured`, `@RolesAllowed`.

Users: `user/user123` (USER), `manager/manager123` (USER, MANAGER), `admin/admin123` (all roles).

Run: `./mvnw spring-boot:run`, then `./requests.sh` (or `requests.http` in IntelliJ).
