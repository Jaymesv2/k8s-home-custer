# Home Cluster
My home cluster.

# Configuration Systems
## Ansible
Ansible manages each of the physical hosts and vms to get basic configs up

inspired by: https://github.com/eyulf/homelab

## Terraform
Terraform provisions the vms themselves
## Flux
Almost all applications are run on k8s so flux manages helm, kustomization etc...
# Networks
## Networks
| Name | Location | Cidr | Purpose |
| --- | --- | --- | --- |
| Home | Parents House | 10.0.0.0/16 | My Parents House  (I'm not going to route userland, guest, etc..., only the lab) |
| Primary | UTD | 10.1.0.0/16 | My private network at UTD (Desktop, Pis, Etc...)|


## BGP ASNs
| Name | Device | IP | ASN | Networks |
| --- | ---- | ---- | --- | --- |
| Home | udm pro | 
| Dorm | My Desktop | 10.255.255.22 | 
## Home
| Name | Cidr | Purpose |
| --- | --- | --- |
| Managment | 10.0.0.0/24 | Network for my unifi devices |
| Userland | 10.0.1.0/24 | User network |
| Guest | 192.168.0.0/24 | Guest network | 
| Service | 10.0.10.0/24 | Where the homelab lives |
| 10.255.255.0/24 | BGP Peering | where the bgp routes communicate with eachother |
# Hosts
## Udm Pro
Ubiquiti Dream Machine Pro. 
It runs wireguard, node exporter (prometheus metrics), and frr to work with metallb and my other bgp routing systems.
## Nas
### Specs
| part | item | model number | link|
|---|---|---|---|
| CPU | Ryzen Threadripper 1950X | YD195XA8AEWOF  | https://www.amd.com/en/products/cpu/amd-ryzen-threadripper-1950x |
| CPU cooler | XE02-SP3 | SVST-FBA-XE02-SP3 | https://www.silverstonetek.com/en/product/info/coolers/XE02-SP3/ | 
| RAM | 8x Kingston 16 GB 3200MHz DDR4 ECC CL22 DIMM| KSM32ES8/16HC | https://www.amazon.com/dp/B09N9TZZPJ?psc=1&ref=ppx_yo2ov_dt_b_product_details | 
| Motherboard | ASRock X399 Taichi | 90-MXB5R0-A0UAYZ | https://www.asrock.com/mb/amd/x399%20taichi/index.asp#Specification | 
| PSU | CORSAIR HX850, 850 Watt, 80+ Platinum| CP-9020138-NA | https://www.corsair.com/us/en/Categories/Products/Power-Supply-Units/hxi-series-2017-config/p/CP-9020138-NA |
| SSD | 2x samsung 980 pro| MZ-V8P2T0B/AM | https://semiconductor.samsung.com/consumer-storage/internal-ssd/980pro/ |
| HDD | 6x 16TB WD Gold | WD161KRYZ  | https://www.westerndigital.com/products/internal-drives/wd-gold-sata-hdd#WD161KRYZ |
### Operating System
The host will run debian.
### Storage
6 - 16TB WD Gold drives in RAID-Z
#### Partitions
The 2 2tb nvme ssds each have 3 partitions.
| name | size | purpose |
| --- | --- | --- |
| ESP | 1Mb | esp partition holding zfsbootloader|
| Root | 1500Gb | primary zfs partition |
| Metadata | 350 Gb | Zfs metadata partition for the `tank` zpool | 
#### Zpools
The system has 2 primary pools
| name | mode | purpose |
| --- | --- | --- |
| zroot | 2 drive mirror | fast mirrored storage |
| tank | 6 drive raidz a mirrored special metadata vdev | bulk data storage |
## Worker 1
### Specs
?
### Operating System
Currently Ubuntu Server
### Storage
512gb nvme ssd as boot drive
## Worker 2 (planned)
Worker 2 will be my current desktop when I build a new one.
### Specs
?
### Storage
?

# Storage
All of the cluster storage is on zfs.
## Datasets
| path | purpose |
| --- | --- |
| zroot/ROOT/debian | host os 
| zroot/vms/master | contains the cow2 file for the master node vm
| zroot/vms/worker1 |
| zroot/vms/worker2 |
| zroot/vms/worker3 |
| zroot/db/postgres | 
| zroot/db/? |
| zroot/minio/primary | minio storage
| tank/media | My media directory (accessed by lots of stuff like emby, torrent clients, radarr, etc....)
| tank/backups | 
| zroot/minio/


# Kubernetes


# Bootstrapping
helm needs the `helm-diff` plugin for helmfile to work. `helm plugin install https://github.com/databus23/helm-diff`

## Prometheus
Prometheus is a bit of a pain. This should work but I need to customize it.
```sh
git clone https://github.com/prometheus-operator/kube-prometheus 
kubectl apply --server-side -f kube-prometheus/manifests/setup        
until kubectl get servicemonitors --all-namespaces ; do date; sleep 1; echo ""; done     
kubectl apply -f kube-prometheus/manifests/   
```

## CRDs
### cert-manager
`kubectl apply -f https://github.com/cert-manager/cert-manager/releases/download/v1.8.2/cert-manager.crds.yaml`
### Traefik
`kubectl apply -f https://raw.githubusercontent.com/traefik/traefik/v2.8/docs/content/reference/dynamic-configuration/kubernetes-crd-definition-v1.yml`
# Microk8s Options
ignore this

dashboard, dns, helm3, prometheus, registry, storage, cilium, fluentd, gpu, helm, ingress, istio, jaeger, knative, kubeflow, linkerd, metallb, metrics-server, rbac

# Persistence layer
handles data persistence.
## Storage Providers
### HDD
Bulk data storage.
### SSD
Fast storage for applications (db, os, etc)
## Storage APIs
### Minio
provides s3 object storage, provides buckets using both hdd and ssd storage.
### PVCS
Some pvcs will be 

ssd storage is at `/zroot/sped/`, hdd storage is at `/mnt/tank`
| name | path | kind | purpose |
|---|----|----|----|
| media | /mnt/tank/media | hostpath hdd | store media files |
| qbt conf | /state/bt | hostpath hdd | 
| qbt conf | /state/pbt | hostpath hdd |

## Databases
Both Postgres and Mysql are provided since some applications require mysql. If I can though I will remove mysql.
### Postgres

### Mysql
DEPREICATED
### Redis
redis instances will probably be deployed per

# Base Software Infrastructure
## Kubernetes Dashboard
Kinda Important to have
## Observability
### Prometheus
collects metrics
### Otel Collector
run as daemonset which passes its data into elk
### Elastic Search
receives logs, metrics, and traces from the otel collector which it processes.

## Web Access (Ingress)
### Traefik
Traefik is the 
### Authelia
### Cert-Manager

# Applications
## Nextcloud
### traefik config
routers.nextcloud.rule: "Host(`cloud.jaymes.xyz`)"

routers.nextcloud.entrypoints: "websecure"

services.nextcloud.loadbalancer.server.port: "80"

middlewares.nextcloud.headers.stsseconds: "15552000"

middlewares.nextcloud.headers.stsincludesubdomains: "true"

middlewares.nextcloud.replacepathregex.regex: "^\\.well-known/(card|cal)dav"

middlewares.nextcloud.replacepathregex.replacement: "/nextcloud/remote.php/dav"

\# middlewares.nextcloud.redirectRegex.permanent: "true"

## Paperless

## Stash
## qbittorrent (proxied)
## qbittorrent (unproxied)
## Indexing
### Radarr
### Sonarr
### Lidarr
### Jackett
### Ombi
## Emby
## Calibre Web
## Nextcloud
## Synapse
### Synapse itsef
### Signald
### synapse well known
## Vaultwarden
## Gogs

authelia:
- authelia
- authelia_redis

traefik:
- traefik

stash
- stash

torrenting:
- qbt wireguard
- qbt

synapse:
- synapse
- signal-bridge
- signald
- synapse_well_known_1
- synapse_db_1
- synapse_signal_db_1

calibre-web:
- calibre

emby:
- emby

nextcloud:
- nextcloud
- nextcloud-db
- nextcloud-adminer
- nextcloud-redis

gogs:
- gogs
- gogs postgres

vaultwarden:
- vaultwarden
- vaultwarden db

paperless:
- paperless
- paperless db
- paperless broker (redis)

// whats backend?
backend:
- backend_db
- backend_adminer_1

other:
- adminer
- postgres
- mysql
- openldap