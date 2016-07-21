FROM hypriot/rpi-alpine-scratch:v3.3
MAINTAINER oiavorskyi

# Install strongswan packackes and clean up
RUN apk add --update strongswan && \
    rm -rf /var/cache/apk/*

# Copy ipsec, iptable configuration
COPY ipsec.conf /etc/
COPY local.conf /etc/sysctl.d/

# Create scripts to manage VPN service
COPY init setup secrets /usr/local/bin/
ENV PATH /usr/local/bin:$PATH
RUN chmod +x /usr/local/bin/*

# The host FQDN or IP address where VPN service is running
# It is used to generate server certificate and should be used as Remote ID by clients 
ENV VPN_HOST acme.com
# Name of the VPN user
# It is used to generate client certificate and should be used as Local ID by clients
ENV VPN_USER user
# Password for XAuth and certificates
# If not changed a random value will be generated
ENV VPN_PASSWORD none

# Enable access of secrets
VOLUME /mnt

# Expose ipsec ports
EXPOSE 500/udp 4500/udp

# Start VPN service
ENTRYPOINT ["/usr/local/bin/init"]
