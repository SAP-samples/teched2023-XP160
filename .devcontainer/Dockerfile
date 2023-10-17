ARG VARIANT=bullseye
FROM --platform=amd64 mcr.microsoft.com/devcontainers/typescript-node:18-${VARIANT}
RUN wget -q -O - https://packages.cloudfoundry.org/debian/cli.cloudfoundry.org.key | apt-key add - ; \
    echo "deb https://packages.cloudfoundry.org/debian stable main" | tee /etc/apt/sources.list.d/cloudfoundry-cli.list

RUN apt-get update \
    && apt-get -y install --no-install-recommends cf8-cli
