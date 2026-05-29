FROM mcr.microsoft.com/devcontainers/base:ubuntu-24.04

ARG AZURE_CLI_VERSION="2.73.0"
ARG CHECKOV_VERSION="3.2.529"
ARG POWERSHELL_VERSION="7.4.6"
ARG PRE_COMMIT_VERSION="3.7.1"
ARG SHELLCHECK_VERSION="0.10.0"
ARG TERRAFORM_DOCS_VERSION="0.24.0"
ARG TERRAFORM_VERSION="1.15.5"
ARG TFLINT_VERSION="0.61.0"
ARG TRIVY_VERSION="0.69.3"

# Base dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
        curl unzip xz-utils python3 python3-venv gnupg \
    && rm -rf /var/lib/apt/lists/*

# azure-cli via Microsoft apt repo (GPG-verified, pinned version)
RUN curl -fsSL https://packages.microsoft.com/keys/microsoft.asc \
        | gpg --dearmor -o /usr/share/keyrings/microsoft.gpg \
    && echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/microsoft.gpg] \
        https://packages.microsoft.com/repos/azure-cli/ $(lsb_release -cs) main" \
        > /etc/apt/sources.list.d/azure-cli.list \
    && apt-get update && apt-get install -y --no-install-recommends azure-cli=${AZURE_CLI_VERSION}-1~$(lsb_release -cs) \
    && rm -rf /var/lib/apt/lists/*

# powershell with SHA256 verification (deb for amd64, tar.gz for arm64)
RUN ARCH=$(dpkg --print-architecture) \
    && curl -fsSL "https://github.com/PowerShell/PowerShell/releases/download/v${POWERSHELL_VERSION}/hashes.sha256" \
        -o /tmp/powershell_hashes.sha256 \
    && if [ "${ARCH}" = "amd64" ]; then \
        curl -fsSL "https://github.com/PowerShell/PowerShell/releases/download/v${POWERSHELL_VERSION}/powershell_${POWERSHELL_VERSION}-1.deb_amd64.deb" \
            -o "/tmp/powershell_${POWERSHELL_VERSION}-1.deb_amd64.deb" \
        && (cd /tmp && grep "powershell_${POWERSHELL_VERSION}-1.deb_amd64.deb" powershell_hashes.sha256 | sha256sum -c) \
        && apt-get update && apt-get install -y --no-install-recommends "/tmp/powershell_${POWERSHELL_VERSION}-1.deb_amd64.deb" \
        && rm "/tmp/powershell_${POWERSHELL_VERSION}-1.deb_amd64.deb" \
        && rm -rf /var/lib/apt/lists/*; \
    else \
        curl -fsSL "https://github.com/PowerShell/PowerShell/releases/download/v${POWERSHELL_VERSION}/powershell-${POWERSHELL_VERSION}-linux-arm64.tar.gz" \
            -o "/tmp/powershell-${POWERSHELL_VERSION}-linux-arm64.tar.gz" \
        && (cd /tmp && grep "powershell-${POWERSHELL_VERSION}-linux-arm64.tar.gz" powershell_hashes.sha256 | sha256sum -c) \
        && mkdir -p /opt/microsoft/powershell/7 \
        && tar -xzf "/tmp/powershell-${POWERSHELL_VERSION}-linux-arm64.tar.gz" -C /opt/microsoft/powershell/7/ \
        && chmod +x /opt/microsoft/powershell/7/pwsh \
        && ln -sf /opt/microsoft/powershell/7/pwsh /usr/bin/pwsh \
        && rm "/tmp/powershell-${POWERSHELL_VERSION}-linux-arm64.tar.gz"; \
    fi \
    && rm /tmp/powershell_hashes.sha256

# terraform with SHA256 verification
RUN ARCH=$(dpkg --print-architecture) \
    && curl -fsSL "https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_${ARCH}.zip" \
        -o "/tmp/terraform_${TERRAFORM_VERSION}_linux_${ARCH}.zip" \
    && curl -fsSL "https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_SHA256SUMS" \
        -o /tmp/terraform_SHA256SUMS \
    && (cd /tmp && grep "terraform_${TERRAFORM_VERSION}_linux_${ARCH}.zip" terraform_SHA256SUMS | sha256sum -c) \
    && unzip "/tmp/terraform_${TERRAFORM_VERSION}_linux_${ARCH}.zip" terraform -d /usr/local/bin \
    && rm "/tmp/terraform_${TERRAFORM_VERSION}_linux_${ARCH}.zip" /tmp/terraform_SHA256SUMS

# checkov + pre-commit in isolated Python venv
RUN python3 -m venv /opt/checkov \
    && /opt/checkov/bin/pip install --no-cache-dir \
        checkov==${CHECKOV_VERSION} \
        pre-commit==${PRE_COMMIT_VERSION}

ENV PATH="/opt/checkov/bin:${PATH}"

# shellcheck (no checksum file published upstream; archive verified by TLS)
RUN ARCH=$(uname -m) \
    && curl -fsSL "https://github.com/koalaman/shellcheck/releases/download/v${SHELLCHECK_VERSION}/shellcheck-v${SHELLCHECK_VERSION}.linux.${ARCH}.tar.xz" \
        | tar -xJ -C /tmp \
    && mv "/tmp/shellcheck-v${SHELLCHECK_VERSION}/shellcheck" /usr/local/bin/ \
    && rm -rf "/tmp/shellcheck-v${SHELLCHECK_VERSION}"

# tflint with SHA256 verification
RUN ARCH=$(dpkg --print-architecture) \
    && curl -fsSL "https://github.com/terraform-linters/tflint/releases/download/v${TFLINT_VERSION}/tflint_linux_${ARCH}.zip" \
        -o "/tmp/tflint_linux_${ARCH}.zip" \
    && curl -fsSL "https://github.com/terraform-linters/tflint/releases/download/v${TFLINT_VERSION}/checksums.txt" \
        -o /tmp/tflint_checksums.txt \
    && (cd /tmp && grep "tflint_linux_${ARCH}.zip" tflint_checksums.txt | sha256sum -c) \
    && unzip "/tmp/tflint_linux_${ARCH}.zip" tflint -d /usr/local/bin \
    && rm "/tmp/tflint_linux_${ARCH}.zip" /tmp/tflint_checksums.txt

# trivy with SHA256 verification
RUN ARCH=$(uname -m) \
    && TRIVY_ARCH=$([ "${ARCH}" = "x86_64" ] && echo "64bit" || echo "ARM64") \
    && curl -fsSL "https://github.com/aquasecurity/trivy/releases/download/v${TRIVY_VERSION}/trivy_${TRIVY_VERSION}_Linux-${TRIVY_ARCH}.tar.gz" \
        -o "/tmp/trivy_${TRIVY_VERSION}_Linux-${TRIVY_ARCH}.tar.gz" \
    && curl -fsSL "https://github.com/aquasecurity/trivy/releases/download/v${TRIVY_VERSION}/trivy_${TRIVY_VERSION}_checksums.txt" \
        -o /tmp/trivy_checksums.txt \
    && (cd /tmp && grep "trivy_${TRIVY_VERSION}_Linux-${TRIVY_ARCH}.tar.gz" trivy_checksums.txt | sha256sum -c) \
    && tar -xz -C /usr/local/bin -f "/tmp/trivy_${TRIVY_VERSION}_Linux-${TRIVY_ARCH}.tar.gz" trivy \
    && rm "/tmp/trivy_${TRIVY_VERSION}_Linux-${TRIVY_ARCH}.tar.gz" /tmp/trivy_checksums.txt

# terraform-docs with SHA256 verification
RUN ARCH=$(dpkg --print-architecture) \
    && curl -fsSL "https://github.com/terraform-docs/terraform-docs/releases/download/v${TERRAFORM_DOCS_VERSION}/terraform-docs-v${TERRAFORM_DOCS_VERSION}-linux-${ARCH}.tar.gz" \
        -o "/tmp/terraform-docs-v${TERRAFORM_DOCS_VERSION}-linux-${ARCH}.tar.gz" \
    && curl -fsSL "https://github.com/terraform-docs/terraform-docs/releases/download/v${TERRAFORM_DOCS_VERSION}/terraform-docs-v${TERRAFORM_DOCS_VERSION}.sha256sum" \
        -o /tmp/terraform-docs_sha256sum \
    && (cd /tmp && grep "terraform-docs-v${TERRAFORM_DOCS_VERSION}-linux-${ARCH}.tar.gz" terraform-docs_sha256sum | sha256sum -c) \
    && tar -xz -C /usr/local/bin -f "/tmp/terraform-docs-v${TERRAFORM_DOCS_VERSION}-linux-${ARCH}.tar.gz" terraform-docs \
    && chmod +x /usr/local/bin/terraform-docs \
    && rm "/tmp/terraform-docs-v${TERRAFORM_DOCS_VERSION}-linux-${ARCH}.tar.gz" /tmp/terraform-docs_sha256sum

USER vscode
