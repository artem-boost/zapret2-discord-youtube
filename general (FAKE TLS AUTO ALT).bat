@echo off
chcp 65001 > nul
:: 65001 - UTF-8

cd /d "%~dp0"
call service.bat status_zapret
call service.bat check_updates
call service.bat load_game_filter
echo:

set "BIN=%~dp0bin\"
set "LISTS=%~dp0lists\"
set "LUA=%~dp0files\lua\"
cd /d %BIN%

start "zapret: %~n0" /min "%BIN%winws2.exe" --lua-init=@%LUA%zapret-lib.lua --lua-init=@%LUA%zapret-antidpi.lua ^
--blob=quic_initial_www_google_com:@%BIN%quic_initial_www_google_com.bin ^
--wf-tcp-out=80,443,2053,2083,2087,2096,8443,%GameFilter% --wf-udp-out=443,19294-19344,50000-50100,%GameFilter% ^
--filter-udp=443 --hostlist="%LISTS%list-general.txt" --hostlist-exclude="%LISTS%list-exclude.txt" --ipset-exclude="%LISTS%ipset-exclude.txt" --lua-desync=fake:blob=quic_initial_www_google_com:repeats=11 --new ^
--filter-udp=19294-19344,50000-50100 --filter-l7=discord,stun --lua-desync=fake:blob=quic_initial_www_google_com:repeats=6 --new ^
--filter-tcp=2053,2083,2087,2096,8443 --hostlist-domains=discord.media --lua-desync=fake:blob=fake_default_tls:tls_mod=rnd,dupsid,sni=www.google.com:tcp_seq=2:repeats=8 --lua-desync=multisplit:pos=1 --new ^
--filter-tcp=443 --hostlist="%LISTS%list-google.txt" --lua-desync=fake:blob=fake_default_tls:repeats=8:tcp_seq=2:tls_mod=rnd,dupsid,sni=www.google.com --lua-desync=multisplit:pos=1:ip_id=zero --new ^
--filter-tcp=80,443 --hostlist="%LISTS%list-general.txt" --hostlist-exclude="%LISTS%list-exclude.txt" --ipset-exclude="%LISTS%ipset-exclude.txt" --lua-desync=fake:blob=fake_default_tls:repeats=8:tcp_seq=2:tls_mod=rnd,dupsid,sni=www.google.com --lua-desync=multisplit:pos=1 --new ^
--filter-udp=443 --ipset="%LISTS%ipset-all.txt" --hostlist-exclude="%LISTS%list-exclude.txt" --ipset-exclude="%LISTS%ipset-exclude.txt" --lua-desync=fake:blob=quic_initial_www_google_com:repeats=11 --new ^
--filter-tcp=80,443,%GameFilter% --ipset="%LISTS%ipset-all.txt" --hostlist-exclude="%LISTS%list-exclude.txt" --ipset-exclude="%LISTS%ipset-exclude.txt" --lua-desync=fake:blob=fake_default_tls:repeats=8:tcp_seq=2:tls_mod=rnd,dupsid,sni=www.google.com --lua-desync=multisplit:pos=1 --new ^
--filter-udp=%GameFilter% --ipset="%LISTS%ipset-all.txt" --ipset-exclude="%LISTS%ipset-exclude.txt" --lua-desync=fake:autottl=2:repeats=10:any_protocol=1:fake_unknown_udp=quic_initial_www_google_com:cutoff=n2
