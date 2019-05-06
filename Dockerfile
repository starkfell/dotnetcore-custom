# Pulling from the official Ubuntu Xenial image on Docker Hub.
FROM ubuntu:xenial

# Updating packages list and installing Azure CLI prerequisite packages.
RUN apt-get update && apt-get install -y net-tools vim jq wget curl openssh-client apt-transport-https lsb-release software-properties-common dirmngr libunwind8 icu-devtools --no-install-recommends

# Modifying the package sources and retrieving the Microsoft signing key.
RUN echo "deb [arch=amd64] https://packages.microsoft.com/repos/azure-cli/ wheezy main" | tee /etc/apt/sources.list.d/azure-cli.list
RUN apt-key --keyring /etc/apt/trusted.gpg.d/Microsoft.gpg adv --keyserver packages.microsoft.com --recv-keys BC528686B50D79E339D3721CEB3E94ADBE1229CF

# Installing the Azure CLI.
RUN apt-get update && apt-get install -y azure-cli --no-install-recommends && apt-get clean && rm -rf /var/lib/apt/lists/*

# Install .NET Core
ENV ASPNETCORE_VERSION 2.2.4

RUN curl -SL --output aspnetcore.tar.gz https://dotnetcli.blob.core.windows.net/dotnet/aspnetcore/Runtime/$ASPNETCORE_VERSION/aspnetcore-runtime-$ASPNETCORE_VERSION-linux-x64.tar.gz \
    && aspnetcore_sha512='8ea3dd1a5f955aa6b5816c99843cb2a247b1578292e41a66220d84188e36669c836bbfc961206bb51558e6d1b14f1597d16194a9679a227f33aabe4bc3382d4f' \
    && echo "$aspnetcore_sha512  aspnetcore.tar.gz" | sha512sum -c - \
    && mkdir -p /usr/share/dotnet \
    && tar -zxf aspnetcore.tar.gz -C /usr/share/dotnet \
    && rm aspnetcore.tar.gz \
    && ln -s /usr/share/dotnet/dotnet /usr/bin/dotnet

# Installing .NET SDK 2.2.
RUN wget -q https://packages.microsoft.com/config/ubuntu/16.04/packages-microsoft-prod.deb
RUN dpkg -i packages-microsoft-prod.deb
RUN apt-get update && apt-get install -y dotnet-sdk-2.2

ENTRYPOINT ["tail", "-f", "/dev/null"]
