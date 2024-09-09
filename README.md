# Autonomys Network  incetivized testnet

# JOIN MY CHANNEL
- [TELEGRAM CHANNEL](https://t.me/AirdropJP_JawaPride)
- [WEBSITE](https://linktr.ee/Jawa_Pride_ID)
- [DISCUSS](https://t.me/AirdropJPdiskusi)
- [for me](https://t.me/timplexzz)
- - - - - - - - -
<img src="https://github.com/Wawanahayy/Autonomys-Network-/blob/main/photo.jpg" alt="-" width="250" height="250"> <img src="https://github.com/Wawanahayy/Autonomys-Network-/blob/main/photo1.jpg" alt="-" width="250" height="250"> <img src="https://github.com/Wawanahayy/Autonomys-Network-/blob/main/2in1.gif" alt="-" width="250" height="250">
- - - - - - - - -

# STEP BY STEP HERE
1. [wallet: download subwallet](https://chromewebstore.google.com/detail/subwallet-polkadot-wallet/onhogfjeacnfoofkfgppdlbmlmnplgbn)
- network: gemini 3H
2. [go to](https://astral.autonomys.xyz/gemini-3h/staking)
3. copy address { wait this }

# VPS
# 1. install
```bash
sudo apt update
sudo apt install docker.io docker-compose -y
```

# 2. create new screen
```bash
screen -Rd autonomys
```

# 3. create folder 
```bash
mkdir autonomys && cd autonomys
```
# 4. go to file nano
```bash
nano docker-compose.yml
```
# 5. fill this code to nano
# ❗️ change to your address {st- - -} 
# ➡️ reward-address
```bash
services:
  node:
    image: ghcr.io/autonomys/node:gemini-3h-2024-sep-03
    volumes:
      - node-data:/var/subspace:rw
    ports:
      - "0.0.0.0:30333:30333/tcp"
      - "0.0.0.0:30433:30433/tcp"
    restart: unless-stopped
    command:
      [
        "run",
        "--chain", "gemini-3h",
        "--base-path", "/var/subspace",
        "--listen-on", "/ip4/0.0.0.0/tcp/30333",
        "--dsn-listen-on", "/ip4/0.0.0.0/tcp/30433",
        "--rpc-cors", "all",
        "--rpc-methods", "unsafe",
        "--rpc-listen-on", "0.0.0.0:9944",
        "--farmer",
        "--name", "subspace"
      ]
    healthcheck:
      timeout: 5s
      interval: 30s
      retries: 60
  farmer:
    depends_on:
      node:
        condition: service_healthy
    image: ghcr.io/autonomys/farmer:gemini-3h-2024-sep-03
    volumes:
      - farmer-data:/var/subspace:rw
    ports:
      - "0.0.0.0:30533:30533/tcp"
    restart: unless-stopped
    command:
      [
        "farm",
        "--node-rpc-url", "ws://node:9944",
        "--listen-on", "/ip4/0.0.0.0/tcp/30533",
        "--reward-address", "st8KPK6urWnG4bPqdWU1V7vaMM5eWkkoWFu9gwgEHA8vwvSV8",
        "path=/var/subspace,size=100G"
      ]
volumes:
  node-data:
  farmer-data:
```

# to exit use Ctrl + X, Y, and Enter.

# 6. run your script
```bash
docker-compose up -d
```

# DONE ENJOY ✔️

# SERVICE 

CHECK LOGS
```bash
docker compose logs --tail=1000 -f
```
CHECK STATUS
```bash
docker-compose ps
```
RUN
```bash
docker-compose up -d
```

DELETED IF YOU NEED or if END
```bash
docker-compose down
```
