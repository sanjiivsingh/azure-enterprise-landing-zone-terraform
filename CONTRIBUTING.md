# Contributing Guidelines

Thank you for your interest in improving this Azure Landing Zone reference architecture!

## Development & Validation Workflow

1. Fork or branch from `main`:
   ```bash
   git checkout -b feature/your-improvement
   ```
2. Verify formatting and linting:
   ```bash
   terraform fmt -check -recursive
   tflint --init && tflint --recursive
   ```
3. Validate Terraform syntax:
   ```bash
   cd environments/dev
   terraform init -backend=false
   terraform validate
   ```
4. Run Security SAST:
   ```bash
   checkov -d . --framework terraform
   ```
5. Submit a Pull Request targeting `main` with detailed test evidence.
