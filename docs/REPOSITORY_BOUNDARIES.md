# Repository boundaries

The project currently spans four repositories or source responsibilities.

| Repository | Owns | Does not own |
| --- | --- | --- |
| Application source | Laminas application code, tests, Composer files, safe source configuration | Local databases, deployment infrastructure, developer credentials |
| `laminas-safari-deployment` | Production Dockerfile, image builds, ECR publishing, release and deployment procedures | Editable developer workflow, local source mounts |
| `laminas-safari-dev-environment` | Docker Desktop onboarding, editable local source workflow, local MariaDB lifecycle, developer-safe configuration | Production image publishing, EC2 provisioning, production credentials |
| `ec2-instances` | Terraform/Ansible provisioning for disposable EC2 test infrastructure | Application source ownership, production deployment releases |

The application source is currently an archive and is not yet hosted in GitHub.
The preferred next source-repository step is a private repository with branch
and pull-request workflow. Public release can be considered after the readiness
review in [SOURCE_REPOSITORY_READINESS.md](SOURCE_REPOSITORY_READINESS.md).

## Data and secret ownership

- Database dumps remain private input payloads and are never committed here.
- Runtime secrets are supplied through local `.env` or an approved secret
  process; they do not belong in any repository.
- ECR credentials and AWS infrastructure permissions belong to deployment or
  infrastructure administration, not the application source.
- CAPTCHA and SMTP keys must be reviewed by the application/service owner.

