# Setup Rye

This GitHub Action installs the Rye programming language and copies a configuration file into the Rye directory.

## Inputs

### `version`

**Optional** The version of Rye to install. Default `"latest"`.

### `toolchain_version`

**Optional** The version of the Rye toolchain to install. Default `"3.10"`.

### `http_proxy`

**Optional** The HTTP proxy to use for Rye commands.

### `https_proxy`

**Optional** The HTTPS proxy to use for Rye commands.

### `python_version`

**Optional** The version of Python to use with Rye. Default `"3.10"`.

### `use-uv`

**Optional** Whether to use libuv for async I/O in Rye. Default `"true"`.

## Usage

To use this action in your workflow, add the following step:

```yaml
name: Setup Rye

on:
  push:
    branches:
      - master

jobs:
  setup-rye:
    name: Setup Rye
    runs-on: ubuntu-latest

    steps:
      - name: Checkout
        uses: actions/checkout@v4

      - name: Install Rye and Copy Config
        uses: mai0313/setup-rye@v1.0.1
        with:
          version: 'latest' # Optional, default is latest
          toolchain_version: '3.10' # Optional, default is 3.10
          python_version: '3.10' # Optional, default is 3.10
          use-uv: 'true' # Optional, default is true
          pypi_source: 'https://pypi.org/simple' # Optional
          http_proxy: ${{ secrets.HTTP_PROXY }} # Optional
          https_proxy: ${{ secrets.HTTPS_PROXY }} # Optional

      - name: Check Version
        run: |
          rye --version
```

## Contributing

Contributions to this action are welcome! Please submit a pull request or create an issue if you have any features or bug fixes.

## License

This project is licensed under the [MIT License](LICENSE).
