# External services

Local settings must remain clearly separate from QA, Integration, and
Production settings.

## SMTP

The application may use the real development SMTP service. Configure it only
in the untracked `.env` file using development credentials. Do not put SMTP
passwords in Git, the source archive, or the Docker image.

Before sending mail locally, confirm the development account’s recipient and
relay policy. Do not use production SMTP credentials.

## CAPTCHA

Use only CAPTCHA test keys locally:

```dotenv
RECAPTCHA_SITE_KEY=...
RECAPTCHA_SECRET_KEY=...
```

Do not commit these values. Production keys must never be used in the local
environment.

## Mercury/payment

Local Mercury behavior is configured as mocked:

```dotenv
MERCURY_MODE=mock
```

The local workflow must not submit real payment transactions. Real Mercury
test-card behavior belongs in a controlled QA or Integration environment with
its own runtime configuration and access controls.

The current POC reserves the mode variable for that separation; the complete
local mock adapter is a later implementation task.

