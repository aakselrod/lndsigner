ARG gover=1.19.5

FROM golang:$gover

ARG goplatform
ARG cplatform
ARG lnd
ARG bitcoind
ARG vault

RUN apt update && apt-get install -y zip

RUN cd /root && \
    wget https://bitcoincore.org/bin/bitcoin-core-$bitcoind/bitcoin-${bitcoind}-${cplatform}-linux-gnu.tar.gz && \
    tar xfz bitcoin-$bitcoind-$cplatform-linux-gnu.tar.gz && \
    mv bitcoin-$bitcoind/bin/* /usr/local/bin/ && \
    wget https://github.com/lightningnetwork/lnd/releases/download/$lnd/lnd-linux-$goplatform-$lnd.tar.gz && \
    tar xfz lnd-linux-$goplatform-$lnd.tar.gz && \
    mv lnd-linux-$goplatform-$lnd/* /usr/local/bin/ && \
    wget https://releases.hashicorp.com/vault/$vault/vault_${vault}_linux_${goplatform}.zip && \
    unzip vault_${vault}_linux_${goplatform}.zip && \
    mv vault /usr/local/bin/ && \
    go install github.com/go-delve/delve/cmd/dlv@latest && \
    git config --global --add safe.directory /app && \
    echo "export PATH='$PATH:/usr/local/go/bin:/root/go/bin'" >> .bashrc

VOLUME [ "/app" ]

WORKDIR /app
