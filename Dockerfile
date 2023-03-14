FROM python:3.6-buster

COPY nginx.conf /etc/nginx/conf.d/default.conf

WORKDIR /src
COPY requirements.txt /src
RUN pip install -r requirements.txt

COPY . /src
CMD ["flask", "run", "--host", "0.0.0.0"]
