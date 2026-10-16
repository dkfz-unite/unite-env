#!/bin/sh
# Ensembl release and genome build of the installation, used by the Ensembl data and VEP cache scripts.
# Usage (from programs/mysql or applications/unite-ensembl-vep):
#   . ../../scripts/ensembl.sh
# Sets: release, grch (37 or 38) and ftp (Ensembl FTP folder of the release for the genome build).

# Ensembl 116 is the last release published on ftp.ensembl.org (newer data is published on the new Ensembl platform only).
release=116

. ../../.env
[ -f ../../.env.local ] && . ../../.env.local

case $(echo "${UNITE_GENOME_BUILD:-GRCh37}" | tr 'A-Z' 'a-z') in
  grch37) grch=37; ftp=https://ftp.ensembl.org/pub/grch37/release-$release;;
  grch38) grch=38; ftp=https://ftp.ensembl.org/pub/release-$release;;
  *) echo "Invalid UNITE_GENOME_BUILD '$UNITE_GENOME_BUILD' in .env or .env.local: should be either 'GRCh37' or 'GRCh38'"; exit 1;;
esac
