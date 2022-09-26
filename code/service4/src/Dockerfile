FROM python:3.9-buster

RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app

RUN apt install libpq-dev
COPY requirements.txt /usr/src/app/
RUN pip3 install --no-cache-dir -r requirements.txt

COPY . /usr/src/app
RUN chmod +x ./startup.sh

EXPOSE 8080

CMD ["./startup.sh"]