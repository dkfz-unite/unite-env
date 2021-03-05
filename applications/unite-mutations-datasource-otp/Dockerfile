###################################################
# unite-mutations-otp                             #
###################################################
FROM ubuntu:18.04

# Update aptitude and install some required packages
# a lot of them are required for Bio::DB::BigFile
RUN apt-get update && apt-get -y install \
    build-essential \
    python3 \
    python3-pip \
    git \
    cpanminus \
    curl \
    libmysqlclient-dev \
    libpng-dev \
    libssl-dev \
    zlib1g-dev \
    libbz2-dev \
    liblzma-dev \
    locales \
    openssl \
    perl \
    perl-base \
    unzip \
    sshfs \
    vim && \
    apt-get -y purge manpages-dev && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# gitpython must be installed before setup.py is run
RUN pip3 install gitpython

# environment for Python 3 code

# Takes the local FUSE conf as the base. This should be properly configured
#  with "user_allow_other" enabled
COPY ./src/UNITEotp/fuse.conf /etc/fuse.conf
RUN chown root:root /etc/fuse.conf
RUN chmod 644 /etc/fuse.conf

# To hold the GIT downloads prior to install
RUN mkdir /src
RUN chmod 777 /src

# Install UNITEotp
COPY ./src/UNITEotp/ /src/UNITEotp/ 
WORKDIR /src/UNITEotp
RUN ls -la
RUN python3 setup.py install

# Install UNITEmsc
COPY ./src/UNITEmsc/ /src/UNITEmsc/ 
WORKDIR /src/UNITEmsc
RUN ls -la
RUN python3 setup.py install

#ENTRYPOINT ["CrawlOTPVCFFile.py"]
CMD tail -f /dev/null

