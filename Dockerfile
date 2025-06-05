FROM ubuntu:noble

# Install dependencies
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update -y && \
    apt-get install -y --no-install-recommends \
    build-essential \
    ca-certificates \
    dos2unix \
    wget \
    && rm -rf /var/lib/apt/lists/*

# Download and verify the shim sources
RUN wget https://github.com/rhboot/shim/releases/download/16.0/shim-16.0.tar.bz2 && \
    echo "d503f778dc75895d3130da07e2ff23d2393862f95b6cd3d24b10cbd4af847217  shim-16.0.tar.bz2" | sha256sum --check && \
    tar xvf shim-16.0.tar.bz2

# Set the working directory to the shim source
WORKDIR /shim-16.0

# Apply any patches
ADD shim-patches patches
RUN for patchfile in patches/*.patch; do \
    if [ -f $patchfile ]; then \
        patch -p1 -i $patchfile; \
    fi; \
    done

# Add our vendor certificate and SBAT data
ADD ziperase-secure-boot-ca-2025.cer ziperase-secure-boot-ca-2025.cer
ADD sbat.ziperase.csv ./data/

# Build the shims
ENV VENDOR_CERT_FILE=/shim-16.0/ziperase-secure-boot-ca-2025.cer
RUN mkdir /shim-16.0/build-ia32 /shim-16.0/build-x64

WORKDIR /shim-16.0/build-ia32
RUN setarch linux32 make TOPDIR=.. ARCH=ia32 -f ../Makefile | tee build-ia32.log
RUN objcopy --only-section .sbat -O binary shimia32.efi /dev/stdout | tee -a build-ia32.log
RUN objdump -p shimia32.efi | grep -E 'SectionAlignment|DllCharacteristics' >> build-ia32.log
RUN sha256sum shimia32.efi >> build-ia32.log
RUN echo "09b087cd41b73858c3710c19d39cdfc6b9e5fa910147c9eb24e7b5775b00434f  shimia32.efi" | sha256sum --check

WORKDIR /shim-16.0/build-x64
RUN make TOPDIR=.. -f ../Makefile | tee build-x64.log
RUN objcopy --only-section .sbat -O binary shimx64.efi /dev/stdout | tee -a build-x64.log
RUN objdump -p shimx64.efi | grep -E 'SectionAlignment|DllCharacteristics' >> build-x64.log
RUN sha256sum shimx64.efi >> build-x64.log
RUN echo "3b81fd7b864be4bd44a7d6130cfb469413477ae5b7376531cbe535a97b696478  shimx64.efi" | sha256sum --check

# Copy built files to the output directory
RUN mkdir -p /output
WORKDIR /output
RUN cp /shim-16.0/build-ia32/shimia32.efi .
RUN cp /shim-16.0/build-ia32/build-ia32.log .
RUN cp /shim-16.0/build-x64/shimx64.efi .
RUN cp /shim-16.0/build-x64/build-x64.log .
