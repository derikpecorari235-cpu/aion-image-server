import os
import platform
import subprocess
from flask import Flask, request, send_file

app = Flask(__name__)

# O código agora é inteligente: ele descobre sozinho se está no seu Windows ou no Linux da Nuvem
if platform.system() == 'Windows':
    CHROME_PATH = r"C:\Program Files\Google\Chrome\Application\chrome.exe"
else:
    CHROME_PATH = "/usr/bin/google-chrome" # Caminho oficial do Chrome nos servidores Linux

@app.route('/health', methods=['GET'])
def health_check():
    return {"status": "AION Image Server is online na Nuvem!"}, 200

@app.route('/gerar-imagem', methods=['POST'])
def gerar_imagem():
    try:
        dados = request.json
        
        with open('template.html', 'r', encoding='utf-8') as f:
            html_content = f.read()

        if dados:
            for chave, valor in dados.items():
                html_content = html_content.replace(f"{{{{{chave}}}}}", str(valor))

        temp_html_path = os.path.abspath('temp_render.html')
        with open(temp_html_path, 'w', encoding='utf-8') as f:
            f.write(html_content)

        output_image = os.path.abspath('post_aion.png')
        
        # Parâmetros otimizados para rodar liso e sem travar em servidores na nuvem
        comando = [
            CHROME_PATH,
            "--headless=new",
            "--disable-gpu",
            "--no-sandbox", # Regra obrigatória para o Chrome rodar no Linux
            "--disable-dev-shm-usage", # Evita estouro de memória no servidor
            "--hide-scrollbars",
            "--window-size=1080,1350",
            f"--screenshot={output_image}",
            f"file:///{temp_html_path}"
        ]
        
        subprocess.run(comando, check=True)

        return send_file(output_image, mimetype='image/png')

    except Exception as e:
        return {"erro": str(e)}, 500

if __name__ == '__main__':
    # Na nuvem, o servidor precisa escutar no host '0.0.0.0' para a internet conseguir acessar
    porta = int(os.environ.get('PORT', 5000))
    app.run(host='0.0.0.0', port=porta)