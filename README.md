# Duplicati-Setup

Meu setup pessoal para o serviço Duplicati no Linux, incluindo configuração do daemon, serviço systemd e conjunto de scripts de pré/pós-backup.

---

## 🔍 Visão geral

Este repositório contém:

1. **Configuração do Duplicati**  
   - `/etc/default/duplicati`  
   - `/etc/systemd/system/duplicati.service`

2. **Scripts de integração**  
   - Pasta `Duplicati-Scripts/` (deve ser instalada em `/root/duplicati-scripts/` por padrão)  
   - Estrutura de scripts globais e templates para jobs específicos

3. **Templates**  
   - Vários exemplos prontos em `templates/`

---

## 🛠️ Requisitos

- Duplicati instalado (por exemplo, via `apt install duplicati`)
- `zabbix_sender` (opcional, para integração com Zabbix)
- Acesso root ou sudo  
- Docker (caso use scripts de backup de containers Nextcloud)

---

## 📝 Instalação

1. **Copiar arquivos de configuração**  
   ```bash
   sudo cp ./Duplicati-Setup/duplicati /etc/default/duplicati
   sudo cp ./Duplicati-Setup/duplicati.service /etc/systemd/system/duplicati.service
   ```

2. **Criar diretório de scripts**  
   ```bash
   sudo cp -r ./Duplicati-Setup/duplicati-scripts/ /root/duplicati-scripts/
   sudo cp -r ./Duplicati-Setup/templates/<template> /root/duplicati-scripts/<template> # OPTIONAL
   sudo chmod -R 775 /root/duplicati-scripts/
   sudo chown -R root:sudo /root/duplicati-scripts/
   ```

3. **Configure as variáveis**  
   ```bash
      nano /etc/default/duplicati
      ## Duplicati não vai funcionar sem configurar corretamente estas variáveis ##
      # DUPLICATI_HOSTS
      # DUPLICATI_PASSWORD
      # DUPLICATI_ENCRYPTION_KEY
   ```

4. **Habilitar e iniciar o serviço**  
   ```bash
   sudo systemctl daemon-reload
   sudo systemctl enable duplicati
   sudo systemctl start duplicati
   ```

---

## 📂 Estrutura de scripts (`Duplicati-Scripts/`)

Por padrão, instale em `/root/duplicati-scripts/`.

```
duplicati-scripts/
├── after_backup_global.sh
├── before_backup_global.sh
└── global_scripts/
    ├── before/
    └── after/
templates/
└── <example>_scripts/
    ├── before/
    └── after/
      ...
```

- `before_backup_global.sh` / `after_backup_global.sh`  
  Executam **todos** os scripts em `global_scripts` antes e depois de qualquer job.

- `global_scripts/before/` e `global_scripts/after/`  
  Scripts comuns a todas as tarefas de backup.

- `<example>_scripts/`  
  Template para jobs específicos; mantenha a mesma lógica de `before/after`.

### Como adicionar um job específico

1. Duplique `templates/<example>_scripts/` e renomeie pra seu job (ex: `photos_scripts/`).  
2. Edite shebang, variáveis e paths dentro dos scripts.  
3. Configure no Duplicati:
   ```text
   --run-script-before=/root/duplicati-scripts/photos_scripts/before_backup_photos.sh
   --run-script-after=/root/duplicati-scripts/photos_scripts/after_backup_photos.sh
   ```

---

## 🔄 Integração com Zabbix

O script `duplicati-zabbix-report.sh` envia métricas para o Zabbix:

- Variáveis editáveis:  
  ```bash
  SERVER_IP=IP_DO_SERVIDOR_ZABBIX
  HOST=HOSTNAME_NO_ZABBIX
  ```
- Pré-requisitos:  
  - Zabbix Agent (`zabbix_sender`)  
  - Host configurado no servidor Zabbix

---

## ☁️ Integração com Nextcloud

Os scripts de pré e pós-backup permitem colocar o Nextcloud em modo de manutenção, fazer dump do banco e liberar a aplicação.

- Variáveis editáveis:  
  ```bash
  # Caminho até a raiz do seu Nextcloud no host
  CLOUD_FOLDER="/caminho/para/docker/nxtc-<CLOUD_NAME>"

  # Identificador/nome da instância Nextcloud (usado nos nomes de container)
  CLOUD_NAME="<CLOUD_NAME>"

  # (Opcional) Credenciais do banco de dados Nextcloud, se for fazer dump SQL
  DB_USERNAME="nextcloud"
  DB_PASSWORD="SUA_SENHA_DO_BANCO"
  DB_NAME="nextcloud"
  ```

---

## ✅ Uso

1. Ajuste variáveis em `/etc/default/duplicati`.  
2. Configure seus scripts (global e específicos).  
3. Reinicie o serviço para aplicar mudanças:
   ```bash
   sudo systemctl restart duplicati
   ```
4. Acesse `http://SEU_HOST:8200` (ou porta configurada) e crie seus jobs de backup.

---

## 📝 TO‑DO

- Unificar configurações (ex.: arquivo único `.conf` para scripts e serviço).  
- Melhorar documentação dos templates.
- Suporte a múltiplos scripts por job de forma padronizada.

---
