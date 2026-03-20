FROM python:3.10-slim

# Passo 1: Atualiza o sistema e instala a ferramenta de download
RUN apt-get update && apt-get install -y wget

# Passo 2: Baixa o instalador oficial do Chrome direto do Google e instala sem burocracia
RUN wget -q https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb \
    && apt-get install -y ./google-chrome-stable_current_amd64.deb \
    && rm google-chrome-stable_current_amd64.deb \
    && rm -rf /var/lib/apt/lists/*

# Passo 3: Copia os arquivos da AION para a nuvem
WORKDIR /app
COPY . /app

# Passo 4: Instala o Flask e as dependências
RUN pip install -r requirements.txt

# Passo 5: Liga o motor
CMD ["python", "App.py"]