FROM rocker/geospatial

MAINTAINER MayeLab "gmayeregger@gmail.com"

# system libraries of general use 
RUN apt-get update && apt-get install -y \
    sudo \
    pandoc \
    pandoc-citeproc \
    libcurl4-gnutls-dev \
    libcairo2-dev \
    libxt-dev \
    libssl-dev \
    libssh2-1-dev \
    libssl1.1 \
    && rm -rf /var/lib/apt/lists/*

# system library dependency for the euler app
RUN apt-get update && apt-get install -y \
    libgdal-dev \
    && rm -rf /var/lib/apt/lists/*

# basic shiny functionality
RUN R -e "install.packages(c('shiny'), repos='https://cloud.r-project.org/')"

# install dependencies of the euler app  
RUN R -e "install.packages(c('shinyWidgets', 'shinydashboard', 'dplyr', 'rvest', 'leaflet', 'stringr', 'sf', 'shinybusy', 'RMySQL', 'DBI', 'shinyjs', 'blastula', 'httr', 'aws.s3', 'base64enc', 'colorspace', 'remotes'), repos='https://cloud.r-project.org/')"
RUN R -e "library(remotes)"
RUN R -e "remotes::install_github('RinteRface/waypointer', force = TRUE, upgrade = 'never')"

# copy the app to the image
RUN mkdir /root/portal
COPY portal /root/portal

COPY Rprofile.site /usr/lib/R/etc/

EXPOSE 3838

CMD ["R", "-e", "shiny::runApp('/root/portal', host='0.0.0.0', port=3838)"]
