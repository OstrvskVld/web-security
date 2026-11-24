#!/usr/bin/env bash
# 10 requests as different users. Start the app first: ./mvnw spring-boot:run
BASE=http://localhost:8080
n=0
req() {  # req "<creds or ->" METHOD PATH EXPECTED
  n=$((n+1))
  local creds=$1 method=$2 path=$3 expected=$4
  local auth=()
  [ "$creds" != "-" ] && auth=(-u "$creds")
  local code
  code=$(curl -s -o /tmp/resp.txt -w "%{http_code}" -X "$method" "${auth[@]}" "$BASE$path")
  printf "#%-2s %-9s %-6s %-26s -> %s (expected %s)  %s\n" \
    "$n" "${creds%%:*}" "$method" "$path" "$code" "$expected" "$(cat /tmp/resp.txt)"
}

req -                  GET    /api/public               200   # anonymous
req -                  GET    /api/me                   401   # anonymous, no login
req user:user123       GET    /api/user/profile         200
req user:user123       GET    /api/admin/users          403   # USER cannot read admin
req manager:manager123 GET    /api/manager/reports      200
req manager:manager123 DELETE /api/admin/users/1        403   # MANAGER is not ADMIN
req admin:admin123     GET    /api/admin/users          200
req admin:admin123     DELETE /api/admin/users/1        200
req user:user123       GET    /api/users/user/data      200   # own data
req user:user123       GET    /api/users/admin/data     403   # someone else's data
