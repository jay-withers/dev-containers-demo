FROM mcr.microsoft.com/devcontainers/base:ubuntu-24.04

ARG AZURE_CLI_URL="https://packages.microsoft.com/repos/azure-cli/pool/main/a/azure-cli/azure-cli_2.73.0-1~noble_amd64.deb@sha256:26b28de55fbc8a397af9bcb0f44c15615943cce0675ae40095bc68bd66acdf6b"
ARG CHECKOV_URL="https://github.com/bridgecrewio/checkov/releases/download/3.2.529/checkov_linux_arm64.zip@sha256:fff55b064eadfc14ce35da9b9744dedf82fb50c25447076149480ad92c06a6a9"
ARG PRE_COMMIT_URL="https://github.com/pre-commit/pre-commit/releases/download/v3.7.1/pre-commit-3.7.1.pyz@sha256:a0349324f0f53b08d00eb473b5f6646c8a07f3253703c09b977b0b9b9476d486"
ARG POWERSHELL_URL="https://github.com/PowerShell/PowerShell/releases/download/v7.4.6/powershell_7.4.6-1.deb_amd64.deb@sha256:79642721f0bc9baf07dafaab68ece1cbd822f86722492acf9b4031d41029a735"
ARG SHELLCHECK_URL="https://github.com/koalaman/shellcheck/releases/download/v0.10.0/shellcheck-v0.10.0.linux.x86_64.tar.xz@sha256:6c881ab0698e4e6ea235245f22832860544f17ba386442fe7e9d629f8cbedf87"
ARG TERRAFORM_URL="https://releases.hashicorp.com/terraform/1.15.5/terraform_1.15.5_linux_amd64.zip@sha256:702b2136af6728c8ff037f843dd2dbce2b7ad88786b7381d1d72aefa250f601c"
ARG TERRAFORM_DOCS_URL="https://github.com/terraform-docs/terraform-docs/releases/download/v0.24.0/terraform-docs-v0.24.0-linux-amd64.tar.gz@sha256:9005daf969de0b50134493a2c00078b49f5f5b39d021cda7c89bf4d4f3d776d3"
ARG TFLINT_URL="https://github.com/terraform-linters/tflint/releases/download/v0.61.0/tflint_linux_amd64.zip@sha256:ca4e4e8cb7cc3436f2b6979e9c4fd4e2623a66fcca1ad1fe12f8669967636ae2"
ARG TRIVY_URL="https://github.com/aquasecurity/trivy/releases/download/v0.69.3/trivy_0.69.3_Linux-64bit.tar.gz@sha256:1816b632dfe529869c740c0913e36bd1629cb7688bd5634f4a858c1d57c88b75"

