#!/bin/bash

# Download contexts AKS
# Set unified config, azure cli will edit with the downloaded clusters configurations
# update Azure AKS clusters

AKS_CLUSTERDIR="${HOME}/.kube/azure"
AKS_KUBECONFIG="${AKS_CLUSTERDIR}/config"
AKS_LASTUPDATED="${AKS_CLUSTERDIR}/.lastupdate"
AKS_UPDATE_CLUSTERS=false

test -d "$AKS_CLUSTERDIR" || mkdir -p "$AKS_CLUSTERDIR"
test -f "$AKS_LASTUPDATED" || echo "0" > "$AKS_LASTUPDATED"
test -f "$AKS_KUBECONFIG" || touch "$AKS_KUBECONFIG" && chmod 600 "$AKS_KUBECONFIG"

export KUBECONFIG="$HOME/.kube/config:$AKS_KUBECONFIG"

if [ $(( $(date -u '+%s') - $(cat "$AKS_LASTUPDATED") )) -ge 604800 ]; then
  AKS_UPDATE_CLUSTERS=true
else
  AKS_UPDATE_CLUSTERS=false
fi

if [ $AKS_UPDATE_CLUSTERS == true ]; then
  if ! az account get-access-token &>/dev/null; then
    if ! az login --scope https://management.core.windows.net//.default &>/dev/null; then
      echo -e "✖️ Hm, parece que não foi possível logar na Azure, execute:\n    az login --scope https://management.core.windows.net//.default"
      exit 1
    else
      echo -e "✔️ Logado com sucesso na Azure"
    fi
  else
    echo -e "✔️ Já logado na Azure"
  fi 

  rm "${HOME}/.kube/azure/config" &>/dev/null
  echo -e "\n⏳ Conectando aos AKS\n"

  subs=($(az account list --query '[].id' -o tsv))
  
  for sub in "${subs[@]}"; do
    sub_name="$(az account show --subscription "$sub" --query 'name')"
    akss=($(az aks list --subscription "$sub" --query "[].{x: resourceGroup, y: name}" -o tsv))

    if [[ -n "$akss" ]]; then
      for aksnum in $( seq 0 2 $((${#akss[@]} - 1)) ); do
        rg="${akss[$aksnum]}"
        aks="${akss[$((aksnum+1))]}"
        if az aks get-credentials --subscription "$sub" -a -g "$rg" -n "$aks" -f "$AKS_KUBECONFIG" --only-show-errors; then
          echo -e "  ✅ $aks"
        fi
      done
    fi
  done
  echo -e "\n😃 Conectado com sucesso!"
  date -u '+%s' > "$AKS_LASTUPDATED"
fi
