# Microsoft Patch Tuesday - July 2026

[Version française](./README_FR.md)

This index groups the detection packs created for the July 2026 Microsoft Patch Tuesday. Rules remain in their top-level CVE directories to preserve repository conventions.

| CVE | Product | Detection pack |
| --- | --- | --- |
| CVE-2026-56155 | AD FS | [`CVE-2026-56155_ADFS_EoP`](../CVE-2026-56155_ADFS_EoP/README.md) |
| CVE-2026-56164 | SharePoint Server | [`CVE-2026-56164_SharePoint_Auth_Bypass`](../CVE-2026-56164_SharePoint_Auth_Bypass/README.md) |
| CVE-2026-50661 | BitLocker | [`CVE-2026-50661_BitLocker_Bypass`](../CVE-2026-50661_BitLocker_Bypass/README.md) |
| CVE-2026-57092 | Hyper-V VMSwitch | [`CVE-2026-57092_VMSwitch_EoP`](../CVE-2026-57092_VMSwitch_EoP/README.md) |
| CVE-2026-50518 | Windows DHCP Server | [`CVE-2026-50518_DHCP_Server_RCE`](../CVE-2026-50518_DHCP_Server_RCE/README.md) |
| CVE-2026-55010 | Minecraft Bedrock Dedicated Server | [`CVE-2026-55010_Minecraft_Bedrock_RCE`](../CVE-2026-55010_Minecraft_Bedrock_RCE/README.md) |
| CVE-2026-58644 | SharePoint Server deserialization RCE | [`CVE-2026-58644_SharePoint_Deserialization_RCE`](../CVE-2026-58644_SharePoint_Deserialization_RCE/README.md) |
| CVE-2026-50663 | Age of Empires II: Definitive Edition | [`CVE-2026-50663_Age_of_Empires_II_RCE`](../CVE-2026-50663_Age_of_Empires_II_RCE/README.md) |

## Deployment order

Prioritize actively exploited AD FS and SharePoint, then exposed DHCP/Minecraft servers, Hyper-V hosts, BitLocker systems, and Age of Empires II endpoints. The rules detect high-confidence host or web effects; they do not replace patch compliance or prove exploitation by themselves.

## References

- https://msrc.microsoft.com/update-guide/vulnerability/CVE-2026-50663
- https://msrc.microsoft.com/update-guide/vulnerability/CVE-2026-56155
- https://msrc.microsoft.com/update-guide/vulnerability/CVE-2026-56164

