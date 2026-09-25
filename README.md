# Teste Técnico Delphi - Cartsys

Aplicação desenvolvida em Delphi para o teste técnico da Cartsys.

O projeto implementa autenticação com senha e TOTP, controle de bloqueio de usuários, cadastro e consulta de clientes, integração com ViaCEP e emissão de relatório utilizando ReportBuilder.

---

## 1. Tecnologias utilizadas

- Delphi / VCL
- FireDAC
- Firebird 3
- Firebird 3 Embedded
- ReportBuilder
- BCrypt
- TOTP
- QR Code
- ViaCEP

---

## 2. Estrutura do projeto

```text
Cartsys/
├── Controller/
│   ├── ClienteController.pas
│   ├── LoginController.pas
│   └── UsuarioController.pas
│
├── Data/
│   ├── DatabaseDataModule.pas
│   ├── DatabaseDataModule.dfm
│   │
│   ├── Repository/
│   │   ├── CidadeRepository.pas
│   │   ├── ClienteRepository.pas
│   │   └── UsuarioRepository.pas
│   │
│   └── Seed/
│       └── DatabaseSeed.pas
│
├── Lib/
│   ├── Base32U.pas
│   ├── Bcrypt.pas
│   ├── DelphiZXIngQRCode.pas
│   └── GoogleOTP.pas
│
├── Model/
│   ├── ClienteModel.pas
│   ├── EnderecoModel.pas
│   └── UsuarioModel.pas
│
├── Service/
│   ├── AuthorizationService.pas
│   ├── ClienteService.pas
│   ├── PasswordService.pas
│   ├── TotpService.pas
│   ├── UsuarioService.pas
│   └── ViaCepService.pas
│
├── View/
│   ├── AuthenticatorView.pas
│   ├── ClienteCadastroView.pas
│   ├── ClienteRelatorioView.pas
│   ├── ClienteView.pas
│   ├── LoginView.pas
│   ├── MainView.pas
│   └── UsuarioBloqueioView.pas
│
├── database/
│   ├── 01_schema.sql
│   └── CARTSYS.FDB
│
├── runtime/
│   └── fbclient.dll
│
├── Executável/
│   ├── TesteDelphiCartsys.exe
│   ├── fbclient.dll
│   ├── firebird.conf
│   ├── firebird.msg
│   ├── icudt52.dll
│   ├── icudt52l.dat
│   ├── icuin52.dll
│   ├── icuuc52.dll
│   ├── msvcp100.dll
│   ├── msvcr100.dll
│   │
│   ├── plugins/
│   │   └── engine12.dll
│   │
│   └── database/
│       └── CARTSYS.FDB
│
├── README.md
├── TesteDelphiCartsys.dpr
└── TesteDelphiCartsys.dproj
```

---

## 3. Arquitetura

O projeto foi organizado separando as responsabilidades em camadas:

### Model

Contém as entidades utilizadas pela aplicação:

- `Usuario`
- `Cliente`
- `Endereco`

### Repository

Responsável pelo acesso aos dados através do FireDAC.

As consultas SQL e operações de persistência ficam concentradas nesta camada.

### Service

Responsável pelas regras de negócio da aplicação, incluindo:

- autenticação;
- validação de senha;
- TOTP;
- autorização;
- regras relacionadas aos clientes;
- integração com ViaCEP.

### Controller

Realiza a comunicação entre as Views e os Services.

### View

Contém os formulários VCL responsáveis pela interface com o usuário.

---

## 4. Banco de dados

O projeto utiliza **Firebird 3**.

O banco utilizado pela aplicação está disponível em:

```text
database/CARTSYS.FDB
```

O script utilizado para criação da estrutura também está disponível:

```text
database/01_schema.sql
```

A versão pronta para execução possui uma cópia do banco em:

```text
Executável/database/CARTSYS.FDB
```

A aplicação utiliza caminho relativo ao diretório do executável, evitando dependência de caminhos específicos da máquina utilizada durante o desenvolvimento.

