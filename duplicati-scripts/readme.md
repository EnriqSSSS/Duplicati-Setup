## Estrutura de Scripts do Duplicati

Este diretório **`duplicati-scripts/`** centraliza todos os scripts utilizados pelas tarefas de backup do Duplicati. Espera-se, por padrão, que ele esteja localizado em **`/root/duplicati-scripts/`**.

---

### Conteúdo Padrão

```text
duplicati-scripts/
├── after_backup_global.sh
├── before_backup_global.sh
├── global_scripts/
│   ├── after/
│   └── before/
└── <example>_scripts/
    ├── after/
    └── before/
```

* **./after\_backup\_global.sh**: Chama todos os scripts em `./global_scripts/` *após* a conclusão de qualquer trabalho de backup.
* **./before\_backup\_global.sh**: Chama todos os scripts em `./global_scripts/` *antes* de iniciar qualquer trabalho de backup.
* **./global\_scripts/**: Scripts comuns a todos os jobs, subdivididos em:

  * `./global_scripts/before/`: executados antes dos backups.
  * `./global_scripts/after/`: executados após os backups.
  * se um script deve rodar nos dois momentos, coloque-o diretamente em `./global_scripts/`.
* **./\<example>\_scripts/**: Template para scripts específicos de um backup. Veja detalhes abaixo.

---

## Como Criar Scripts para um Job Específico

1. Copie a pasta `./<example>_scripts/` e renomeie, trocando `<example>` pelo nome do trabalho de backup.
2. Dentro dela, ajuste:

   * Nome da pasta e dos arquivos.
   * Shebang e metadados no topo de cada `.sh`.
3. Adicione seu script em um destes diretórios:

   * `./<example>_scripts/before/` para ações *pré-backup*.
   * `./<example>_scripts/after/` para ações *pós-backup*.
4. Configure o Duplicati para usar os scripts locais:

   ```sh
   --run-script-before=/root/duplicati-scripts/<example>_scripts/before_backup_<example>.sh
   --run-script-after=/root/duplicati-scripts/<example>_scripts/after_backup_<example>.sh
   ```

> **Importante**: Os scripts globais são executador antes dos scripts locais. Caso deseje que os locais subistituam os globais, vai ser necessário editar os scripts presentes em `./<example>_scripts/`.

---

## Permissões e Propriedade

Antes de utilizar, defina permissão e dono adequados:

```bash
chmod -R 775 /root/duplicati-scripts/
chown -R root:sudo /root/duplicati-scripts/
```

Isso garante que o Duplicati (e o usuário `root`) consiga ler e executar todos os arquivos.

---

## Boas Práticas

* **Shebang**: Sempre inclua `#!/bin/bash` (ou shell de sua preferência) na primeira linha.
* **Permissões**: Confirme `chmod +x` em cada script.
* **Formato**: Use quebras de linha Unix (LF).