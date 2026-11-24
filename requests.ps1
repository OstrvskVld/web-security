# Start the app first (.\mvnw.cmd spring-boot:run), then run: .\requests.ps1
$base = "http://localhost:8080"
$tests = @(
  @("-",                     "GET",    "/api/public",           200),
  @("-",                     "GET",    "/api/me",               401),
  @("user:user",             "GET",    "/api/user/profile",     200),
  @("user:user",             "GET",    "/api/admin/users",      403),
  @("admin:admin",           "GET",    "/api/admin/users",      200),
  @("admin:admin",           "DELETE", "/api/admin/users/1",    200),
  @("superadmin:superadmin", "GET",    "/api/super/panel",      200),
  @("user:user",             "GET",    "/api/super/panel",      403),
  @("user:user",             "GET",    "/api/users/user/data",  200),
  @("user:user",             "GET",    "/api/users/admin/data", 403)
)
$i = 0
foreach ($t in $tests) {
  $i++
  $a = @("-s", "-w", "|%{http_code}", "-X", $t[1])
  if ($t[0] -ne "-") { $a += @("-u", $t[0]) }
  $a += "$base$($t[2])"
  $out  = & curl.exe @a
  $body, $code = $out -split "\|(?=\d{3}$)"
  $who = if ($t[0] -eq "-") { "anonymous" } else { $t[0].Split(":")[0] }
  "#{0,-2} {1,-11} {2,-6} {3,-24} -> {4} (expected {5}) {6}" -f $i, $who, $t[1], $t[2], $code, $t[3], $body
}
