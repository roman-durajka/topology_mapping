FROM python:3.10-alpine

WORKDIR /app
RUN apk add mariadb-connector-c mariadb-dev mariadb mariadb-dev mariadb-client build-base
COPY . /app
RUN pip install -r requirements.txt

CMD ["python3", "wsgi.py"]
