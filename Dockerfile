FROM python:3
RUN apt-get -y update && apt-get -y install socat
RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app

COPY requirements.txt /usr/src/app/
RUN pip install --no-cache-dir -r requirements.txt

COPY . /usr/src/app

VOLUME /output

ENTRYPOINT ["python", "app.py"]
