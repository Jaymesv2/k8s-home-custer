# helmfiles


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


# Hosts
## Master Node
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
The host will run nixos. 
### Storage
The drives will 
6 - 16TB WD Gold drives in RAID-Z (80TB usable)
## Worker 1
### Specs
asdf
### Operating System
Currently Ubuntu Server
### Storage
None
# Microk8s Options
dashboard, dns, helm3, prometheus, registry, storage, cilium, fluentd, gpu, helm, ingress, istio, jaeger, knative, kubeflow, linkerd, metallb, metrics-server, rbac

# Persistence layer
handles data persistence.
## Storage Providers
### HDD
Bulk data storage.
### SSD
Fast storage for applications
## Storage APIs
### Minio
provides s3 object storage, provides buckets using both hdd and ssd storage.
### PVCS
Some pvcs will be 

ssd storage is at `/mnt/sped/`, hdd storage is at `/mnt/tank`
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