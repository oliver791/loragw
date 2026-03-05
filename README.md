# loraGW Standard + Logs — Fork modifié

Fork de [non-det-alle/loragw](https://github.com/non-det-alle/loragw) — Packet forwarder LoRa standard avec écriture des logs.

## Modifications apportées

Ce fork ajoute la fonctionnalité d'**écriture des logs** au packet forwarder LoRa standard :

- Journalisation des paquets reçus (uplinks) et envoyés (downlinks).
- Enregistrement des métadonnées radio (RSSI, SNR, fréquence, spreading factor, etc.).
- Logs exploitables pour l'analyse de performance et le débogage du réseau LoRaWAN.

## Structure du projet
```
.
├── lora_gateway/         # Bibliothèque HAL du concentrateur LoRa
├── loragw/               # Scripts de configuration et service systemd
├── packet_forwarder/     # Packet forwarder avec écriture des logs
│   ├── lora_pkt_fwd/     # Code source principal
│   │   ├── cfg/          # Fichiers de configuration par région/carte
│   │   ├── inc/          # Headers
│   │   └── src/          # Code source (lora_pkt_fwd.c modifié pour les logs)
│   ├── util_ack/         # Utilitaire de test ACK
│   ├── util_sink/        # Utilitaire sink
│   └── util_tx_test/     # Utilitaire de test TX
└── readme.md
```

## Prérequis

- Raspberry Pi avec concentrateur LoRa (ex : RAK831, IMST iC880A)
- Accès SPI activé sur le Raspberry Pi

## Compilation et déploiement

Compilation directement sur le Raspberry Pi :

```bash
# Compilation de la bibliothèque HAL
cd lora_gateway
make clean
make

# Compilation du packet forwarder
cd ../packet_forwarder
make clean
make
```

Ou compilation sur le Raspberry Pi puis copie du binaire :

```bash
cd packet_forwarder/lora_pkt_fwd
scp lora_pkt_fwd utilisateur@IP_DU_PI:/chemin/destination/
```

## Configuration

Adapter les fichiers de configuration selon votre setup :

```bash
# Configuration globale (fréquences, gains, etc.)
nano packet_forwarder/lora_pkt_fwd/global_conf.json

# Configuration locale (adresse du serveur, Gateway ID, etc.)
nano packet_forwarder/lora_pkt_fwd/local_conf.json

# Mise à jour automatique du Gateway ID
cd packet_forwarder/lora_pkt_fwd
./update_gwid.sh local_conf.json
```

## Exécution

```bash
cd packet_forwarder/lora_pkt_fwd
./lora_pkt_fwd
```

Les logs sont écrits pendant l'exécution et permettent de suivre l'activité de la gateway en temps réel.

## Autres branches disponibles

| Branche             | Description                                     |
|---------------------|-------------------------------------------------|
| `main`              | loraGW Auto-DL (downlinks automatiques)         |
| `gw-standard-log`   | Gateway standard avec écriture des logs (cette branche) |

## Auteur des modifications

Olivier — [olivier.maire2.auditeur@lecnam.net](mailto:olivier.maire2.auditeur@lecnam.net)

## Licence

Voir la licence du projet original : [non-det-alle/loragw](https://github.com/non-det-alle/loragw)
