#!/bin/bash

# Ativar autocompletar para nomes de arquivos
shopt -s progcomp

# Autocompletar
_autocomplete() {
    local cur=${COMP_WORDS[COMP_CWORD]}
    COMPREPLY=( $(compgen -f -- "$cur") )
}

# Atribuir a função de autocompletar ao comando read
complete -F _autocomplete read

# Pedir o nome do arquivo de biblioteca
read -e -p "Digite o nome do arquivo de biblioteca: " input_biblio

# Pedir a referência a ser usada
read -e -p "Digite a referência a ser usada: " referencia

# Pedir o nome de saída
read -e -p "Digite o nome do arquivo de saída: " saida

# Preparar biblioteca para blast
makeblastdb -in "$input_biblio" -dbtype nucl

# Executar o blastn
blastn -task blastn -outfmt 6 -db "$input_biblio" -query "$referencia" -out "$saida" -evalue 1e-5

# Extrair reads do output:
cat  "$saida" | awk '{print $2}' | sort -u >  output_reads_extraidos

# Retirada dos reads:
seqtk subseq "$input_biblio" output_reads_extraidos > reads_extraidos.fasta
