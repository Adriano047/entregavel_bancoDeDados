# Sistema de Banco de Dados

Este projeto utiliza um banco de dados para gerenciar uma biblioteca, permitindo o cadastro de usuários, livros e exemplares, além do controle de empréstimos e multas.

O sistema diferencia um **livro** de seus **exemplares físicos**. Um livro pode possuir vários exemplares, e cada exemplar pode ser emprestado diversas vezes ao longo do tempo. Os empréstimos são registrados para manter o histórico de retiradas e devoluções, enquanto as multas registram atrasos nas devoluções.

## Entidades

### Usuario

Representa as pessoas cadastradas no sistema que podem realizar empréstimos.

* `id` **(PK)** — Identificador único do usuário.
* `foto` — Foto do usuário.
* `cpf` — CPF do usuário.
* `email` — E-mail utilizado pelo usuário.
* `senha` — Senha de acesso ao sistema.
* `anoNascimento` — Ano de nascimento do usuário.

**Relacionamento:**

Um usuário pode realizar vários empréstimos.

```text
Usuario 1 ───── N Emprestimo
```

---

### Livro

Representa uma obra literária. O livro não representa uma cópia física específica, mas sim a obra que pode possuir vários exemplares.

* `id` **(PK)** — Identificador único do livro.
* `titulo` — Título da obra.
* `autor` — Autor da obra.
* `isbn` — ISBN do livro.
* `dataPublicacao` — Data de publicação da obra.
* `quantidadeDisponivel` — Quantidade de exemplares disponíveis para empréstimo.

**Relacionamento:**

Um livro pode possuir vários exemplares, enquanto cada exemplar pertence a um único livro.

```text
Livro 1 ───── N Exemplar
```

---

### Exemplar

Representa uma cópia física específica de um livro.

* `id` **(PK)** — Identificador único do exemplar.
* `livro` **(FK)** — Referência ao livro ao qual o exemplar pertence.
* `codigo` — Código único utilizado para identificar o exemplar.
* `statusEmprestimo` — Situação atual do exemplar, como disponível ou emprestado.

**Relacionamento:**

Cada exemplar pertence a um único livro e pode participar de vários empréstimos ao longo do tempo.

```text
Exemplar N ───── 1 Livro
Exemplar 1 ───── N ItemEmprestimo
```

O `statusEmprestimo` representa a situação **atual** do exemplar. O histórico dos empréstimos é mantido pelas entidades `ItemEmprestimo` e `Emprestimo`.

---

### Emprestimo

Representa uma operação de empréstimo realizada por um usuário.

* `id` **(PK)** — Identificador único do empréstimo.
* `usuario` **(FK)** — Usuário responsável pelo empréstimo.
* `dataEmprestimo` — Data em que o empréstimo foi realizado.
* `dataPrevistaDevolucao` — Data limite para a devolução.
* `dataDevolucao` — Data em que o empréstimo foi efetivamente devolvido. Pode permanecer vazia enquanto o empréstimo estiver ativo.

**Relacionamento:**

Um usuário pode possuir vários empréstimos.

Um empréstimo pode possuir vários itens de empréstimo.

```text
Usuario 1 ───── N Emprestimo
Emprestimo 1 ───── N ItemEmprestimo
```

---

### ItemEmprestimo

Representa cada exemplar incluído em um empréstimo.

Essa entidade é necessária porque um único empréstimo pode conter vários exemplares.

* `id` **(PK)** — Identificador único do item.
* `emprestimo` **(FK)** — Referência ao empréstimo ao qual o item pertence.
* `exemplar` **(FK)** — Referência ao exemplar que foi emprestado.

Por exemplo, se um usuário retirar três exemplares de uma vez:

```text
Emprestimo #10
│
├── ItemEmprestimo → Exemplar #01
├── ItemEmprestimo → Exemplar #05
└── ItemEmprestimo → Exemplar #08
```

Dessa forma, existe **um único empréstimo** contendo vários exemplares.

**Relacionamentos:**

```text
Emprestimo 1 ───── N ItemEmprestimo
Exemplar   1 ───── N ItemEmprestimo
```

Um exemplar pode aparecer em vários itens de empréstimo ao longo de sua vida, pois pode ser emprestado novamente depois de ser devolvido.

---

### Multa

Representa uma multa gerada quando um empréstimo é devolvido após a data prevista.

* `id` **(PK)** — Identificador único da multa.
* `usuario` **(FK)** — Usuário responsável pela multa.
* `emprestimo` **(FK)** — Empréstimo que originou a multa.
* `valor` — Valor da multa.
* `dataMulta` — Data em que a multa foi registrada.

**Relacionamentos:**

Um usuário pode possuir várias multas.

Um empréstimo pode não gerar nenhuma multa ou pode gerar uma ou mais multas, dependendo das regras do sistema.

```text
Usuario    1 ─────  1:0..N Multa
Emprestimo 1 ─────  0..1 Multa
```

A multa pode ser identificada comparando `dataDevolucao` com `dataPrevistaDevolucao`:

```text
dataDevolucao > dataPrevistaDevolucao
        ↓
      atraso
        ↓
      multa
```

---

## Relacionamentos gerais

O modelo do sistema pode ser representado da seguinte forma:

```text
                         ┌──────────────┐
                         │    USUARIO   │
                         └──────┬───────┘
                                │
                    ┌───────────┴───────────┐
                  1:N                    1:0..N
                    │                       │
                    ▼                       ▼
             ┌──────────────┐       ┌──────────────┐
             │  EMPRESTIMO  │─ ─ ─ ─|     MULTA    │
             └──────┬───────┘   0..1└──────────────┘
                    │
                   1:N
                    │
                    ▼
           ┌──────────────────┐
           │ ITEM_EMPRESTIMO  │
           └────────┬─────────┘
                    │
                   N:1
                    │
                    ▼
             ┌──────────────┐
             │   EXEMPLAR   │
             └──────┬───────┘
                    │
                   N:1
                    │
                    ▼
             ┌──────────────┐
             │     LIVRO    │
             └──────────────┘
```

### Resumo das cardinalidades

| Relacionamento              | Cardinalidade |
| --------------------------- | ------------- |
| Usuario → Emprestimo        | **1:N**       |
| Livro → Exemplar            | **1:N**       |
| Emprestimo → ItemEmprestimo | **1:N**       |
| Exemplar → ItemEmprestimo   | **1:N**       |
| Usuario → Multa             | **1:N**       |
| Emprestimo → Multa          | **1:0..N**    |

## Chaves

As **PKs (Primary Keys)** identificam unicamente cada registro:

* `Usuario.id`
* `Livro.id`
* `Exemplar.id`
* `Emprestimo.id`
* `ItemEmprestimo.id`
* `Multa.id`

As **FKs (Foreign Keys)** estabelecem os relacionamentos entre as entidades:

* `Exemplar.livro` → `Livro.id`
* `Emprestimo.usuario` → `Usuario.id`
* `ItemEmprestimo.emprestimo` → `Emprestimo.id`
* `ItemEmprestimo.exemplar` → `Exemplar.id`
* `Multa.usuario` → `Usuario.id`
* `Multa.emprestimo` → `Emprestimo.id`
