#!/bin/bash

HTTP_PROXY=$HTTP_PROXY
HTTPS_PROXY=$HTTPS_PROXY
USE_UV=$USE_UV
PYPI_SOURCE=$PYPI_SOURCE

# Install Rye
curl -sSf https://rye.astral.sh/get | bash

# Setup Rye path
echo "$HOME/.rye/shims" >> $GITHUB_PATH

# Copy base config
cp $GITHUB_ACTION_PATH/configs/config.toml $HOME/.rye/

# Setup Proxy if needed
if [ -n "$HTTP_PROXY" ]; then
    rye config --set proxy.http=$HTTP_PROXY
fi
if [ -n "$HTTPS_PROXY" ]; then
    rye config --set proxy.https=$HTTPS_PROXY
fi

# Setup UV
if [ "$USE_UV" == "true" ]; then
    rye config --set-bool behavior.use-uv=true
fi

# Setup PyPI source
if [ -n "$PYPI_SOURCE" ]; then
    sed -i 's|url = "https://pypi.org/simple"|url = "'$PYPI_SOURCE'"|' $HOME/.rye/config.toml
fi

# # Check config
# cat $HOME/.rye/config.toml
