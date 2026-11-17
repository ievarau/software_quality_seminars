FROM docker.io/rocker/r-ver:4.4.1

WORKDIR /app

RUN R -e "install.packages('ggplot2', repos='https://cloud.r-project.org')"

COPY app.R .

CMD ["Rscript", "app.R"]