#!/bin/bash

cd /root/duplicati-scripts || exit 1
# Por padrão executa todos os scripts em ./global_scripts/ e ./global_scripts/after/
for script in ./global_scripts/*.sh; do
    [ -x "$script" ] || continue
    exec "$script"
done

for script in ./global_scripts/after/*.sh; do
    [ -x "$script" ] || continue
    exec "$script"
done

# O recomendado caso queira adicionar um novo script é adicionar ele em uma das pastas anteriores
# Mas caso necessário você pode executar qualquer script que deseja

#exec /path/to/your/script.sh