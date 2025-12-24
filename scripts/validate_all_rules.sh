#!/bin/bash
set -e

# Enable recursive globbing (**)
shopt -s globstar

RULES="**/rules/*.yml"

echo "[*] Sigma syntax validation"
sigma check $RULES

echo "[*] OpenSearch (ECS)"
sigma convert -t opensearch_lucene -p sysmon $RULES > /dev/null

echo "[*] Splunk (Windows)"
sigma convert -t splunk -p splunk_windows $RULES > /dev/null

echo "[*] Elastic / ElastAlert (legacy)"
sigma convert -t elastalert -p windows-logsources $RULES > /dev/null

echo "[*] Elastic / ElastAlert (legacy)"
sigma convert -t eql -p sysmon $RULES > /dev/null

echo "[*] RSA NetWitness"
sigma convert -t net_witness -p sysmon $RULES > /dev/null

echo "[*] Lucene + Sysmon"
sigma convert -t lucene -p sysmon $RULES > /dev/null

echo "[*] Sentinel + Sysmon"
sigma convert -t sentinel_one -p sysmon $RULES > /dev/null
sigma convert -t sentinel_one_pq -p windows-logsources $RULES > /dev/null

echo "[+] All Sigma rules are valid and convertible across targets"

