
FROM python:3.9-slim


RUN pip install flask
RUN mkdir -p /var/log
WORKDIR /app
COPY app.py .
EXPOSE 80
CMD ["python", "app.py"]