---

## 5. Firebird Embedded

A versão disponível na pasta `Executável` utiliza **Firebird 3 Embedded**.

Com isso, não é necessário instalar, configurar ou iniciar um servidor Firebird para executar a versão entregue da aplicação.

O acesso ao banco é realizado localmente utilizando o `fbclient.dll` e o engine Embedded distribuídos junto ao executável.

Os principais componentes do runtime estão em:

```text
Executável/
├── fbclient.dll
├── firebird.conf
├── firebird.msg
├── icudt52.dll
├── icudt52l.dat
├── icuin52.dll
├── icuuc52.dll
├── msvcp100.dll
├── msvcr100.dll
└── plugins/
    └── engine12.dll
```

O arquivo `firebird.conf` restringe o provider utilizado ao engine Embedded:

```ini
Providers = Engine12
```

---

## 6. Autenticação

A autenticação é realizada em duas etapas:

1. Login e senha.
2. Código TOTP.

As senhas são armazenadas utilizando hash **BCrypt**.

Após três tentativas inválidas de autenticação, o usuário é bloqueado.

Usuários bloqueados podem ser desbloqueados por um usuário administrador através da opção disponível no menu principal.

---

## 7. Autenticação TOTP

A aplicação utiliza autenticação TOTP compatível com aplicativos autenticadores.

No primeiro acesso de um usuário que ainda não possui uma chave TOTP configurada:

1. uma chave é gerada;
2. um QR Code é apresentado;
3. o usuário adiciona a conta ao aplicativo autenticador;
4. informa o código gerado;
5. somente após a validação do código a chave TOTP é persistida.

Os usuários entregues para avaliação estão sem uma chave TOTP previamente configurada, permitindo testar todo o fluxo de primeiro acesso.

---

## 8. Usuários para teste

### Administrador

```text
Login: admin01
Senha: Admin@123
```

### Usuário comum 1

```text
Login: usuario01
Senha: Usuario@123
```

### Usuário comum 2

```text
Login: usuario02
Senha: Usuario@123
```

Todos os usuários são entregues com:

```text
TOTP não configurado
Tentativas inválidas = 0
Usuário desbloqueado
```

Assim, qualquer um deles pode ser utilizado para testar o fluxo inicial de configuração do autenticador.

---

## 9. Bloqueio de usuários

Após três tentativas inválidas de autenticação, o usuário é bloqueado.

O administrador possui acesso à funcionalidade de gerenciamento de usuários bloqueados, permitindo realizar o desbloqueio.

Usuários comuns não possuem acesso a essa funcionalidade.

---

## 10. Cadastro de clientes

A aplicação permite:

- cadastrar clientes;
- alterar clientes;
- excluir clientes;
- consultar clientes;
- pesquisar clientes.

Os dados de endereço são associados ao cadastro do cliente.

A data de nascimento é opcional.

---

## 11. Clientes protegidos

Conforme definido no teste, os seguintes IDs possuem proteção contra alteração e exclusão:

```text
1
5
8
10
15
```

Esses clientes podem ser consultados normalmente, mas as operações protegidas são impedidas pela aplicação.

---

## 12. Integração com ViaCEP

No cadastro de clientes é possível consultar um CEP utilizando o serviço público ViaCEP.

A consulta pode preencher dados do endereço retornados pelo serviço, reduzindo a necessidade de preenchimento manual.

Serviço utilizado:

```text
https://viacep.com.br/
```

---

## 13. Navegação com Enter

Nos formulários de cadastro, a tecla **Enter** pode ser utilizada para avançar entre os campos, funcionando de forma semelhante à tecla **Tab**.

---

## 14. Relatórios

O relatório de clientes foi desenvolvido utilizando **ReportBuilder**.

Estão disponíveis filtros por:

- intervalo de IDs;
- cidade;
- estado.

