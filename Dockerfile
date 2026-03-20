# Usa um Linux leve com Python já instalado
FROM python:3.10-slim

# Instala o Google Chrome oficial do Linux e suas dependências
RUN apt-get update && apt-get install -y wget gnupg \
    && wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - \
    && sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list' \
    && apt-get update \
    && apt-get install -y google-chrome-stable \
    && rm -rf /var/lib/apt/lists/*

# Copia os arquivos da sua máquina para dentro da nuvem
WORKDIR /app
COPY . /app

# Instala o Flask
RUN pip install -r requirements.txt

# Liga o motor
CMD ["python", "App.py"]