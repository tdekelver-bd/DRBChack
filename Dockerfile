FROM python:latest
MAINTAINER Siwar Madrane "siwar.madrane@gmail.com"
COPY . /app
WORKDIR /app
RUN pip install -r requirements.txt
ENTRYPOINT ["python"]
CMD ["app.py"]
