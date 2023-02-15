# Conectar ao Azure Kubernetes Service (AKS) com Azure CLI

Script em shell que automatiza conexáo ao AKS no Azure usando a CLI do Azure. O script faz o download das configurações dos clusters AKS, define as configurações unificadas e atualiza os clusters AKS na CLI do Azure.

## Requisitos

- [Azure CLI](https://docs.microsoft.com/pt-br/cli/azure/install-azure-cli) instalada em seu computador.
- Credenciais de acesso ao Azure com permissão para acessar os recursos do AKS.

## Como usar

1. Clone o repositório para o seu computador: `git clone https://github.com/therenanlira/connect-aks.git`
2. Abra o terminal e navegue até o diretório onde o repositório foi clonado.
3. Execute o script `connect-aks.sh`: `./connect-aks.sh`
4. Siga as instruções exibidas no terminal para conectar-se ao AKS.

Para que o script seja executado automaticamente a cada semana, inclua-o no seu arquivo ````bash_rc```` ou ````bash_profile````, por exemplo:

    ```bash
    ...
    $HOME/connect-aks.sh
    ```
Se seus clusters AKS possuem a tag "sre", pode ser utilizado o script ````connect-aks-squad.sh```` que perguntará qual o nome de sua squad e conectará apenas nas que possuirem a tag "sre" com o nome informado.

## Contribuição

Sinta-se à vontade para contribuir com este projeto, enviando sugestões de melhoria ou correção de problemas. Para contribuir, siga as orientações do arquivo [CONTRIBUTING.md](CONTRIBUTING.md).

## Licença

Este projeto é licenciado sob a licença MIT - consulte o arquivo [LICENSE.md](LICENSE.md) para obter mais informações.
