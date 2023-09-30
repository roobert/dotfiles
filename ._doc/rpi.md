# RPI [WIP]

- Dockerfile
- grafana
- InfluxDB
- MQQT
- victron
- Tasmoto

Disable swap

```bash
sudo dphys-swapfile swapoff
sudo dphys-swapfile uninstall
sudo update-rc.d dphys-swapfile remove
sudo apt purge dphys-swapfile
```

Install log2ram

```bash
echo "deb [signed-by=/usr/share/keyrings/azlux-archive-keyring.gpg] http://packages.azlux.fr/debian/ bullseye main" | sudo tee /etc/apt/sources.list.d/azlux.list
sudo wget -O /usr/share/keyrings/azlux-archive-keyring.gpg https://azlux.fr/repo.gpg
sudo apt update
sudo apt install log2ram
```

Edit /etc/log2ram.conf

```bash
MAIL=false
du -sh /var/log ...
SIZE=512M
```

TODO:

- sync data to remote?
- compare version of grafana and shit to what is in latest x86 version..

# Docker

Install docker-ce not docker from apt..

```bash
curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
sudo apt -y install docker-ce docker-ce-cli containerd.io
```

Install docker-compose from github:

```bash
wget https://github.com/docker/compose/releases/download/v2.6.1/docker-compose-linux-aarch64
mv docker-compose-linux-aarch64 bin/docker-compose
sudo systemctl enable docker
```

Permit our user to use docker:

```bash
sudo service start docker
sudo usermod -aG docker rw
```

Make the following changes to venus-docker-grafana to allow grafana to scrape metrics from plug influxdb instance:

For each service, add:

```yaml
restart: always
networks:
  - network0
```

Add a network block:

```

networks:
network0:
name: network0
external: true

```

- Change grafana docker tag from latest to: armhf-2.0.0
- Change upnp and server docker tags from latest to: armhf-latest
- Add `expose:` lines to docker-compose and copy ports from `ports:` key to open up access to services via network

```bash
sudo docker network create network0
```

Data is stored in /var/lib/docker/volumes/

Once services are running, configure a new backend with:

```yaml
name: influxdb-plugs
address: influxdb-plugs:18086
database: plugs
```

- configure the localbytes/tasmota plugs
- write traffic to rpi address
- adjust how often the plugs write data - 60s

Add autossh and forward ports from pi to colo VM since 4G means router is not on public network generate ssh key on rpi, copy authorized key to dust

```bash
sudo systemctl enable autossh
sudo service autossh start
```

Add systemd autossh.service init script:

```yaml
[Unit]
Description=AutoSSH service
After=network.target

[Service]
Environment="AUTOSSH_GATETIME=0"
User=rw
Group=rw
ExecStart=/usr/bin/autossh -N -M 0 -o "ServerAliveInterval 5" -o "ServerAliveCountMax 3" -i /home/rw/.ssh/id_rsa -R 6969:127.0.0.1:22 rw@dust.cx
RemainAfterExit=yes

[Install]
WantedBy=multi-user.target
```

1. Go to the admin interface @ http://localhost:8088, default username and password are admin and admin.
2. Access Grafana on http://localhost:3000 and enter `admin` for user name and `admin` for password.
3. Login to the victron site hosted on the pi and add the einstine/cervo thing to discovery page by IP
4. Login to router and reserve the leases to addresses for the various devices don't
5. Change the influxdb retention period.. through the Venus UI - for cerbo data, and through ??? for plug data? 30 years: 10950d
6. Mount the data volume on external SSD
7. Change dashboard colour to light
8. Add these plugins, or add them to the Dockerfile for grafana

```bash
docker ps
docker exec <grafana container id> grafana-cli plugins install pr0ps-trackmap-panel
grafana-cli plugins install briangann-gauge-panel
```

Rebuild docker image, update docker-compose with new image/version

- get rpi to scrape ruuvi
- get GPS through RPI USB
