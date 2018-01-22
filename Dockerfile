# Pull base image.
FROM hdf87ery/ubuntu_dev

LABEL maintainer="Shao-Min Wu" \
      contact="hdf87ery@hotmail.com"

# Define working directory.
RUN mkdir /data -p && mkdir /apps -p

WORKDIR /apps

RUN apt install -y python-tk \
                   aria2
				   
# Install requirements
RUN git clone https://github.com/djhn75/RNAEditor.git
RUN git clone https://github.com/samtools/htslib.git
RUN git clone https://github.com/samtools/bcftools.git
RUN git clone https://github.com/samtools/samtools.git
RUN git clone https://github.com/arq5x/bedtools2.git
# RUN git clone https://github.com/lh3/bwa.git

# config bcftools
RUN cd bcftools; make -j6 && \
  mv  bcftools /usr/local/bin/
  
# config samtools
RUN cd samtools && \
  autoheader && \
  autoconf -Wno-syntax && \
  ./configure && \
  make -j6 && \
  mv samtools /usr/local/bin/
  
# config bedtools 
RUN cd bedtools2 && \
  make -j6 && \
  mv bin/* /usr/local/bin/
 
# config bwa
# RUN cd bwa && \
#  make -j6 && \
#  mv bwa /usr/local/bin/

  
# config bwa
# COPY bwakit-0.7.15_x64-linux.tar.bz2 . 
RUN wget https://sourceforge.net/projects/bio-bwa/files/bwakit/bwakit-0.7.15_x64-linux.tar.bz2
RUN tar jxf bwakit-0.7.15_x64-linux.tar.bz2 && \
  mv bwa.kit/bwa /usr/local/bin/

# config blat
# COPY blat . 
RUN wget http://hgdownload.soe.ucsc.edu/admin/exe/linux.x86_64/blat/blat
RUN chmod +x blat && \
  mv blat /usr/local/bin/

# config GATK 
# COPY GenomeAnalysisTK-3.5-0-g36282e4.tar.bz2 . 
RUN aria2c "https://software.broadinstitute.org/gatk/download/auth?package=GATK-archive&version=3.5-0-g36282e4"
RUN tar jxf GenomeAnalysisTK-3.5-0-g36282e4.tar.bz2 && \
  mkdir /usr/local/bin/GATK/ -p && \
  mv GenomeAnalysisTK.jar /usr/local/bin/GATK/

# config jdk
# COPY jdk-7u80-linux-x64.tar.gz .
RUN wget http://ftp.osuosl.org/pub/funtoo/distfiles/oracle-java/jdk-7u80-linux-x64.tar.gz
RUN tar xf jdk-7u80-linux-x64.tar.gz 

# config picard
# COPY picard-tools-1.119.zip . 
RUN wget https://sourceforge.net/projects/picard/files/picard-tools/1.119/picard-tools-1.119.zip
RUN unzip picard-tools-1.119.zip && \
		mkdir -p /usr/local/bin/picard-tools/ && \
		cp picard-tools-1.119/* /usr/local/bin/picard-tools/
#
RUN pip install --upgrade pip
RUN pip install numpy pysam matplotlib
RUN rm -rf /var/lib/apt/lists/*

COPY Helper.py /apps/RNAEditor
COPY RNAEditor.py /apps/RNAEditor

WORKDIR /data

# RUN adduser --system --group --shell /bin/sh auser \
# && mkdir /home/auser/bin
# USER auser



# Define commonly used JAVA_HOME variable
ENV JAVA_HOME /apps/jdk1.7.0_80
ENV PATH="/apps/jdk1.7.0_80/bin:${PATH}"
ENV PATH="/apps/RNAEditor:${PATH}"

# VOLUME /data
# Define default command.
# CMD ["bash"]