# Base dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
        curl unzip xz-utils python3 \
    && rm -rf /var/lib/apt/lists/*

# azure-cli with pinned SHA256 digest
RUN URL="${AZURE_CLI_URL%@sha256:*}" \
    && SHA="${AZURE_CLI_URL##*@sha256:}" \
    && curl -fsSL "${URL}" -o /tmp/azure-cli.deb \
    && (cd /tmp && echo "${SHA}  azure-cli.deb" | sha256sum -c) \
    && apt-get update && apt-get install -y --no-install-recommends /tmp/azure-cli.deb \
    && rm /tmp/azure-cli.deb \
    && rm -rf /var/lib/apt/lists/* \
    && az --version

# powershell with pinned SHA256 digest
RUN URL="${POWERSHELL_URL%@sha256:*}" \
    && SHA="${POWERSHELL_URL##*@sha256:}" \
    && curl -fsSL "${URL}" -o /tmp/powershell.deb \
    && (cd /tmp && echo "${SHA}  powershell.deb" | sha256sum -c) \
    && apt-get update && apt-get install -y --no-install-recommends /tmp/powershell.deb \
    && rm /tmp/powershell.deb \
    && rm -rf /var/lib/apt/lists/* \
    && pwsh --version

# terraform with pinned SHA256 digest
RUN URL="${TERRAFORM_URL%@sha256:*}" \
    && SHA="${TERRAFORM_URL##*@sha256:}" \
    && curl -fsSL "${URL}" -o /tmp/terraform.zip \
    && (cd /tmp && echo "${SHA}  terraform.zip" | sha256sum -c) \
    && unzip /tmp/terraform.zip terraform -d /usr/local/bin \
    && rm /tmp/terraform.zip \
    && terraform version

# checkov binary with pinned SHA256 digest
RUN URL="${CHECKOV_URL%@sha256:*}" \
    && SHA="${CHECKOV_URL##*@sha256:}" \
    && curl -fsSL "${URL}" -o /tmp/checkov.zip \
    && (cd /tmp && echo "${SHA}  checkov.zip" | sha256sum -c) \
    && unzip /tmp/checkov.zip -d /usr/local/bin \
    && chmod +x /usr/local/bin/checkov \
    && rm /tmp/checkov.zip \
    && checkov --version

# pre-commit with pinned SHA256 digest
RUN URL="${PRE_COMMIT_URL%@sha256:*}" \
    && SHA="${PRE_COMMIT_URL##*@sha256:}" \
    && curl -fsSL "${URL}" -o /usr/local/bin/pre-commit \
    && (cd /usr/local/bin && echo "${SHA}  pre-commit" | sha256sum -c) \
    && chmod +x /usr/local/bin/pre-commit \
    && pre-commit --version

# shellcheck with pinned SHA256 digest
RUN URL="${SHELLCHECK_URL%@sha256:*}" \
    && SHA="${SHELLCHECK_URL##*@sha256:}" \
    && curl -fsSL "${URL}" -o /tmp/shellcheck.tar.xz \
    && (cd /tmp && echo "${SHA}  shellcheck.tar.xz" | sha256sum -c) \
    && tar -xJ -C /tmp -f /tmp/shellcheck.tar.xz \
    && mv /tmp/shellcheck-v*/shellcheck /usr/local/bin/ \
    && rm -rf /tmp/shellcheck-v* /tmp/shellcheck.tar.xz \
    && shellcheck --version

# tflint with pinned SHA256 digest
RUN URL="${TFLINT_URL%@sha256:*}" \
    && SHA="${TFLINT_URL##*@sha256:}" \
    && curl -fsSL "${URL}" -o /tmp/tflint.zip \
    && (cd /tmp && echo "${SHA}  tflint.zip" | sha256sum -c) \
    && unzip /tmp/tflint.zip tflint -d /usr/local/bin \
    && rm /tmp/tflint.zip \
    && tflint --version

# trivy with pinned SHA256 digest
RUN URL="${TRIVY_URL%@sha256:*}" \
    && SHA="${TRIVY_URL##*@sha256:}" \
    && curl -fsSL "${URL}" -o /tmp/trivy.tar.gz \
    && (cd /tmp && echo "${SHA}  trivy.tar.gz" | sha256sum -c) \
    && tar -xz -C /usr/local/bin -f /tmp/trivy.tar.gz trivy \
    && rm /tmp/trivy.tar.gz \
    && trivy --version

# terraform-docs with pinned SHA256 digest
RUN URL="${TERRAFORM_DOCS_URL%@sha256:*}" \
    && SHA="${TERRAFORM_DOCS_URL##*@sha256:}" \
    && curl -fsSL "${URL}" -o /tmp/terraform-docs.tar.gz \
    && (cd /tmp && echo "${SHA}  terraform-docs.tar.gz" | sha256sum -c) \
    && tar -xz -C /usr/local/bin -f /tmp/terraform-docs.tar.gz terraform-docs \
    && chmod +x /usr/local/bin/terraform-docs \
    && rm /tmp/terraform-docs.tar.gz \
    && terraform-docs --version

USER vscode
