# Application source repository readiness

The application source is currently supplied as `input/laminas-app.tar.gz`.
This project can continue using that archive, but normal branch and pull
request development requires the application to move into its own repository.

## Recommended migration path

Start with a private GitHub repository. Consider public visibility only after
the source, history, assets, and licensing have been reviewed.

The application repository should contain application code and safe templates.
It should not contain this developer environment, deployment infrastructure,
database payloads, or environment credentials.

## Pre-upload review

Before creating the repository, the application owner should confirm:

- No `.env` files or environment-specific local configuration are present.
- No SMTP, CAPTCHA, AWS, payment, database, or other service credentials are
  present.
- No private keys, certificates, tokens, or credential backups are present.
- No development or production database dumps are present.
- No generated logs, caches, `vendor/`, or local uploads are present unless
  explicitly required by the application.
- Uploaded images and documents have been reviewed for sensitive content.
- Third-party code and assets have acceptable licenses and attribution.
- The development database has completed its separate privacy review.
- The repository has an appropriate `.gitignore` and secret-scanning policy.

## Archive inspection

Run these read-only checks before migration:

```bash
tar -tzf input/laminas-app.tar.gz > /tmp/laminas-app-files.txt

rg -i '(^|/)(\.env|.*secret.*|.*credential.*|.*password.*|.*\.pem|.*\.key)$' \
  /tmp/laminas-app-files.txt
```

The second command should produce no unexpected results. Review any match
manually; filenames such as password-reset views are not automatically secrets.

After extracting the source, search text files without printing secret values
into chat or tickets:

```bash
rg -l -i \
  'AKIA[0-9A-Z]{16}|-----BEGIN .*PRIVATE KEY-----|password\s*[:=]|secret\s*[:=]|api[_-]?key\s*[:=]' \
  app/
```

Matches require human review and may include harmless examples or application
field names. Do not paste matching lines into public issues.

## Git history review

If the source has ever existed in another Git repository, scan its complete
history before publishing. Removing a secret from the current file is not
enough if it remains in an earlier commit. Rotate any exposed credential before
publishing.

Use the organization-approved secret scanner, such as GitHub secret scanning,
Gitleaks, or TruffleHog, according to the organization’s policy.

## Initial repository contents

The first source repository should normally include:

- application source;
- `composer.json` and `composer.lock`;
- safe configuration templates such as `local.php.dist`;
- application tests and QA configuration;
- source-specific build notes; and
- a source-project README.

It should not include:

- `input/horsesns_safari-dev.sql.gz`;
- `.env` or production runtime files;
- this repository’s Docker Compose files;
- Terraform or Ansible state/configuration; or
- private deployment payloads.

## Handoff into this project

Once the application repository is approved, the developer environment can
replace archive extraction with a checkout or clone into `app/`. The Compose
contract remains the same: the application source is mounted at
`/var/www/html`, and local runtime values are supplied outside the source
repository.

