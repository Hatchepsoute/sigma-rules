# Patch Tuesday Microsoft - Juillet 2026

[English version](./README.md)

Cet index regroupe les packs de détection du Patch Tuesday Microsoft de juillet 2026. Les règles restent dans leurs dossiers CVE racine afin de préserver les conventions du dépôt.

| CVE | Produit | Pack de détection |
| --- | --- | --- |
| CVE-2026-56155 | AD FS | [`CVE-2026-56155_ADFS_EoP`](../CVE-2026-56155_ADFS_EoP/README_FR.md) |
| CVE-2026-56164 | SharePoint Server | [`CVE-2026-56164_SharePoint_Auth_Bypass`](../CVE-2026-56164_SharePoint_Auth_Bypass/README_FR.md) |
| CVE-2026-50661 | BitLocker | [`CVE-2026-50661_BitLocker_Bypass`](../CVE-2026-50661_BitLocker_Bypass/README_FR.md) |
| CVE-2026-57092 | Hyper-V VMSwitch | [`CVE-2026-57092_VMSwitch_EoP`](../CVE-2026-57092_VMSwitch_EoP/README_FR.md) |
| CVE-2026-50518 | Serveur DHCP Windows | [`CVE-2026-50518_DHCP_Server_RCE`](../CVE-2026-50518_DHCP_Server_RCE/README_FR.md) |
| CVE-2026-55010 | Minecraft Bedrock Dedicated Server | [`CVE-2026-55010_Minecraft_Bedrock_RCE`](../CVE-2026-55010_Minecraft_Bedrock_RCE/README_FR.md) |
| CVE-2026-58644 | RCE SharePoint par désérialisation | [`CVE-2026-58644_SharePoint_Deserialization_RCE`](../CVE-2026-58644_SharePoint_Deserialization_RCE/README_FR.md) |
| CVE-2026-50663 | Age of Empires II: Definitive Edition | [`CVE-2026-50663_Age_of_Empires_II_RCE`](../CVE-2026-50663_Age_of_Empires_II_RCE/README_FR.md) |

## Ordre de déploiement

Prioriser AD FS et SharePoint exploités activement, puis les serveurs DHCP/Minecraft exposés, les hôtes Hyper-V, les systèmes BitLocker et les postes Age of Empires II. Les règles détectent des effets hôte ou web haute confiance ; elles ne remplacent pas le correctif et ne prouvent pas seules l'exploitation.

## Références

- https://msrc.microsoft.com/update-guide/vulnerability/CVE-2026-50663
- https://msrc.microsoft.com/update-guide/vulnerability/CVE-2026-56155
- https://msrc.microsoft.com/update-guide/vulnerability/CVE-2026-56164

