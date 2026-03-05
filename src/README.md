# loraGW Auto-DL — Fork modifié

Fork de [non-det-alle/loragw](https://github.com/non-det-alle/loragw) — Packet forwarder LoRa avec gestion automatique des downlinks.

## Modifications apportées

Ce fork ajoute la fonctionnalité **Auto-DL** (Automatic Downlink) au packet forwarder LoRa :

- Gestion automatique de l'envoi des trames descendantes (downlinks) vers les end-devices LoRa.
- Configuration simplifiée via les fichiers `global_conf.json` et `local_conf.json`.

## Structure du projet
```
.
├── cfg/                  # Fichiers de configuration
├── inc/                  # Headers
├── src/                  # Code source
├── Makefile
├── global_conf.json      # Configuration globale de la gateway
├── local_conf.json       # Configuration locale
├── update_gwid.sh        # Script de mise à jour du Gateway ID
└── readme.md
```

## Prérequis

- Raspberry Pi avec concentrateur LoRa (ex : RAK831, IMST iC880A)
- Bibliothèque `lora_gateway` compilée

## Compilation et déploiement

Compilation sur le Raspberry Pi :

```bash
make clean
make
```

Ou cross-compilation depuis un PC puis transfert via `scp` :

```bash
# Sur le PC
make

# Transfert vers le Pi
scp lora_pkt_fwd utilisateur@IP_DU_PI:/chemin/destination/
```

## Exécution

```bash
# Mise à jour du Gateway ID
./update_gwid.sh local_conf.json

# Lancement
./lora_pkt_fwd
```

## Autres branches disponibles

| Branche            | Description                                      |
|--------------------|--------------------------------------------------|
| `main`             | loraGW Auto-DL (cette branche)                   |
| `gw-standard-log`  | Gateway standard avec écriture des logs          |

## Auteur des modifications

Olivier — [olivier.maire2.auditeur@lecnam.net](mailto:olivier.maire2.auditeur@lecnam.net)

## Licence

Voir la licence du projet original : [non-det-alle/loragw](https://github.com/non-det-alle/loragw)
