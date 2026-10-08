# POC validation checklist

This checklist records the current developer-environment validation state.
Update it as blocked items become testable. Do not record credentials or secret
values here.

## Passing

- [x] Local Docker Desktop startup
- [x] EC2 clean-machine startup
- [x] Apache/PHP/Laminas homepage
- [x] Editable host source changes visible without rebuilding
- [x] Login behavior
- [x] Database-backed reads and writes
- [x] Database restore
- [x] Explicit database reset and recreation
- [x] Application logs
- [x] Database logs
- [x] Application shell access
- [x] Development SMTP flow
- [x] Composer PSR-4 warning cleanup
- [x] Apache `ServerName` warning cleanup

## Pending retest

### CAPTCHA

Status: blocked by provider configuration.

Observed error:

```text
ERROR for site owner: Invalid domain for site key
```

Required follow-up:

1. Backend/account owner confirms the CAPTCHA product and owning portal.
2. Add `localhost` and, if needed, `127.0.0.1` to the allowed domains, or
   provide dedicated local test keys.
3. Retest the CAPTCHA page at the configured local port.

Do not record site keys or secret keys in this file.

### Mercury/payment

Status: local mock behavior is not implemented; real local submissions are
paused.

The `MERCURY_MODE=mock` variable is currently reserved configuration only. The
application still displays the Mercury payment UI because no mock adapter has
been wired into the application source.

Required follow-up:

- Keep real test-card transactions in QA/Integration.
- Implement and test an application-level local mock before enabling a local
  payment smoke test.

## Completion criteria

The POC validation is complete when CAPTCHA has valid local configuration and
the team has either implemented and tested a local Mercury mock or explicitly
accepted that payment testing is QA/Integration-only.

