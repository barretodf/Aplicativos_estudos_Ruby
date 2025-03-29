# LinkSaver - Gerenciador de Contatos

LinkSaver é um aplicativo de linha de comando simples e eficiente para gerenciar contatos pessoais. Construído em Ruby com Rails, ele permite adicionar, listar, buscar, editar, deletar e exportar contatos para CSV, tudo com uma interface colorida no terminal.

## Recursos
- Adicionar contatos com nome, telefone (opcional) e e-mail (opcional).
- Listar todos os contatos em ordem alfabética.
- Buscar contatos por nome, telefone ou e-mail.
- Editar contatos existentes.
- Deletar contatos com confirmação.
- Exportar contatos para um arquivo CSV com nome personalizável e data.
- Interface colorida: sucessos em verde, erros em vermelho, avisos em amarelo e informações em ciano.

## Pré-requisitos
- Ruby 3.3.0 ou superior
- Rails 7.x
- SQLite3 (banco de dados padrão)
- Um terminal (ex.: Git Bash no Windows)

## Instalação
1. Clone o repositório:
   ```bash
   git clone https://github.com/seu-usuario/linksaver.git
   cd linksaver

   Instale as dependências:
   bundle install

   Configure o banco de dados:
   bin/rails db:create
   bin/rails db:migrate

   Uso:
   Execute o programa:
   bin/menu

#    Escolha uma opção de 1 a 7 no menu:
#     1: Adicionar um novo contato.
#     2: Listar todos os contatos.
#     3: Buscar um contato.
#     4: Editar um contato existente.
#     5: Deletar um contato.
#     6: Exportar contatos para CSV.
#     7: Sair do programa.

Status
Em desenvolvimento ativo. Recursos implementados até Março de 2025:

CRUD completo de contatos.
Exportação para CSV com nome personalizável.
Interface colorida no terminal.
Tratamento robusto de erros.