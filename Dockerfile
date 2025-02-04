FROM thmhoag/steamcmd:latest

USER root

RUN apt-get update && \
    apt-get install -y curl cron bzip2 perl-modules lsof libc6-i386 lib32gcc1 sudo

RUN curl -sL "https://raw.githubusercontent.com/FezVrasta/ark-server-tools/v1.6.54/netinstall.sh" | bash -s steam && \
    ln -s /usr/local/bin/arkmanager /usr/bin/arkmanager

COPY arkmanager/arkmanager.cfg /etc/arkmanager/arkmanager.cfg
COPY arkmanager/instance.cfg /etc/arkmanager/instances/main.cfg
COPY run.sh /home/steam/run.sh
COPY log.sh /home/steam/log.sh

RUN mkdir /ark && \
    chown -R steam:steam /home/steam/ /ark
    
RUN mkdir /cluster && \
    chown -R steam:steam /home/steam/ /cluster

RUN echo "%sudo   ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers && \
    usermod -a -G sudo steam && \
    touch /home/steam/.sudo_as_admin_successful

WORKDIR /home/steam
USER steam

ENV am_ark_SessionName="theMIGHTYark" \
    am_serverMap="TheIsland" \
    am_ark_ServerAdminPassword="k3yb04rdc4t" \
    am_ark_MaxPlayers=70 \
    am_ark_QueryPort=27015 \
    am_ark_Port=7778 \
    am_ark_RCONPort=32330 \
    am_arkwarnminutes=15 \
    am_ark_GameModIds="731604991,1404697612,1814953878,2121156303,1428596566,895711211" \
    arkopt_ClusterDirOverride="/cluster" \
    arkopt_clusterid="themightycluster" \
    am_arkflag_NoTransferFromFiltering="" \
    am_ark_PreventDownloadSurvivors="False" \
    am_ark_PreventDownloadItems="False" \
    am_ark_PreventDownloadDinos="False" \
    am_ark_PreventUploadSurvivors="False" \
    am_ark_PreventUploadItems="False" \
    am_ark_PreventUploadDinos="False"

VOLUME /ark
VOLUME /cluster

CMD [ "./run.sh" ]