O relatório também apresenta informações de paginação e data de emissão.

Durante o desenvolvimento foi utilizada a versão Trial do ReportBuilder.

Por esse motivo, dependendo do ambiente e da instalação utilizada para recompilar o projeto, podem ser exibidas mensagens ou identificações referentes à versão Trial do componente.

---

## 15. DevExpress

O enunciado solicita utilização de componentes DevExpress.

Durante o desenvolvimento foi verificada a compatibilidade da versão disponível do DevExpress VCL com o ambiente utilizado.

A instalação disponível do DevExpress VCL não oferece suporte ao **RAD Studio 13 Community Edition/Trial** utilizado para desenvolvimento deste teste, devido às limitações relacionadas aos pacotes e ferramentas de build disponíveis nessa edição.

Por esse motivo, a interface foi implementada utilizando componentes nativos da VCL.

Referências oficiais da DevExpress:

- https://docs.devexpress.com/VCL/403407/installation/rad-studio-community-edition
- https://docs.devexpress.com/VCL/403406/installation/rad-studio-trial-edition

---

## 16. Bibliotecas externas

### DelphiOTP

Utilizada para geração e validação de códigos TOTP.

Arquivos utilizados:

```text
Lib/GoogleOTP.pas
Lib/Base32U.pas
```

Projeto:

```text
https://github.com/wendelb/DelphiOTP
```

### BCrypt

Utilizada para geração e validação do hash das senhas.

Arquivo:

```text
Lib/Bcrypt.pas
```

### DelphiZXingQRCode

Utilizada para geração do QR Code apresentado durante a configuração do TOTP.

Arquivo:

```text
Lib/DelphiZXIngQRCode.pas
```

### ReportBuilder

Utilizado para geração do relatório de clientes.

A versão Trial foi utilizada durante o desenvolvimento.

---

## 17. Execução da versão pronta

A versão pronta para avaliação está disponível em:

```text
Executável/
```

Para executar a aplicação, utilize:

```text
Executável/TesteDelphiCartsys.exe
```

Não é necessário instalar ou configurar um servidor Firebird.

A pasta `Executável` deve ser mantida com sua estrutura original, pois contém:

- executável da aplicação;
- runtime do Firebird 3 Embedded;
- plugins necessários;
- banco de dados utilizado pela aplicação.

O banco utilizado por essa versão está em:

```text
Executável/database/CARTSYS.FDB
```

### Observação

A versão distribuída é **Win32** e os componentes do Firebird Embedded incluídos na pasta `Executável` correspondem a essa arquitetura.

---

## 18. Execução pelo código-fonte

O projeto principal é:

```text
TesteDelphiCartsys.dproj
```

Ao executar diretamente pelo Delphi, a aplicação procura os arquivos do runtime e o banco de dados relativamente ao diretório onde o executável compilado foi gerado.

Portanto, para executar a aplicação a partir de outro diretório de saída, esse diretório deve conter a mesma estrutura necessária:

```text
<diretório do executável>/
├── fbclient.dll
├── firebird.conf
├── firebird.msg
├── icudt52.dll
├── icudt52l.dat
├── icuin52.dll
├── icuuc52.dll
├── msvcp100.dll
├── msvcr100.dll
├── plugins/
│   └── engine12.dll
└── database/
    └── CARTSYS.FDB
```

Para uma avaliação direta, recomenda-se utilizar a versão já preparada na pasta:

```text
Executável/
```

---

## 19. Observações sobre a entrega

A pasta `Executável` foi preparada para permitir a execução da aplicação sem depender:

- de caminhos absolutos da máquina de desenvolvimento;
- da instalação de um servidor Firebird;
- da senha do usuário `SYSDBA` de uma instalação externa;
- de configuração manual da conexão com o banco.

O banco e o runtime necessários acompanham a aplicação.

Os usuários de teste são entregues sem configuração TOTP para permitir que o avaliador execute o fluxo completo de primeiro acesso.