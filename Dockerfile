FROM python:3.6-alpine

COPY nginx.conf /etc/nginx/conf.d/default.conf

WORKDIR /src
RUN apk add mariadb-connector-c mariadb-dev mariadb mariadb-dev mariadb-client build-base
COPY requirements.txt /src
RUN pip install -r requirements.txt

COPY . /src
CMD ["python3", "wsgi.py"]
