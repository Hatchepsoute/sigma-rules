# Microsoft Patch Tuesday - July 2026

[Version française](./README_FR.md)

This index groups the detection packs created for the July 2026 Microsoft Patch Tuesday. Rules remain in their top-level CVE directories to preserve repository conventions.

| CVE | Product | CVSS | Detection pack |
| --- | --- | ---: | --- |
| CVE-2026-56155 | AD FS | 7.8 (High) | [`CVE-2026-56155_ADFS_EoP`](../CVE-2026-56155_ADFS_EoP/README.md) |
| CVE-2026-56164 | SharePoint Server | 5.3 (Microsoft) | [`CVE-2026-56164_SharePoint_Auth_Bypass`](../CVE-2026-56164_SharePoint_Auth_Bypass/README.md) |
| CVE-2026-50661 | BitLocker | 6.1 (Medium) | [`CVE-2026-50661_BitLocker_Bypass`](../CVE-2026-50661_BitLocker_Bypass/README.md) |
| CVE-2026-57092 | Hyper-V VMSwitch | 9.9 (Critical) | [`CVE-2026-57092_VMSwitch_EoP`](../CVE-2026-57092_VMSwitch_EoP/README.md) |
| CVE-2026-50518 | Windows DHCP Server | 9.8 (Critical) | [`CVE-2026-50518_DHCP_Server_RCE`](../CVE-2026-50518_DHCP_Server_RCE/README.md) |
| CVE-2026-55010 | Minecraft Bedrock Dedicated Server | 9.8 (Critical) | [`CVE-2026-55010_Minecraft_Bedrock_RCE`](../CVE-2026-55010_Minecraft_Bedrock_RCE/README.md) |
| CVE-2026-58644 | SharePoint Server deserialization RCE | 9.8 (Critical) | [`CVE-2026-58644_SharePoint_Deserialization_RCE`](../CVE-2026-58644_SharePoint_Deserialization_RCE/README.md) |
| CVE-2026-50663 | Age of Empires II: Definitive Edition | 8.8 (High) | [`CVE-2026-50663_Age_of_Empires_II_RCE`](../CVE-2026-50663_Age_of_Empires_II_RCE/README.md) |

## Why these detections matter

The July bulletin covers several hundred vulnerabilities, but patch deployment is rarely instantaneous. Legacy systems, maintenance windows, internet-facing services and operational constraints can leave vulnerable assets exposed after fixes are published. These rules provide compensating SOC controls for the highest-impact vulnerabilities, prioritising remote code execution, privilege escalation, authentication bypass and actively exploited issues. They do not replace patching; once remediation is verified, detections should be reviewed and tuned.

## Deployment order

Prioritize actively exploited AD FS and SharePoint, then exposed DHCP/Minecraft servers, Hyper-V hosts, BitLocker systems, and Age of Empires II endpoints. The rules detect high-confidence host or web effects; they do not replace patch compliance or prove exploitation by themselves.

## References

- https://msrc.microsoft.com/update-guide/vulnerability/CVE-2026-50663
- https://msrc.microsoft.com/update-guide/vulnerability/CVE-2026-56155
- https://msrc.microsoft.com/update-guide/vulnerability/CVE-2026-56164

