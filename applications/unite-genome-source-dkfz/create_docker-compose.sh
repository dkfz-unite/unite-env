cat <<EOT > .docker-compose.tmp.yml
version: "3"
services:
  ${2}.${1}.mutations.source.otp.unite:
    build:
      context: .
      dockerfile: ./Dockerfile
    image: unite.mutations.source.otp.${1}.${2}
    container_name: unite.mutations.source.otp.${1}.${2}
    environment:
      UNITE_COMPOSER_URL: http://unite.mutations.feed/api/mutations
      UNITE_VCF_STANDARDIZATION_URL: http://unite.vcf.standardization:5101/otp/\${VCFFILETYPE}
      FILECRAWL_MONGOHOST: mongo
      OTP_ORIGINAL_DIR: \${ORIGINAL_DIR}
      OTP_MOUNTPOINT: \${MOUNTPOINT}
      UNITE_LOGLEVEL: \${LOGLEVEL}
      OTP_FILESOURCE: \${FILESOURCE}
      FILECRAWL_PURGE: \${FILELISTPURGE}
    volumes:
      - \${MOUNTPOINT}:\${MOUNTPOINT}
# For incoming REST requests for data from original file. 
# Figure out how to handle this later 
#    ports:
#      - 127.0.0.1:5901:5000
networks:
  default:
    external:
      name: unite
EOT
      