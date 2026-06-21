# Agentic Emacs -- Fedora-based containerized AI workspace
# Base: Fedora Minimal (quay.io/fedora/fedora-minimal)
# Purpose: Emacs + security/tooling for agentic LLM workflows

FROM quay.io/fedora/fedora-minimal:latest

# ---------------------------------------------------------------------------
# System packages
# ---------------------------------------------------------------------------
# Emacs and core tooling for security research, shell execution, and
# filesystem interaction. Curated for the agentic Emacs agent ecosystem.
RUN microdnf install -y \
        emacs \
        bash \
        coreutils \
        findutils \
        git \
        curl \
        bind-utils \
        nmap \
        nmap-ncat \
        openssl \
        python3 \
        jq \
        whois \
        traceroute \
        tcpdump \
        ripgrep \
        sed \
        grep \
        gawk \
        tar \
        gzip \
        unzip \
        make \
        gcc \
        python3-pip \
    && microdnf clean all

# ---------------------------------------------------------------------------
# Working directory
# ---------------------------------------------------------------------------
WORKDIR /root

# Emacs is the entrypoint; .emacs.d is mounted at runtime via aios.sh
ENTRYPOINT ["emacs", "--no-x", "--load", "/root/.emacs.d/init.el"]
