#! /bin/zsh
export KUBECONFIG=
export K8S_CLUSTER=
export K8S_NAMESPACE=


function ks {
  if [[ "$2" ]]; then
    local ns="$2"
    local cl="$1"
  else
    local ns="$1"
    local cl="${KUBECONFIG#*/config+}" && local cl="${cl%%+*}"
  fi

  [[ -z "$cl" ]] && echo "err: missing cluster." >&2 && return 2

  cfg="${HOME}/.kube/config+${cl}+${ns}"

  if [[ ! -e "$cfg" ]]; then
    [[ ! -e "${cfg%+*}+default" ]] &&
      echo "err: unregistered cluster." >&2 && return 1


    cp "$HOME/.kube/config+${cl}+default" \
      "$HOME/.kube/config+${cl}+${ns}" &&
    kubectl --kubeconfig "$cfg" \
      config set-context --current --namespace "${ns}" ||
     {
       echo "err: add namespace failed." >&2
       return 1
     }
  fi

  export KUBECONFIG="$cfg"
  export K8S_CLUSTER="$cl"
  export K8S_NAMESPACE="$ns"
}

_ks () {

  local i cluster=

  [[ "$K8S_CLUSTER" ]] && local cluster="${K8S_CLUSTER}"
  [[ "${words[2]}" ]] && local cluster="${words[2]}"

  declare -al __cl=( $(
    for i in ~/.kube/config+*+*; do
      IFS=+ read -r _ cl _ <<< "$i" && [[ "$cl" != "$cluster" ]] && echo "$cl"
    done
  ) )

  declare -al __ns=( $(
   for i in ~/.kube/config+*+*; do
      IFS=+ read -r _ cl ns <<< "$i"
      [[ "$cluster" ]] || continue
      [[ "$cl" == "$cluster" ]] && echo "$ns"
    done
  ) )

  declare -al __all=( "${__cl[@]}" "${__ns[@]}" )

  _arguments \
    "1: :{_describe 'cluster/namespace' __all}" \
    "2: :{_describe 'namespace' __ns}"
}

compdef _ks ks
