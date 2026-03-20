FROM python:3.10-slim

# Passo 1: Instala os pacotes básicos
RUN apt-get update && apt-get install -y wget gnupg curl

# Passo 2: Baixa a chave de segurança do Google e instala o Chrome
RUN wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - \
    && sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list' \
    && apt-get update \
    && apt-get install -y google-chrome-stable \
    && rm -rf /var/lib/apt/lists/*

# Passo 3: Copia os arquivos da AION para a nuvem
WORKDIR /app
COPY . /app

# Passo 4: Instala o Flask
RUN pip install -r requirements.txt

# Passo 5: Liga o motor
CMD ["python", "App.py"]