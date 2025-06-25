# My Scripts

## Usage
Clone this repository to your local machine and run any script you find useful.
```bash
git clone https://github.com/schweista/my-scripts.git ~/my-scripts
cd ~/my-scripts
```

Optionally, you can add the `my-scripts` directory to your PATH for easier access:
```bash
echo 'export PATH="$HOME/my-scripts:$PATH"' >> ~/.bashrc
source ~/.bashrc
```

## Direct execution without cloning
Hello test script
```bash
bash <(curl -s https://raw.githubusercontent.com/schweista/my-scripts/refs/heads/main/shell-scripts/hello.sh)
```
Convert P12 to PEM script
```bash
bash <(curl -s https://raw.githubusercontent.com/schweista/my-scripts/refs/heads/main/shell-scripts/convert-p12-to-pem.sh)
```
