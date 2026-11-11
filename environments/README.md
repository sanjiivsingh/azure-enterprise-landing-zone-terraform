# Environment Directory Structure

This directory houses the root composition layers for different deployment targets within the Azure landing zone lifecycle.

---

## Directory Organization

```text
environments/
├── README.md                # Environment organization overview
├── dev/                     # Active Development Environment
│   ├── main.tf              # Child module instantiation with for_each
│   ├── locals.tf            # Naming standardization & CIDR computations
│   ├── variables.tf         # Input schema declarations
│   ├── terraform.tfvars     # Dev environment configuration values
│   ├── outputs.tf           # Computed outputs (Hub VNet, Firewall IP, Spoke VNets)
│   ├── provider.tf          # AzureRM provider block
│   ├── version.tf           # Terraform & AzureRM version constraints
│   ├── backend.tf           # Remote state backend configuration template
│   └── README.md            # Detailed Dev architecture & runbook
│
└── prod/                    # Production Environment Scaffold
    └── README.md            # Production deployment & hardening blueprint
```

---

## Environment Separation Model

1. **State Isolation**: Each environment maintains completely isolated state files or remote state containers, preventing cross-environment drift or accidental blast-radius leakage.
2. **Configuration Parity**: Both `dev` and `prod` share the identical set of scalable child modules located in `../../modules/`, ensuring consistency across environments.
3. **Parameter Variances**: Differences between `dev` and `prod` (e.g., SKU tiers, replica counts, CIDR blocks) are driven entirely through `terraform.tfvars`.
