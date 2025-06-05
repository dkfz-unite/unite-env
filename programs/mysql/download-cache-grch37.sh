#!/bin/bash
dbn=113
dbr="$dbn"_"37"
cor_url=https://ftp.ensembl.org/pub/grch37/release-$dbn/mysql/homo_sapiens_core_$dbr
# fun_url=https://ftp.ensembl.org/pub/grch37/release-$dbn/mysql/homo_sapiens_funcgen_$dbr

if [ ! -d "./cache/core37" ]
then
  mkdir -p cache/core37
fi

# if [ ! -d "./cache/func37" ]
# then
#   mkdir -p cache/func37
# fi

cd ./cache/core37
tput setaf 4; echo "# Downloading Ensembl core database cache"; tput sgr0
# wget -c $cor_url/alt_allele.txt.gz
# wget -c $cor_url/alt_allele_attrib.txt.gz
# wget -c $cor_url/alt_allele_group.txt.gz
# wget -c $cor_url/analysis.txt.gz
# wget -c $cor_url/analysis_description.txt.gz
# wget -c $cor_url/assembly.txt.gz
# wget -c $cor_url/assembly_exception.txt.gz
# wget -c $cor_url/associated_group.txt.gz
# wget -c $cor_url/associated_xref.txt.gz
wget -c $cor_url/attrib_type.txt.gz
wget -c $cor_url/biotype.txt.gz
wget -c $cor_url/coord_system.txt.gz
# wget -c $cor_url/data_file.txt.gz
# wget -c $cor_url/density_feature.txt.gz
# wget -c $cor_url/density_type.txt.gz
# wget -c $cor_url/dependent_xref.txt.gz
# wget -c $cor_url/ditag.txt.gz
# wget -c $cor_url/ditag_feature.txt.gz
# wget -c $cor_url/dna.txt.gz
# wget -c $cor_url/dna_align_feature.txt.gz
# wget -c $cor_url/dna_align_feature_attrib.txt.gz
wget -c $cor_url/exon.txt.gz
wget -c $cor_url/exon_transcript.txt.gz
wget -c $cor_url/external_db.txt.gz
wget -c $cor_url/external_synonym.txt.gz
wget -c $cor_url/gene.txt.gz
wget -c $cor_url/gene_archive.txt.gz
wget -c $cor_url/gene_attrib.txt.gz
# wget -c $cor_url/genome_statistics.txt.gz
# wget -c $cor_url/homo_sapiens_core_109_37.sql
wget -c $cor_url/homo_sapiens_core_$dbr.sql.gz
# wget -c $cor_url/identity_xref.txt.gz
wget -c $cor_url/interpro.txt.gz
# wget -c $cor_url/intron_supporting_evidence.txt.gz
# wget -c $cor_url/karyotype.txt.gz
# wget -c $cor_url/map.txt.gz
# wget -c $cor_url/mapping_session.txt.gz
# wget -c $cor_url/mapping_set.txt.gz
# wget -c $cor_url/marker.txt.gz
# wget -c $cor_url/marker_feature.txt.gz
# wget -c $cor_url/marker_map_location.txt.gz
# wget -c $cor_url/marker_synonym.txt.gz
# wget -c $cor_url/meta.txt.gz
# wget -c $cor_url/meta_coord.txt.gz
# wget -c $cor_url/misc_attrib.txt.gz
# wget -c $cor_url/misc_feature.txt.gz
# wget -c $cor_url/misc_feature_misc_set.txt.gz
# wget -c $cor_url/misc_set.txt.gz
wget -c $cor_url/object_xref.txt.gz
wget -c $cor_url/ontology_xref.txt.gz
# wget -c $cor_url/operon.txt.gz
# wget -c $cor_url/operon_transcript.txt.gz
# wget -c $cor_url/operon_transcript_gene.txt.gz
# wget -c $cor_url/peptide_archive.txt.gz
# wget -c $cor_url/prediction_exon.txt.gz
# wget -c $cor_url/prediction_transcript.txt.gz
# wget -c $cor_url/protein_align_feature.txt.gz
wget -c $cor_url/protein_feature.txt.gz
# wget -c $cor_url/repeat_consensus.txt.gz
# wget -c $cor_url/repeat_feature.txt.gz
# wget -c $cor_url/rnaproduct.txt.gz
# wget -c $cor_url/rnaproduct_attrib.txt.gz
# wget -c $cor_url/rnaproduct_type.txt.gz
wget -c $cor_url/seq_region.txt.gz
wget -c $cor_url/seq_region_attrib.txt.gz
# wget -c $cor_url/seq_region_mapping.txt.gz
wget -c $cor_url/seq_region_synonym.txt.gz
# wget -c $cor_url/simple_feature.txt.gz
# wget -c $cor_url/stable_id_event.txt.gz
# wget -c $cor_url/supporting_feature.txt.gz
wget -c $cor_url/transcript.txt.gz
wget -c $cor_url/transcript_attrib.txt.gz
# wget -c $cor_url/transcript_intron_supporting_evidence.txt.gz
# wget -c $cor_url/transcript_supporting_feature.txt.gz
wget -c $cor_url/translation.txt.gz
wget -c $cor_url/translation_attrib.txt.gz
# wget -c $cor_url/unmapped_object.txt.gz
# wget -c $cor_url/unmapped_reason.txt.gz
wget -c $cor_url/xref.txt.gz
echo ""
cd ../../

# cd ./cache/func37
# tput setaf 4; echo "# Downloading Ensembl functional genome database cache"; tput sgr0
# wget -c $fun_url/feature_type.txt.gz
# wget -c $fun_url/homo_sapiens_funcgen_$dbr.sql.gz
# wget -c $fun_url/epigenome.txt.gz
# wget -c $fun_url/regulatory_activity.txt.gz
# wget -c $fun_url/regulatory_feature.txt.gz
# echo ""
# cd ../../
