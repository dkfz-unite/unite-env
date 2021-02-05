###################################################
FROM ubuntu:18.04

# Update aptitude and install some required packages
# a lot of them are required for Bio::DB::BigFile
RUN apt-get update && apt-get -y install \
    build-essential \
    apt-utils \
	python3 \
	python3-pip \
    git \
    libpng-dev \
    zlib1g-dev \
    libbz2-dev \
    liblzma-dev \
#    perl \
#    perl-base \
#    unzip \
    wget
#    wget && \
#    rm -rf /var/lib/apt/lists/*

##########################################
# Build UNITEmakestdvcf
##########################################
# To hold the GIT downloads prior to install
RUN mkdir /src
RUN chmod 777 /src

# Install UNITEmsc
COPY src/UNITEmsc/ /src/UNITEmsc/ 
WORKDIR /src/UNITEmsc
RUN python3 setup.py install

# Install UNITEvcfstandardization
COPY src/UNITEvcfstandardization/ /src/UNITEvcfstandardization/ 
WORKDIR /src/UNITEvcfstandardization
RUN python3 setup.py install

ENTRYPOINT ["UNITEmakestdvcf.py"]
#CMD tail -f /dev/null

