# Copyright 2016 The Kubernetes Authors All rights reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

__kubectl_bash_source() {
	alias shopt=':'
	alias _expand=_bash_expand
	alias _complete=_bash_comp
	emulate -L sh
	setopt kshglob noshglob braceexpand

	source "$@"
}

__kubectl_type() {
	# -t is not supported by zsh
	if [ "$1" == "-t" ]; then
		shift

		# fake Bash 4 to disable "complete -o nospace". Instead
		# "compopt +-o nospace" is used in the code to toggle trailing
		# spaces. We don't support that, but leave trailing spaces on
		# all the time
		if [ "$1" = "__kubectl_compopt" ]; then
			echo builtin
			return 0
		fi
	fi
	type "$@"
}

__kubectl_compgen() {
	local completions w
	completions=( $(compgen "$@") ) || return $?

	# filter by given word as prefix
	while [[ "$1" = -* && "$1" != -- ]]; do
		shift
		shift
	done
	if [[ "$1" == -- ]]; then
		shift
	fi
	for w in "${completions[@]}"; do
		if [[ "${w}" = "$1"* ]]; then
			echo "${w}"
		fi
	done
}

__kubectl_compopt() {
	true # don't do anything. Not supported by bashcompinit in zsh
}

__kubectl_declare() {
	if [ "$1" == "-F" ]; then
		whence -w "$@"
	else
		builtin declare "$@"
	fi
}

__kubectl_ltrim_colon_completions()
{
	if [[ "$1" == *:* && "$COMP_WORDBREAKS" == *:* ]]; then
		# Remove colon-word prefix from COMPREPLY items
		local colon_word=${1%${1##*:}}
		local i=${#COMPREPLY[*]}
		while [[ $((--i)) -ge 0 ]]; do
			COMPREPLY[$i]=${COMPREPLY[$i]#"$colon_word"}
		done
	fi
}

__kubectl_get_comp_words_by_ref() {
	cur="${COMP_WORDS[COMP_CWORD]}"
	prev="${COMP_WORDS[${COMP_CWORD}-1]}"
	words=("${COMP_WORDS[@]}")
	cword=("${COMP_CWORD[@]}")
}

__kubectl_filedir() {
	local RET OLD_IFS w qw

	__debug "_filedir $@ cur=$cur"
	if [[ "$1" = \~* ]]; then
		# somehow does not work. Maybe, zsh does not call this at all
		eval echo "$1"
		return 0
	fi

	OLD_IFS="$IFS"
	IFS=$'\n'
	if [ "$1" = "-d" ]; then
		shift
		RET=( $(compgen -d) )
	else
		RET=( $(compgen -f) )
	fi
	IFS="$OLD_IFS"

	IFS="," __debug "RET=${RET[@]} len=${#RET[@]}"

	for w in ${RET[@]}; do
		if [[ ! "${w}" = "${cur}"* ]]; then
			continue
		fi
		if eval "[[ \"\${w}\" = *.$1 || -d \"\${w}\" ]]"; then
			qw="$(__kubectl_quote "${w}")"
			if [ -d "${w}" ]; then
				COMPREPLY+=("${qw}/")
			else
				COMPREPLY+=("${qw}")
			fi
		fi
	done
}

__kubectl_quote() {
    if [[ $1 == \'* || $1 == \"* ]]; then
        # Leave out first character
        printf %q "${1:1}"
    else
    	printf %q "$1"
    fi
}

autoload -U +X compinit && compinit
autoload -U +X bashcompinit && bashcompinit

# use word boundary patterns for BSD or GNU sed
LWORD='[[:<:]]'
RWORD='[[:>:]]'
if sed --help 2>&1 | grep -q GNU; then
	LWORD='\<'
	RWORD='\>'
fi

__kubectl_bash_source <(sed \
	-e 's/declare -F/whence -w/' \
	-e 's/local \([a-zA-Z0-9_]*\)=/local \1; \1=/' \
	-e 's/flags+=("\(--.*\)=")/flags+=("\1"); two_word_flags+=("\1")/' \
	-e 's/must_have_one_flag+=("\(--.*\)=")/must_have_one_flag+=("\1")/' \
	-e "s/${LWORD}_filedir${RWORD}/__kubectl_filedir/g" \
	-e "s/${LWORD}_get_comp_words_by_ref${RWORD}/__kubectl_get_comp_words_by_ref/g" \
	-e "s/${LWORD}__ltrim_colon_completions${RWORD}/__kubectl_ltrim_colon_completions/g" \
	-e "s/${LWORD}compgen${RWORD}/__kubectl_compgen/g" \
	-e "s/${LWORD}compopt${RWORD}/__kubectl_compopt/g" \
	-e "s/${LWORD}declare${RWORD}/__kubectl_declare/g" \
	-e "s/\\\$(type${RWORD}/\$(__kubectl_type/g" \
	<<'BASH_COMPLETION_EOF'
# bash completion for kubectl                              -*- shell-script -*-

__debug()
{
    if [[ -n ${BASH_COMP_DEBUG_FILE} ]]; then
        echo "$*" >> "${BASH_COMP_DEBUG_FILE}"
    fi
}

# Homebrew on Macs have version 1.3 of bash-completion which doesn't include
# _init_completion. This is a very minimal version of that function.
__my_init_completion()
{
    COMPREPLY=()
    _get_comp_words_by_ref "$@" cur prev words cword
}

__index_of_word()
{
    local w word=$1
    shift
    index=0
    for w in "$@"; do
        [[ $w = "$word" ]] && return
        index=$((index+1))
    done
    index=-1
}

__contains_word()
{
    local w word=$1; shift
    for w in "$@"; do
        [[ $w = "$word" ]] && return
    done
    return 1
}

__handle_reply()
{
    __debug "${FUNCNAME[0]}"
    case $cur in
        -*)
            if [[ $(type -t compopt) = "builtin" ]]; then
                compopt -o nospace
            fi
            local allflags
            if [ ${#must_have_one_flag[@]} -ne 0 ]; then
                allflags=("${must_have_one_flag[@]}")
            else
                allflags=("${flags[*]} ${two_word_flags[*]}")
            fi
            COMPREPLY=( $(compgen -W "${allflags[*]}" -- "$cur") )
            if [[ $(type -t compopt) = "builtin" ]]; then
                [[ "${COMPREPLY[0]}" == *= ]] || compopt +o nospace
            fi

            # complete after --flag=abc
            if [[ $cur == *=* ]]; then
                if [[ $(type -t compopt) = "builtin" ]]; then
                    compopt +o nospace
                fi

                local index flag
                flag="${cur%%=*}"
                __index_of_word "${flag}" "${flags_with_completion[@]}"
                if [[ ${index} -ge 0 ]]; then
                    COMPREPLY=()
                    PREFIX=""
                    cur="${cur#*=}"
                    ${flags_completion[${index}]}
                    if [ -n "${ZSH_VERSION}" ]; then
                        # zfs completion needs --flag= prefix
                        eval "COMPREPLY=( \"\${COMPREPLY[@]/#/${flag}=}\" )"
                    fi
                fi
            fi
            return 0;
            ;;
    esac

    # check if we are handling a flag with special work handling
    local index
    __index_of_word "${prev}" "${flags_with_completion[@]}"
    if [[ ${index} -ge 0 ]]; then
        ${flags_completion[${index}]}
        return
    fi

    # we are parsing a flag and don't have a special handler, no completion
    if [[ ${cur} != "${words[cword]}" ]]; then
        return
    fi

    local completions
    if [[ ${#must_have_one_flag[@]} -ne 0 ]]; then
        completions=("${must_have_one_flag[@]}")
    elif [[ ${#must_have_one_noun[@]} -ne 0 ]]; then
        completions=("${must_have_one_noun[@]}")
    else
        completions=("${commands[@]}")
    fi
    COMPREPLY=( $(compgen -W "${completions[*]}" -- "$cur") )

    if [[ ${#COMPREPLY[@]} -eq 0 && ${#noun_aliases[@]} -gt 0 && ${#must_have_one_noun[@]} -ne 0 ]]; then
        COMPREPLY=( $(compgen -W "${noun_aliases[*]}" -- "$cur") )
    fi

    if [[ ${#COMPREPLY[@]} -eq 0 ]]; then
        declare -F __custom_func >/dev/null && __custom_func
    fi

    __ltrim_colon_completions "$cur"
}

# The arguments should be in the form "ext1|ext2|extn"
__handle_filename_extension_flag()
{
    local ext="$1"
    _filedir "@(${ext})"
}

__handle_subdirs_in_dir_flag()
{
    local dir="$1"
    pushd "${dir}" >/dev/null 2>&1 && _filedir -d && popd >/dev/null 2>&1
}

__handle_flag()
{
    __debug "${FUNCNAME[0]}: c is $c words[c] is ${words[c]}"

    # if a command required a flag, and we found it, unset must_have_one_flag()
    local flagname=${words[c]}
    local flagvalue
    # if the word contained an =
    if [[ ${words[c]} == *"="* ]]; then
        flagvalue=${flagname#*=} # take in as flagvalue after the =
        flagname=${flagname%%=*} # strip everything after the =
        flagname="${flagname}=" # but put the = back
    fi
    __debug "${FUNCNAME[0]}: looking for ${flagname}"
    if __contains_word "${flagname}" "${must_have_one_flag[@]}"; then
        must_have_one_flag=()
    fi

    # keep flag value with flagname as flaghash
    if [ -n "${flagvalue}" ] ; then
        flaghash[${flagname}]=${flagvalue}
    elif [ -n "${words[ $((c+1)) ]}" ] ; then
        flaghash[${flagname}]=${words[ $((c+1)) ]}
    else
        flaghash[${flagname}]="true" # pad "true" for bool flag
    fi

    # skip the argument to a two word flag
    if __contains_word "${words[c]}" "${two_word_flags[@]}"; then
        c=$((c+1))
        # if we are looking for a flags value, don't show commands
        if [[ $c -eq $cword ]]; then
            commands=()
        fi
    fi

    c=$((c+1))

}

__handle_noun()
{
    __debug "${FUNCNAME[0]}: c is $c words[c] is ${words[c]}"

    if __contains_word "${words[c]}" "${must_have_one_noun[@]}"; then
        must_have_one_noun=()
    elif __contains_word "${words[c]}" "${noun_aliases[@]}"; then
        must_have_one_noun=()
    fi

    nouns+=("${words[c]}")
    c=$((c+1))
}

__handle_command()
{
    __debug "${FUNCNAME[0]}: c is $c words[c] is ${words[c]}"

    local next_command
    if [[ -n ${last_command} ]]; then
        next_command="_${last_command}_${words[c]//:/__}"
    else
        if [[ $c -eq 0 ]]; then
            next_command="_$(basename "${words[c]//:/__}")"
        else
            next_command="_${words[c]//:/__}"
        fi
    fi
    c=$((c+1))
    __debug "${FUNCNAME[0]}: looking for ${next_command}"
    declare -F $next_command >/dev/null && $next_command
}

__handle_word()
{
    if [[ $c -ge $cword ]]; then
        __handle_reply
        return
    fi
    __debug "${FUNCNAME[0]}: c is $c words[c] is ${words[c]}"
    if [[ "${words[c]}" == -* ]]; then
        __handle_flag
    elif __contains_word "${words[c]}" "${commands[@]}"; then
        __handle_command
    elif [[ $c -eq 0 ]] && __contains_word "$(basename "${words[c]}")" "${commands[@]}"; then
        __handle_command
    else
        __handle_noun
    fi
    __handle_word
}

# call kubectl get $1,
__kubectl_namespace_flag()
{
    local ret two_word_ns
    ret=""
    two_word_ns=false
    for w in "${words[@]}"; do
        if [ "$two_word_ns" = true ]; then
            ret="--namespace=${w}"
            two_word_ns=false
            continue
        fi
        case "${w}" in
            --namespace=*)
                ret=${w}
                ;;
            --namespace)
                two_word_ns=true
                ;;
            --all-namespaces)
                ret=${w}
                ;;
        esac
    done
    echo $ret
}

__kubectl_get_namespaces()
{
    local template kubectl_out
    template="{{ range .items  }}{{ .metadata.name }} {{ end }}"
    if kubectl_out=$(kubectl get -o template --template="${template}" namespace 2>/dev/null); then
        COMPREPLY=( $( compgen -W "${kubectl_out[*]}" -- "$cur" ) )
    fi
}

__kubectl_parse_get()
{
    local template
    template="{{ range .items  }}{{ .metadata.name }} {{ end }}"
    local kubectl_out
    if kubectl_out=$(kubectl get $(__kubectl_namespace_flag) -o template --template="${template}" "$1" 2>/dev/null); then
        COMPREPLY=( $( compgen -W "${kubectl_out[*]}" -- "$cur" ) )
    fi
}

__kubectl_get_resource()
{
    if [[ ${#nouns[@]} -eq 0 ]]; then
        return 1
    fi
    __kubectl_parse_get "${nouns[${#nouns[@]} -1]}"
}

__kubectl_get_resource_pod()
{
    __kubectl_parse_get "pod"
}

__kubectl_get_resource_rc()
{
    __kubectl_parse_get "rc"
}

# $1 is the name of the pod we want to get the list of containers inside
__kubectl_get_containers()
{
    local template
    template="{{ range .spec.containers  }}{{ .name }} {{ end }}"
    __debug "${FUNCNAME} nouns are ${nouns[*]}"

    local len="${#nouns[@]}"
    if [[ ${len} -ne 1 ]]; then
        return
    fi
    local last=${nouns[${len} -1]}
    local kubectl_out
    if kubectl_out=$(kubectl get $(__kubectl_namespace_flag) -o template --template="${template}" pods "${last}" 2>/dev/null); then
        COMPREPLY=( $( compgen -W "${kubectl_out[*]}" -- "$cur" ) )
    fi
}

# Require both a pod and a container to be specified
__kubectl_require_pod_and_container()
{
    if [[ ${#nouns[@]} -eq 0 ]]; then
        __kubectl_parse_get pods
        return 0
    fi;
    __kubectl_get_containers
    return 0
}

__custom_func() {
    case ${last_command} in
        kubectl_get | kubectl_describe | kubectl_delete | kubectl_label | kubectl_stop | kubectl_edit | kubectl_patch |\
        kubectl_annotate | kubectl_expose)
            __kubectl_get_resource
            return
            ;;
        kubectl_logs)
            __kubectl_require_pod_and_container
            return
            ;;
        kubectl_exec)
            __kubectl_get_resource_pod
            return
            ;;
        kubectl_rolling-update)
            __kubectl_get_resource_rc
            return
            ;;
        *)
            ;;
    esac
}

_kubectl_get()
{
    last_command="kubectl_get"
    commands=()

    flags=()
    two_word_flags=()
    flags_with_completion=()
    flags_completion=()

    flags+=("--all-namespaces")
    flags+=("--export")
    flags+=("--filename=")
    flags_with_completion+=("--filename")
    flags_completion+=("__handle_filename_extension_flag json|yaml|yml")
    two_word_flags+=("-f")
    flags_with_completion+=("-f")
    flags_completion+=("__handle_filename_extension_flag json|yaml|yml")
    flags+=("--include-extended-apis")
    flags+=("--label-columns=")
    two_word_flags+=("-L")
    flags+=("--no-headers")
    flags+=("--output=")
    two_word_flags+=("-o")
    flags+=("--output-version=")
    flags+=("--recursive")
    flags+=("-R")
    flags+=("--selector=")
    two_word_flags+=("-l")
    flags+=("--show-all")
    flags+=("-a")
    flags+=("--show-labels")
    flags+=("--sort-by=")
    flags+=("--template=")
    flags_with_completion+=("--template")
    flags_completion+=("_filedir")
    flags+=("--watch")
    flags+=("-w")
    flags+=("--watch-only")
    flags+=("--alsologtostderr")
    flags+=("--api-version=")
    flags+=("--as=")
    flags+=("--certificate-authority=")
    flags+=("--client-certificate=")
    flags+=("--client-key=")
    flags+=("--cluster=")
    flags+=("--context=")
    flags+=("--insecure-skip-tls-verify")
    flags+=("--kubeconfig=")
    flags+=("--log-backtrace-at=")
    flags+=("--log-dir=")
    flags+=("--log-flush-frequency=")
    flags+=("--logtostderr")
    flags+=("--match-server-version")
    flags+=("--namespace=")
    flags_with_completion+=("--namespace")
    flags_completion+=("__kubectl_get_namespaces")
    flags+=("--password=")
    flags+=("--server=")
    two_word_flags+=("-s")
    flags+=("--stderrthreshold=")
    flags+=("--token=")
    flags+=("--user=")
    flags+=("--username=")
    flags+=("--v=")
    flags+=("--vmodule=")

    must_have_one_flag=()
    must_have_one_noun=()
    must_have_one_noun+=("cluster")
    must_have_one_noun+=("clusterrole")
    must_have_one_noun+=("clusterrolebinding")
    must_have_one_noun+=("componentstatus")
    must_have_one_noun+=("configmap")
    must_have_one_noun+=("daemonset")
    must_have_one_noun+=("deployment")
    must_have_one_noun+=("endpoints")
    must_have_one_noun+=("event")
    must_have_one_noun+=("horizontalpodautoscaler")
    must_have_one_noun+=("ingress")
    must_have_one_noun+=("job")
    must_have_one_noun+=("limitrange")
    must_have_one_noun+=("namespace")
    must_have_one_noun+=("networkpolicy")
    must_have_one_noun+=("node")
    must_have_one_noun+=("persistentvolume")
    must_have_one_noun+=("persistentvolumeclaim")
    must_have_one_noun+=("petset")
    must_have_one_noun+=("pod")
    must_have_one_noun+=("podsecuritypolicy")
    must_have_one_noun+=("podtemplate")
    must_have_one_noun+=("replicaset")
    must_have_one_noun+=("replicationcontroller")
    must_have_one_noun+=("resourcequota")
    must_have_one_noun+=("role")
    must_have_one_noun+=("rolebinding")
    must_have_one_noun+=("secret")
    must_have_one_noun+=("service")
    must_have_one_noun+=("serviceaccount")
    must_have_one_noun+=("thirdpartyresource")
    must_have_one_noun+=("thirdpartyresourcedata")
    noun_aliases=()
    noun_aliases+=("clusterrolebindings")
    noun_aliases+=("clusterroles")
    noun_aliases+=("clusters")
    noun_aliases+=("componentstatuses")
    noun_aliases+=("configmaps")
    noun_aliases+=("cs")
    noun_aliases+=("daemonsets")
    noun_aliases+=("deployments")
    noun_aliases+=("ds")
    noun_aliases+=("endpoints")
    noun_aliases+=("ep")
    noun_aliases+=("ev")
    noun_aliases+=("events")
    noun_aliases+=("horizontalpodautoscalers")
    noun_aliases+=("hpa")
    noun_aliases+=("ing")
    noun_aliases+=("ingresses")
    noun_aliases+=("jobs")
    noun_aliases+=("limitranges")
    noun_aliases+=("limits")
    noun_aliases+=("namespaces")
    noun_aliases+=("networkpolicies")
    noun_aliases+=("no")
    noun_aliases+=("nodes")
    noun_aliases+=("ns")
    noun_aliases+=("persistentvolumeclaims")
    noun_aliases+=("persistentvolumes")
    noun_aliases+=("petsets")
    noun_aliases+=("po")
    noun_aliases+=("pods")
    noun_aliases+=("podsecuritypolicies")
    noun_aliases+=("podtemplates")
    noun_aliases+=("pv")
    noun_aliases+=("pvc")
    noun_aliases+=("quota")
    noun_aliases+=("rc")
    noun_aliases+=("replicasets")
    noun_aliases+=("replicationcontrollers")
    noun_aliases+=("resourcequotas")
    noun_aliases+=("rolebindings")
    noun_aliases+=("roles")
    noun_aliases+=("rs")
    noun_aliases+=("sa")
    noun_aliases+=("secrets")
    noun_aliases+=("serviceaccounts")
    noun_aliases+=("services")
    noun_aliases+=("svc")
    noun_aliases+=("thirdpartyresourcedatas")
    noun_aliases+=("thirdpartyresources")
}

_kubectl_set_image()
{
    last_command="kubectl_set_image"
    commands=()

    flags=()
    two_word_flags=()
    flags_with_completion=()
    flags_completion=()

    flags+=("--all")
    flags+=("--filename=")
    flags_with_completion+=("--filename")
    flags_completion+=("__handle_filename_extension_flag json|yaml|yml")
    two_word_flags+=("-f")
    flags_with_completion+=("-f")
    flags_completion+=("__handle_filename_extension_flag json|yaml|yml")
    flags+=("--local")
    flags+=("--no-headers")
    flags+=("--output=")
    two_word_flags+=("-o")
    flags+=("--output-version=")
    flags+=("--record")
    flags+=("--recursive")
    flags+=("-R")
    flags+=("--selector=")
    two_word_flags+=("-l")
    flags+=("--show-all")
    flags+=("-a")
    flags+=("--show-labels")
    flags+=("--sort-by=")
    flags+=("--template=")
    flags_with_completion+=("--template")
    flags_completion+=("_filedir")
    flags+=("--alsologtostderr")
    flags+=("--api-version=")
    flags+=("--as=")
    flags+=("--certificate-authority=")
    flags+=("--client-certificate=")
    flags+=("--client-key=")
    flags+=("--cluster=")
    flags+=("--context=")
    flags+=("--insecure-skip-tls-verify")
    flags+=("--kubeconfig=")
    flags+=("--log-backtrace-at=")
    flags+=("--log-dir=")
    flags+=("--log-flush-frequency=")
    flags+=("--logtostderr")
    flags+=("--match-server-version")
    flags+=("--namespace=")
    flags_with_completion+=("--namespace")
    flags_completion+=("__kubectl_get_namespaces")
    flags+=("--password=")
    flags+=("--server=")
    two_word_flags+=("-s")
    flags+=("--stderrthreshold=")
    flags+=("--token=")
    flags+=("--user=")
    flags+=("--username=")
    flags+=("--v=")
    flags+=("--vmodule=")

    must_have_one_flag=()
    must_have_one_noun=()
    noun_aliases=()
}

_kubectl_set()
{
    last_command="kubectl_set"
    commands=()
    commands+=("image")

    flags=()
    two_word_flags=()
    flags_with_completion=()
    flags_completion=()

    flags+=("--alsologtostderr")
    flags+=("--api-version=")
    flags+=("--as=")
    flags+=("--certificate-authority=")
    flags+=("--client-certificate=")
    flags+=("--client-key=")
    flags+=("--cluster=")
    flags+=("--context=")
    flags+=("--insecure-skip-tls-verify")
    flags+=("--kubeconfig=")
    flags+=("--log-backtrace-at=")
    flags+=("--log-dir=")
    flags+=("--log-flush-frequency=")
    flags+=("--logtostderr")
    flags+=("--match-server-version")
    flags+=("--namespace=")
    flags_with_completion+=("--namespace")
    flags_completion+=("__kubectl_get_namespaces")
    flags+=("--password=")
    flags+=("--server=")
    two_word_flags+=("-s")
    flags+=("--stderrthreshold=")
    flags+=("--token=")
    flags+=("--user=")
    flags+=("--username=")
    flags+=("--v=")
    flags+=("--vmodule=")

    must_have_one_flag=()
    must_have_one_noun=()
    noun_aliases=()
}

_kubectl_describe()
{
    last_command="kubectl_describe"
    commands=()

    flags=()
    two_word_flags=()
    flags_with_completion=()
    flags_completion=()

    flags+=("--filename=")
    flags_with_completion+=("--filename")
    flags_completion+=("__handle_filename_extension_flag json|yaml|yml")
    two_word_flags+=("-f")
    flags_with_completion+=("-f")
    flags_completion+=("__handle_filename_extension_flag json|yaml|yml")
    flags+=("--include-extended-apis")
    flags+=("--recursive")
    flags+=("-R")
    flags+=("--selector=")
    two_word_flags+=("-l")
    flags+=("--show-events")
    flags+=("--alsologtostderr")
    flags+=("--api-version=")
    flags+=("--as=")
    flags+=("--certificate-authority=")
    flags+=("--client-certificate=")
    flags+=("--client-key=")
    flags+=("--cluster=")
    flags+=("--context=")
    flags+=("--insecure-skip-tls-verify")
    flags+=("--kubeconfig=")
    flags+=("--log-backtrace-at=")
    flags+=("--log-dir=")
    flags+=("--log-flush-frequency=")
    flags+=("--logtostderr")
    flags+=("--match-server-version")
    flags+=("--namespace=")
    flags_with_completion+=("--namespace")
    flags_completion+=("__kubectl_get_namespaces")
    flags+=("--password=")
    flags+=("--server=")
    two_word_flags+=("-s")
    flags+=("--stderrthreshold=")
    flags+=("--token=")
    flags+=("--user=")
    flags+=("--username=")
    flags+=("--v=")
    flags+=("--vmodule=")

    must_have_one_flag=()
    must_have_one_noun=()
    must_have_one_noun+=("configmap")
    must_have_one_noun+=("daemonset")
    must_have_one_noun+=("deployment")
    must_have_one_noun+=("endpoints")
    must_have_one_noun+=("horizontalpodautoscaler")
    must_have_one_noun+=("horizontalpodautoscaler")
    must_have_one_noun+=("ingress")
    must_have_one_noun+=("job")
    must_have_one_noun+=("job")
    must_have_one_noun+=("limitrange")
    must_have_one_noun+=("namespace")
    must_have_one_noun+=("networkpolicy")
    must_have_one_noun+=("node")
    must_have_one_noun+=("persistentvolume")
    must_have_one_noun+=("persistentvolumeclaim")
    must_have_one_noun+=("petset")
    must_have_one_noun+=("pod")
    must_have_one_noun+=("replicaset")
    must_have_one_noun+=("replicationcontroller")
    must_have_one_noun+=("resourcequota")
    must_have_one_noun+=("secret")
    must_have_one_noun+=("service")
    must_have_one_noun+=("serviceaccount")
    noun_aliases=()
    noun_aliases+=("configmaps")
    noun_aliases+=("daemonsets")
    noun_aliases+=("deployments")
    noun_aliases+=("ds")
    noun_aliases+=("endpoints")
    noun_aliases+=("ep")
    noun_aliases+=("horizontalpodautoscalers")
    noun_aliases+=("horizontalpodautoscalers")
    noun_aliases+=("hpa")
    noun_aliases+=("ing")
    noun_aliases+=("ingresses")
    noun_aliases+=("jobs")
    noun_aliases+=("jobs")
    noun_aliases+=("limitranges")
    noun_aliases+=("limits")
    noun_aliases+=("namespaces")
    noun_aliases+=("networkpolicies")
    noun_aliases+=("no")
    noun_aliases+=("nodes")
    noun_aliases+=("ns")
    noun_aliases+=("persistentvolumeclaims")
    noun_aliases+=("persistentvolumes")
    noun_aliases+=("petsets")
    noun_aliases+=("po")
    noun_aliases+=("pods")
    noun_aliases+=("pv")
    noun_aliases+=("pvc")
    noun_aliases+=("quota")
    noun_aliases+=("rc")
    noun_aliases+=("replicasets")
    noun_aliases+=("replicationcontrollers")
    noun_aliases+=("resourcequotas")
    noun_aliases+=("rs")
    noun_aliases+=("sa")
    noun_aliases+=("secrets")
    noun_aliases+=("serviceaccounts")
    noun_aliases+=("services")
    noun_aliases+=("svc")
}

_kubectl_create_namespace()
{
    last_command="kubectl_create_namespace"
    commands=()

    flags=()
    two_word_flags=()
    flags_with_completion=()
    flags_completion=()

    flags+=("--dry-run")
    flags+=("--generator=")
    flags+=("--no-headers")
    flags+=("--output=")
    two_word_flags+=("-o")
    flags+=("--output-version=")
    flags+=("--save-config")
    flags+=("--schema-cache-dir=")
    flags_with_completion+=("--schema-cache-dir")
    flags_completion+=("_filedir")
    flags+=("--show-all")
    flags+=("-a")
    flags+=("--show-labels")
    flags+=("--sort-by=")
    flags+=("--template=")
    flags_with_completion+=("--template")
    flags_completion+=("_filedir")
    flags+=("--validate")
    flags+=("--alsologtostderr")
    flags+=("--api-version=")
    flags+=("--as=")
    flags+=("--certificate-authority=")
    flags+=("--client-certificate=")
    flags+=("--client-key=")
    flags+=("--cluster=")
    flags+=("--context=")
    flags+=("--insecure-skip-tls-verify")
    flags+=("--kubeconfig=")
    flags+=("--log-backtrace-at=")
    flags+=("--log-dir=")
    flags+=("--log-flush-frequency=")
    flags+=("--logtostderr")
    flags+=("--match-server-version")
    flags+=("--namespace=")
    flags_with_completion+=("--namespace")
    flags_completion+=("__kubectl_get_namespaces")
    flags+=("--password=")
    flags+=("--server=")
    two_word_flags+=("-s")
    flags+=("--stderrthreshold=")
    flags+=("--token=")
    flags+=("--user=")
    flags+=("--username=")
    flags+=("--v=")
    flags+=("--vmodule=")

    must_have_one_flag=()
    must_have_one_noun=()
    noun_aliases=()
}

_kubectl_create_secret_docker-registry()
{
    last_command="kubectl_create_secret_docker-registry"
    commands=()

    flags=()
    two_word_flags=()
    flags_with_completion=()
    flags_completion=()

    flags+=("--docker-email=")
    flags+=("--docker-password=")
    flags+=("--docker-server=")
    flags+=("--docker-username=")
    flags+=("--dry-run")
    flags+=("--generator=")
    flags+=("--include-extended-apis")
    flags+=("--no-headers")
    flags+=("--output=")
    two_word_flags+=("-o")
    flags+=("--output-version=")
    flags+=("--save-config")
    flags+=("--schema-cache-dir=")
    flags_with_completion+=("--schema-cache-dir")
    flags_completion+=("_filedir")
    flags+=("--show-all")
    flags+=("-a")
    flags+=("--show-labels")
    flags+=("--sort-by=")
    flags+=("--template=")
    flags_with_completion+=("--template")
    flags_completion+=("_filedir")
    flags+=("--validate")
    flags+=("--alsologtostderr")
    flags+=("--api-version=")
    flags+=("--as=")
    flags+=("--certificate-authority=")
    flags+=("--client-certificate=")
    flags+=("--client-key=")
    flags+=("--cluster=")
    flags+=("--context=")
    flags+=("--insecure-skip-tls-verify")
    flags+=("--kubeconfig=")
    flags+=("--log-backtrace-at=")
    flags+=("--log-dir=")
    flags+=("--log-flush-frequency=")
    flags+=("--logtostderr")
    flags+=("--match-server-version")
    flags+=("--namespace=")
    flags_with_completion+=("--namespace")
    flags_completion+=("__kubectl_get_namespaces")
    flags+=("--password=")
    flags+=("--server=")
    two_word_flags+=("-s")
    flags+=("--stderrthreshold=")
    flags+=("--token=")
    flags+=("--user=")
    flags+=("--username=")
    flags+=("--v=")
    flags+=("--vmodule=")

    must_have_one_flag=()
    must_have_one_flag+=("--docker-email=")
    must_have_one_flag+=("--docker-password=")
    must_have_one_flag+=("--docker-username=")
    must_have_one_noun=()
    noun_aliases=()
}

_kubectl_create_secret_tls()
{
    last_command="kubectl_create_secret_tls"
    commands=()

    flags=()
    two_word_flags=()
    flags_with_completion=()
    flags_completion=()

    flags+=("--cert=")
    flags+=("--dry-run")
    flags+=("--generator=")
    flags+=("--key=")
    flags+=("--no-headers")
    flags+=("--output=")
    two_word_flags+=("-o")
    flags+=("--output-version=")
    flags+=("--save-config")
    flags+=("--schema-cache-dir=")
    flags_with_completion+=("--schema-cache-dir")
    flags_completion+=("_filedir")
    flags+=("--show-all")
    flags+=("-a")
    flags+=("--show-labels")
    flags+=("--sort-by=")
    flags+=("--template=")
    flags_with_completion+=("--template")
    flags_completion+=("_filedir")
    flags+=("--validate")
    flags+=("--alsologtostderr")
    flags+=("--api-version=")
    flags+=("--as=")
    flags+=("--certificate-authority=")
    flags+=("--client-certificate=")
    flags+=("--client-key=")
    flags+=("--cluster=")
    flags+=("--context=")
    flags+=("--insecure-skip-tls-verify")
    flags+=("--kubeconfig=")
    flags+=("--log-backtrace-at=")
    flags+=("--log-dir=")
    flags+=("--log-flush-frequency=")
    flags+=("--logtostderr")
    flags+=("--match-server-version")
    flags+=("--namespace=")
    flags_with_completion+=("--namespace")
    flags_completion+=("__kubectl_get_namespaces")
    flags+=("--password=")
    flags+=("--server=")
    two_word_flags+=("-s")
    flags+=("--stderrthreshold=")
    flags+=("--token=")
    flags+=("--user=")
    flags+=("--username=")
    flags+=("--v=")
    flags+=("--vmodule=")

    must_have_one_flag=()
    must_have_one_noun=()
    noun_aliases=()
}

_kubectl_create_secret_generic()
{
    last_command="kubectl_create_secret_generic"
    commands=()

    flags=()
    two_word_flags=()
    flags_with_completion=()
    flags_completion=()

    flags+=("--dry-run")
    flags+=("--from-file=")
    flags+=("--from-literal=")
    flags+=("--generator=")
    flags+=("--no-headers")
    flags+=("--output=")
    two_word_flags+=("-o")
    flags+=("--output-version=")
    flags+=("--save-config")
    flags+=("--schema-cache-dir=")
    flags_with_completion+=("--schema-cache-dir")
    flags_completion+=("_filedir")
    flags+=("--show-all")
    flags+=("-a")
    flags+=("--show-labels")
    flags+=("--sort-by=")
    flags+=("--template=")
    flags_with_completion+=("--template")
    flags_completion+=("_filedir")
    flags+=("--type=")
    flags+=("--validate")
    flags+=("--alsologtostderr")
    flags+=("--api-version=")
    flags+=("--as=")
    flags+=("--certificate-authority=")
    flags+=("--client-certificate=")
    flags+=("--client-key=")
    flags+=("--cluster=")
    flags+=("--context=")
    flags+=("--insecure-skip-tls-verify")
    flags+=("--kubeconfig=")
    flags+=("--log-backtrace-at=")
    flags+=("--log-dir=")
    flags+=("--log-flush-frequency=")
    flags+=("--logtostderr")
    flags+=("--match-server-version")
    flags+=("--namespace=")
    flags_with_completion+=("--namespace")
    flags_completion+=("__kubectl_get_namespaces")
    flags+=("--password=")
    flags+=("--server=")
    two_word_flags+=("-s")
    flags+=("--stderrthreshold=")
    flags+=("--token=")
    flags+=("--user=")
    flags+=("--username=")
    flags+=("--v=")
    flags+=("--vmodule=")

    must_have_one_flag=()
    must_have_one_noun=()
    noun_aliases=()
}

_kubectl_create_secret()
{
    last_command="kubectl_create_secret"
    commands=()
    commands+=("docker-registry")
    commands+=("tls")
    commands+=("generic")

    flags=()
    two_word_flags=()
    flags_with_completion=()
    flags_completion=()

    flags+=("--alsologtostderr")
    flags+=("--api-version=")
    flags+=("--as=")
    flags+=("--certificate-authority=")
    flags+=("--client-certificate=")
    flags+=("--client-key=")
    flags+=("--cluster=")
    flags+=("--context=")
    flags+=("--insecure-skip-tls-verify")
    flags+=("--kubeconfig=")
    flags+=("--log-backtrace-at=")
    flags+=("--log-dir=")
    flags+=("--log-flush-frequency=")
    flags+=("--logtostderr")
    flags+=("--match-server-version")
    flags+=("--namespace=")
    flags_with_completion+=("--namespace")
    flags_completion+=("__kubectl_get_namespaces")
    flags+=("--password=")
    flags+=("--server=")
    two_word_flags+=("-s")
    flags+=("--stderrthreshold=")
    flags+=("--token=")
    flags+=("--user=")
    flags+=("--username=")
    flags+=("--v=")
    flags+=("--vmodule=")

    must_have_one_flag=()
    must_have_one_noun=()
    noun_aliases=()
}

_kubectl_create_configmap()
{
    last_command="kubectl_create_configmap"
    commands=()

    flags=()
    two_word_flags=()
    flags_with_completion=()
    flags_completion=()

    flags+=("--dry-run")
    flags+=("--from-file=")
    flags+=("--from-literal=")
    flags+=("--generator=")
    flags+=("--no-headers")
    flags+=("--output=")
    two_word_flags+=("-o")
    flags+=("--output-version=")
    flags+=("--save-config")
    flags+=("--schema-cache-dir=")
    flags_with_completion+=("--schema-cache-dir")
    flags_completion+=("_filedir")
    flags+=("--show-all")
    flags+=("-a")
    flags+=("--show-labels")
    flags+=("--sort-by=")
    flags+=("--template=")
    flags_with_completion+=("--template")
    flags_completion+=("_filedir")
    flags+=("--validate")
    flags+=("--alsologtostderr")
    flags+=("--api-version=")
    flags+=("--as=")
    flags+=("--certificate-authority=")
    flags+=("--client-certificate=")
    flags+=("--client-key=")
    flags+=("--cluster=")
    flags+=("--context=")
    flags+=("--insecure-skip-tls-verify")
    flags+=("--kubeconfig=")
    flags+=("--log-backtrace-at=")
    flags+=("--log-dir=")
    flags+=("--log-flush-frequency=")
    flags+=("--logtostderr")
    flags+=("--match-server-version")
    flags+=("--namespace=")
    flags_with_completion+=("--namespace")
    flags_completion+=("__kubectl_get_namespaces")
    flags+=("--password=")
    flags+=("--server=")
    two_word_flags+=("-s")
    flags+=("--stderrthreshold=")
    flags+=("--token=")
    flags+=("--user=")
    flags+=("--username=")
    flags+=("--v=")
    flags+=("--vmodule=")

    must_have_one_flag=()
    must_have_one_noun=()
    noun_aliases=()
}

_kubectl_create_serviceaccount()
{
    last_command="kubectl_create_serviceaccount"
    commands=()

    flags=()
    two_word_flags=()
    flags_with_completion=()
    flags_completion=()

    flags+=("--dry-run")
    flags+=("--generator=")
    flags+=("--include-extended-apis")
    flags+=("--no-headers")
    flags+=("--output=")
    two_word_flags+=("-o")
    flags+=("--output-version=")
    flags+=("--save-config")
    flags+=("--schema-cache-dir=")
    flags_with_completion+=("--schema-cache-dir")
    flags_completion+=("_filedir")
    flags+=("--show-all")
    flags+=("-a")
    flags+=("--show-labels")
    flags+=("--sort-by=")
    flags+=("--template=")
    flags_with_completion+=("--template")
    flags_completion+=("_filedir")
    flags+=("--validate")
    flags+=("--alsologtostderr")
    flags+=("--api-version=")
    flags+=("--as=")
    flags+=("--certificate-authority=")
    flags+=("--client-certificate=")
    flags+=("--client-key=")
    flags+=("--cluster=")
    flags+=("--context=")
    flags+=("--insecure-skip-tls-verify")
    flags+=("--kubeconfig=")
    flags+=("--log-backtrace-at=")
    flags+=("--log-dir=")
    flags+=("--log-flush-frequency=")
    flags+=("--logtostderr")
    flags+=("--match-server-version")
    flags+=("--namespace=")
    flags_with_completion+=("--namespace")
    flags_completion+=("__kubectl_get_namespaces")
    flags+=("--password=")
    flags+=("--server=")
    two_word_flags+=("-s")
    flags+=("--stderrthreshold=")
    flags+=("--token=")
    flags+=("--user=")
    flags+=("--username=")
    flags+=("--v=")
    flags+=("--vmodule=")

    must_have_one_flag=()
    must_have_one_noun=()
    noun_aliases=()
}

_kubectl_create()
{
    last_command="kubectl_create"
    commands=()
    commands+=("namespace")
    commands+=("secret")
    commands+=("configmap")
    commands+=("serviceaccount")

    flags=()
    two_word_flags=()
    flags_with_completion=()
    flags_completion=()

    flags+=("--filename=")
    flags_with_completion+=("--filename")
    flags_completion+=("__handle_filename_extension_flag json|yaml|yml")
    two_word_flags+=("-f")
    flags_with_completion+=("-f")
    flags_completion+=("__handle_filename_extension_flag json|yaml|yml")
    flags+=("--include-extended-apis")
    flags+=("--output=")
    two_word_flags+=("-o")
    flags+=("--record")
    flags+=("--recursive")
    flags+=("-R")
    flags+=("--save-config")
    flags+=("--schema-cache-dir=")
    flags_with_completion+=("--schema-cache-dir")
    flags_completion+=("_filedir")
    flags+=("--validate")
    flags+=("--alsologtostderr")
    flags+=("--api-version=")
    flags+=("--as=")
    flags+=("--certificate-authority=")
    flags+=("--client-certificate=")
    flags+=("--client-key=")
    flags+=("--cluster=")
    flags+=("--context=")
    flags+=("--insecure-skip-tls-verify")
    flags+=("--kubeconfig=")
    flags+=("--log-backtrace-at=")
    flags+=("--log-dir=")
    flags+=("--log-flush-frequency=")
    flags+=("--logtostderr")
    flags+=("--match-server-version")
    flags+=("--namespace=")
    flags_with_completion+=("--namespace")
    flags_completion+=("__kubectl_get_namespaces")
    flags+=("--password=")
    flags+=("--server=")
    two_word_flags+=("-s")
    flags+=("--stderrthreshold=")
    flags+=("--token=")
    flags+=("--user=")
    flags+=("--username=")
    flags+=("--v=")
    flags+=("--vmodule=")

    must_have_one_flag=()
    must_have_one_flag+=("--filename=")
    must_have_one_flag+=("-f")
    must_have_one_noun=()
    noun_aliases=()
}

_kubectl_replace()
{
    last_command="kubectl_replace"
    commands=()

    flags=()
    two_word_flags=()
    flags_with_completion=()
    flags_completion=()

    flags+=("--cascade")
    flags+=("--filename=")
    flags_with_completion+=("--filename")
    flags_completion+=("__handle_filename_extension_flag json|yaml|yml")
    two_word_flags+=("-f")
    flags_with_completion+=("-f")
    flags_completion+=("__handle_filename_extension_flag json|yaml|yml")
    flags+=("--force")
    flags+=("--grace-period=")
    flags+=("--include-extended-apis")
    flags+=("--output=")
    two_word_flags+=("-o")
    flags+=("--record")
    flags+=("--recursive")
    flags+=("-R")
    flags+=("--save-config")
    flags+=("--schema-cache-dir=")
    flags_with_completion+=("--schema-cache-dir")
    flags_completion+=("_filedir")
    flags+=("--timeout=")
    flags+=("--validate")
    flags+=("--alsologtostderr")
    flags+=("--api-version=")
    flags+=("--as=")
    flags+=("--certificate-authority=")
    flags+=("--client-certificate=")
    flags+=("--client-key=")
    flags+=("--cluster=")
    flags+=("--context=")
    flags+=("--insecure-skip-tls-verify")
    flags+=("--kubeconfig=")
    flags+=("--log-backtrace-at=")
    flags+=("--log-dir=")
    flags+=("--log-flush-frequency=")
    flags+=("--logtostderr")
    flags+=("--match-server-version")
    flags+=("--namespace=")
    flags_with_completion+=("--namespace")
    flags_completion+=("__kubectl_get_namespaces")
    flags+=("--password=")
    flags+=("--server=")
    two_word_flags+=("-s")
    flags+=("--stderrthreshold=")
    flags+=("--token=")
    flags+=("--user=")
    flags+=("--username=")
    flags+=("--v=")
    flags+=("--vmodule=")

    must_have_one_flag=()
    must_have_one_flag+=("--filename=")
    must_have_one_flag+=("-f")
    must_have_one_noun=()
    noun_aliases=()
}

_kubectl_patch()
{
    last_command="kubectl_patch"
    commands=()

    flags=()
    two_word_flags=()
    flags_with_completion=()
    flags_completion=()

    flags+=("--filename=")
    flags_with_completion+=("--filename")
    flags_completion+=("__handle_filename_extension_flag json|yaml|yml")
    two_word_flags+=("-f")
    flags_with_completion+=("-f")
    flags_completion+=("__handle_filename_extension_flag json|yaml|yml")
    flags+=("--include-extended-apis")
    flags+=("--output=")
    two_word_flags+=("-o")
    flags+=("--patch=")
    two_word_flags+=("-p")
    flags+=("--record")
    flags+=("--recursive")
    flags+=("-R")
    flags+=("--type=")
    flags+=("--alsologtostderr")
    flags+=("--api-version=")
    flags+=("--as=")
    flags+=("--certificate-authority=")
    flags+=("--client-certificate=")
    flags+=("--client-key=")
    flags+=("--cluster=")
    flags+=("--context=")
    flags+=("--insecure-skip-tls-verify")
    flags+=("--kubeconfig=")
    flags+=("--log-backtrace-at=")
    flags+=("--log-dir=")
    flags+=("--log-flush-frequency=")
    flags+=("--logtostderr")
    flags+=("--match-server-version")
    flags+=("--namespace=")
    flags_with_completion+=("--namespace")
    flags_completion+=("__kubectl_get_namespaces")
    flags+=("--password=")
    flags+=("--server=")
    two_word_flags+=("-s")
    flags+=("--stderrthreshold=")
    flags+=("--token=")
    flags+=("--user=")
    flags+=("--username=")
    flags+=("--v=")
    flags+=("--vmodule=")

    must_have_one_flag=()
    must_have_one_flag+=("--patch=")
    must_have_one_flag+=("-p")
    must_have_one_noun=()
    must_have_one_noun+=("cluster")
    must_have_one_noun+=("clusterrole")
    must_have_one_noun+=("clusterrolebinding")
    must_have_one_noun+=("componentstatus")
    must_have_one_noun+=("configmap")
    must_have_one_noun+=("daemonset")
    must_have_one_noun+=("deployment")
    must_have_one_noun+=("endpoints")
    must_have_one_noun+=("event")
    must_have_one_noun+=("horizontalpodautoscaler")
    must_have_one_noun+=("ingress")
    must_have_one_noun+=("job")
    must_have_one_noun+=("limitrange")
    must_have_one_noun+=("namespace")
    must_have_one_noun+=("networkpolicy")
    must_have_one_noun+=("node")
    must_have_one_noun+=("persistentvolume")
    must_have_one_noun+=("persistentvolumeclaim")
    must_have_one_noun+=("petset")
    must_have_one_noun+=("pod")
    must_have_one_noun+=("podsecuritypolicy")
    must_have_one_noun+=("podtemplate")
    must_have_one_noun+=("replicaset")
    must_have_one_noun+=("replicationcontroller")
    must_have_one_noun+=("resourcequota")
    must_have_one_noun+=("role")
    must_have_one_noun+=("rolebinding")
    must_have_one_noun+=("secret")
    must_have_one_noun+=("service")
    must_have_one_noun+=("serviceaccount")
    must_have_one_noun+=("thirdpartyresource")
    must_have_one_noun+=("thirdpartyresourcedata")
    noun_aliases=()
    noun_aliases+=("clusterrolebindings")
    noun_aliases+=("clusterroles")
    noun_aliases+=("clusters")
    noun_aliases+=("componentstatuses")
    noun_aliases+=("configmaps")
    noun_aliases+=("cs")
    noun_aliases+=("daemonsets")
    noun_aliases+=("deployments")
    noun_aliases+=("ds")
    noun_aliases+=("endpoints")
    noun_aliases+=("ep")
    noun_aliases+=("ev")
    noun_aliases+=("events")
    noun_aliases+=("horizontalpodautoscalers")
    noun_aliases+=("hpa")
    noun_aliases+=("ing")
    noun_aliases+=("ingresses")
    noun_aliases+=("jobs")
    noun_aliases+=("limitranges")
    noun_aliases+=("limits")
    noun_aliases+=("namespaces")
    noun_aliases+=("networkpolicies")
    noun_aliases+=("no")
    noun_aliases+=("nodes")
    noun_aliases+=("ns")
    noun_aliases+=("persistentvolumeclaims")
    noun_aliases+=("persistentvolumes")
    noun_aliases+=("petsets")
    noun_aliases+=("po")
    noun_aliases+=("pods")
    noun_aliases+=("podsecuritypolicies")
    noun_aliases+=("podtemplates")
    noun_aliases+=("pv")
    noun_aliases+=("pvc")
    noun_aliases+=("quota")
    noun_aliases+=("rc")
    noun_aliases+=("replicasets")
    noun_aliases+=("replicationcontrollers")
    noun_aliases+=("resourcequotas")
    noun_aliases+=("rolebindings")
    noun_aliases+=("roles")
    noun_aliases+=("rs")
    noun_aliases+=("sa")
    noun_aliases+=("secrets")
    noun_aliases+=("serviceaccounts")
    noun_aliases+=("services")
    noun_aliases+=("svc")
    noun_aliases+=("thirdpartyresourcedatas")
    noun_aliases+=("thirdpartyresources")
}

_kubectl_delete()
{
    last_command="kubectl_delete"
    commands=()

    flags=()
    two_word_flags=()
    flags_with_completion=()
    flags_completion=()

    flags+=("--all")
    flags+=("--cascade")
    flags+=("--filename=")
    flags_with_completion+=("--filename")
    flags_completion+=("__handle_filename_extension_flag json|yaml|yml")
    two_word_flags+=("-f")
    flags_with_completion+=("-f")
    flags_completion+=("__handle_filename_extension_flag json|yaml|yml")
    flags+=("--grace-period=")
    flags+=("--ignore-not-found")
    flags+=("--include-extended-apis")
    flags+=("--now")
    flags+=("--output=")
    two_word_flags+=("-o")
    flags+=("--recursive")
    flags+=("-R")
    flags+=("--selector=")
    two_word_flags+=("-l")
    flags+=("--timeout=")
    flags+=("--alsologtostderr")
    flags+=("--api-version=")
    flags+=("--as=")
    flags+=("--certificate-authority=")
    flags+=("--client-certificate=")
    flags+=("--client-key=")
    flags+=("--cluster=")
    flags+=("--context=")
    flags+=("--insecure-skip-tls-verify")
    flags+=("--kubeconfig=")
    flags+=("--log-backtrace-at=")
    flags+=("--log-dir=")
    flags+=("--log-flush-frequency=")
    flags+=("--logtostderr")
    flags+=("--match-server-version")
    flags+=("--namespace=")
    flags_with_completion+=("--namespace")
    flags_completion+=("__kubectl_get_namespaces")
    flags+=("--password=")
    flags+=("--server=")
    two_word_flags+=("-s")
    flags+=("--stderrthreshold=")
    flags+=("--token=")
    flags+=("--user=")
    flags+=("--username=")
    flags+=("--v=")
    flags+=("--vmodule=")

    must_have_one_flag=()
    must_have_one_noun=()
    must_have_one_noun+=("cluster")
    must_have_one_noun+=("clusterrole")
    must_have_one_noun+=("clusterrolebinding")
    must_have_one_noun+=("componentstatus")
    must_have_one_noun+=("configmap")
    must_have_one_noun+=("daemonset")
    must_have_one_noun+=("deployment")
    must_have_one_noun+=("endpoints")
    must_have_one_noun+=("event")
    must_have_one_noun+=("horizontalpodautoscaler")
    must_have_one_noun+=("ingress")
    must_have_one_noun+=("job")
    must_have_one_noun+=("limitrange")
    must_have_one_noun+=("namespace")
    must_have_one_noun+=("networkpolicy")
    must_have_one_noun+=("node")
    must_have_one_noun+=("persistentvolume")
    must_have_one_noun+=("persistentvolumeclaim")
    must_have_one_noun+=("petset")
    must_have_one_noun+=("pod")
    must_have_one_noun+=("podsecuritypolicy")
    must_have_one_noun+=("podtemplate")
    must_have_one_noun+=("replicaset")
    must_have_one_noun+=("replicationcontroller")
    must_have_one_noun+=("resourcequota")
    must_have_one_noun+=("role")
    must_have_one_noun+=("rolebinding")
    must_have_one_noun+=("secret")
    must_have_one_noun+=("service")
    must_have_one_noun+=("serviceaccount")
    must_have_one_noun+=("thirdpartyresource")
    must_have_one_noun+=("thirdpartyresourcedata")
    noun_aliases=()
    noun_aliases+=("clusterrolebindings")
    noun_aliases+=("clusterroles")
    noun_aliases+=("clusters")
    noun_aliases+=("componentstatuses")
    noun_aliases+=("configmaps")
    noun_aliases+=("cs")
    noun_aliases+=("daemonsets")
    noun_aliases+=("deployments")
    noun_aliases+=("ds")
    noun_aliases+=("endpoints")
    noun_aliases+=("ep")
    noun_aliases+=("ev")
    noun_aliases+=("events")
    noun_aliases+=("horizontalpodautoscalers")
    noun_aliases+=("hpa")
    noun_aliases+=("ing")
    noun_aliases+=("ingresses")
    noun_aliases+=("jobs")
    noun_aliases+=("limitranges")
    noun_aliases+=("limits")
    noun_aliases+=("namespaces")
    noun_aliases+=("networkpolicies")
    noun_aliases+=("no")
    noun_aliases+=("nodes")
    noun_aliases+=("ns")
    noun_aliases+=("persistentvolumeclaims")
    noun_aliases+=("persistentvolumes")
    noun_aliases+=("petsets")
    noun_aliases+=("po")
    noun_aliases+=("pods")
    noun_aliases+=("podsecuritypolicies")
    noun_aliases+=("podtemplates")
    noun_aliases+=("pv")
    noun_aliases+=("pvc")
    noun_aliases+=("quota")
    noun_aliases+=("rc")
    noun_aliases+=("replicasets")
    noun_aliases+=("replicationcontrollers")
    noun_aliases+=("resourcequotas")
    noun_aliases+=("rolebindings")
    noun_aliases+=("roles")
    noun_aliases+=("rs")
    noun_aliases+=("sa")
    noun_aliases+=("secrets")
    noun_aliases+=("serviceaccounts")
    noun_aliases+=("services")
    noun_aliases+=("svc")
    noun_aliases+=("thirdpartyresourcedatas")
    noun_aliases+=("thirdpartyresources")
}

_kubectl_edit()
{
    last_command="kubectl_edit"
    commands=()

    flags=()
    two_word_flags=()
    flags_with_completion=()
    flags_completion=()

    flags+=("--filename=")
    flags_with_completion+=("--filename")
    flags_completion+=("__handle_filename_extension_flag json|yaml|yml")
    two_word_flags+=("-f")
    flags_with_completion+=("-f")
    flags_completion+=("__handle_filename_extension_flag json|yaml|yml")
    flags+=("--include-extended-apis")
    flags+=("--output=")
    two_word_flags+=("-o")
    flags+=("--output-version=")
    flags+=("--record")
    flags+=("--recursive")
    flags+=("-R")
    flags+=("--save-config")
    flags+=("--windows-line-endings")
    flags+=("--alsologtostderr")
    flags+=("--api-version=")
    flags+=("--as=")
    flags+=("--certificate-authority=")
    flags+=("--client-certificate=")
    flags+=("--client-key=")
    flags+=("--cluster=")
    flags+=("--context=")
    flags+=("--insecure-skip-tls-verify")
    flags+=("--kubeconfig=")
    flags+=("--log-backtrace-at=")
    flags+=("--log-dir=")
    flags+=("--log-flush-frequency=")
    flags+=("--logtostderr")
    flags+=("--match-server-version")
    flags+=("--namespace=")
    flags_with_completion+=("--namespace")
    flags_completion+=("__kubectl_get_namespaces")
    flags+=("--password=")
    flags+=("--server=")
    two_word_flags+=("-s")
    flags+=("--stderrthreshold=")
    flags+=("--token=")
    flags+=("--user=")
    flags+=("--username=")
    flags+=("--v=")
    flags+=("--vmodule=")

    must_have_one_flag=()
    must_have_one_noun=()
    must_have_one_noun+=("cluster")
    must_have_one_noun+=("clusterrole")
    must_have_one_noun+=("clusterrolebinding")
    must_have_one_noun+=("componentstatus")
    must_have_one_noun+=("configmap")
    must_have_one_noun+=("daemonset")
    must_have_one_noun+=("deployment")
    must_have_one_noun+=("endpoints")
    must_have_one_noun+=("event")
    must_have_one_noun+=("horizontalpodautoscaler")
    must_have_one_noun+=("ingress")
    must_have_one_noun+=("job")
    must_have_one_noun+=("limitrange")
    must_have_one_noun+=("namespace")
    must_have_one_noun+=("networkpolicy")
    must_have_one_noun+=("node")
    must_have_one_noun+=("persistentvolume")
    must_have_one_noun+=("persistentvolumeclaim")
    must_have_one_noun+=("petset")
    must_have_one_noun+=("pod")
    must_have_one_noun+=("podsecuritypolicy")
    must_have_one_noun+=("podtemplate")
    must_have_one_noun+=("replicaset")
    must_have_one_noun+=("replicationcontroller")
    must_have_one_noun+=("resourcequota")
    must_have_one_noun+=("role")
    must_have_one_noun+=("rolebinding")
    must_have_one_noun+=("secret")
    must_have_one_noun+=("service")
    must_have_one_noun+=("serviceaccount")
    must_have_one_noun+=("thirdpartyresource")
    must_have_one_noun+=("thirdpartyresourcedata")
    noun_aliases=()
    noun_aliases+=("clusterrolebindings")
    noun_aliases+=("clusterroles")
    noun_aliases+=("clusters")
    noun_aliases+=("componentstatuses")
    noun_aliases+=("configmaps")
    noun_aliases+=("cs")
    noun_aliases+=("daemonsets")
    noun_aliases+=("deployments")
    noun_aliases+=("ds")
    noun_aliases+=("endpoints")
    noun_aliases+=("ep")
    noun_aliases+=("ev")
    noun_aliases+=("events")
    noun_aliases+=("horizontalpodautoscalers")
    noun_aliases+=("hpa")
    noun_aliases+=("ing")
    noun_aliases+=("ingresses")
    noun_aliases+=("jobs")
    noun_aliases+=("limitranges")
    noun_aliases+=("limits")
    noun_aliases+=("namespaces")
    noun_aliases+=("networkpolicies")
    noun_aliases+=("no")
    noun_aliases+=("nodes")
    noun_aliases+=("ns")
    noun_aliases+=("persistentvolumeclaims")
    noun_aliases+=("persistentvolumes")
    noun_aliases+=("petsets")
    noun_aliases+=("po")
    noun_aliases+=("pods")
    noun_aliases+=("podsecuritypolicies")
    noun_aliases+=("podtemplates")
    noun_aliases+=("pv")
    noun_aliases+=("pvc")
    noun_aliases+=("quota")
    noun_aliases+=("rc")
    noun_aliases+=("replicasets")
    noun_aliases+=("replicationcontrollers")
    noun_aliases+=("resourcequotas")
    noun_aliases+=("rolebindings")
    noun_aliases+=("roles")
    noun_aliases+=("rs")
    noun_aliases+=("sa")
    noun_aliases+=("secrets")
    noun_aliases+=("serviceaccounts")
    noun_aliases+=("services")
    noun_aliases+=("svc")
    noun_aliases+=("thirdpartyresourcedatas")
    noun_aliases+=("thirdpartyresources")
}

_kubectl_apply()
{
    last_command="kubectl_apply"
    commands=()

    flags=()
    two_word_flags=()
    flags_with_completion=()
    flags_completion=()

    flags+=("--filename=")
    flags_with_completion+=("--filename")
    flags_completion+=("__handle_filename_extension_flag json|yaml|yml")
    two_word_flags+=("-f")
    flags_with_completion+=("-f")
    flags_completion+=("__handle_filename_extension_flag json|yaml|yml")
    flags+=("--include-extended-apis")
    flags+=("--output=")
    two_word_flags+=("-o")
    flags+=("--record")
    flags+=("--recursive")
    flags+=("-R")
    flags+=("--schema-cache-dir=")
    flags_with_completion+=("--schema-cache-dir")
    flags_completion+=("_filedir")
    flags+=("--validate")
    flags+=("--alsologtostderr")
    flags+=("--api-version=")
    flags+=("--as=")
    flags+=("--certificate-authority=")
    flags+=("--client-certificate=")
    flags+=("--client-key=")
    flags+=("--cluster=")
    flags+=("--context=")
    flags+=("--insecure-skip-tls-verify")
    flags+=("--kubeconfig=")
    flags+=("--log-backtrace-at=")
    flags+=("--log-dir=")
    flags+=("--log-flush-frequency=")
    flags+=("--logtostderr")
    flags+=("--match-server-version")
    flags+=("--namespace=")
    flags_with_completion+=("--namespace")
    flags_completion+=("__kubectl_get_namespaces")
    flags+=("--password=")
    flags+=("--server=")
    two_word_flags+=("-s")
    flags+=("--stderrthreshold=")
    flags+=("--token=")
    flags+=("--user=")
    flags+=("--username=")
    flags+=("--v=")
    flags+=("--vmodule=")

    must_have_one_flag=()
    must_have_one_flag+=("--filename=")
    must_have_one_flag+=("-f")
    must_have_one_noun=()
    noun_aliases=()
}

_kubectl_namespace()
{
    last_command="kubectl_namespace"
    commands=()

    flags=()
    two_word_flags=()
    flags_with_completion=()
    flags_completion=()

    flags+=("--alsologtostderr")
    flags+=("--api-version=")
    flags+=("--as=")
    flags+=("--certificate-authority=")
    flags+=("--client-certificate=")
    flags+=("--client-key=")
    flags+=("--cluster=")
    flags+=("--context=")
    flags+=("--insecure-skip-tls-verify")
    flags+=("--kubeconfig=")
    flags+=("--log-backtrace-at=")
    flags+=("--log-dir=")
    flags+=("--log-flush-frequency=")
    flags+=("--logtostderr")
    flags+=("--match-server-version")
    flags+=("--namespace=")
    flags_with_completion+=("--namespace")
    flags_completion+=("__kubectl_get_namespaces")
    flags+=("--password=")
    flags+=("--server=")
    two_word_flags+=("-s")
    flags+=("--stderrthreshold=")
    flags+=("--token=")
    flags+=("--user=")
    flags+=("--username=")
    flags+=("--v=")
    flags+=("--vmodule=")

    must_have_one_flag=()
    must_have_one_noun=()
    noun_aliases=()
}

_kubectl_logs()
{
    last_command="kubectl_logs"
    commands=()

    flags=()
    two_word_flags=()
    flags_with_completion=()
    flags_completion=()

    flags+=("--container=")
    two_word_flags+=("-c")
    flags+=("--follow")
    flags+=("-f")
    flags+=("--include-extended-apis")
    flags+=("--interactive")
    flags+=("--limit-bytes=")
    flags+=("--previous")
    flags+=("-p")
    flags+=("--since=")
    flags+=("--since-time=")
    flags+=("--tail=")
    flags+=("--timestamps")
    flags+=("--alsologtostderr")
    flags+=("--api-version=")
    flags+=("--as=")
    flags+=("--certificate-authority=")
    flags+=("--client-certificate=")
    flags+=("--client-key=")
    flags+=("--cluster=")
    flags+=("--context=")
    flags+=("--insecure-skip-tls-verify")
    flags+=("--kubeconfig=")
    flags+=("--log-backtrace-at=")
    flags+=("--log-dir=")
    flags+=("--log-flush-frequency=")
    flags+=("--logtostderr")
    flags+=("--match-server-version")
    flags+=("--namespace=")
    flags_with_completion+=("--namespace")
    flags_completion+=("__kubectl_get_namespaces")
    flags+=("--password=")
    flags+=("--server=")
    two_word_flags+=("-s")
    flags+=("--stderrthreshold=")
    flags+=("--token=")
    flags+=("--user=")
    flags+=("--username=")
    flags+=("--v=")
    flags+=("--vmodule=")

    must_have_one_flag=()
    must_have_one_noun=()
    noun_aliases=()
}

_kubectl_rolling-update()
{
    last_command="kubectl_rolling-update"
    commands=()

    flags=()
    two_word_flags=()
    flags_with_completion=()
    flags_completion=()

    flags+=("--container=")
    flags+=("--deployment-label-key=")
    flags+=("--dry-run")
    flags+=("--filename=")
    flags_with_completion+=("--filename")
    flags_completion+=("__handle_filename_extension_flag json|yaml|yml")
    two_word_flags+=("-f")
    flags_with_completion+=("-f")
    flags_completion+=("__handle_filename_extension_flag json|yaml|yml")
    flags+=("--image=")
    flags+=("--image-pull-policy=")
    flags+=("--include-extended-apis")
    flags+=("--no-headers")
    flags+=("--output=")
    two_word_flags+=("-o")
    flags+=("--output-version=")
    flags+=("--poll-interval=")
    flags+=("--rollback")
    flags+=("--schema-cache-dir=")
    flags_with_completion+=("--schema-cache-dir")
    flags_completion+=("_filedir")
    flags+=("--show-all")
    flags+=("-a")
    flags+=("--show-labels")
    flags+=("--sort-by=")
    flags+=("--template=")
    flags_with_completion+=("--template")
    flags_completion+=("_filedir")
    flags+=("--timeout=")
    flags+=("--update-period=")
    flags+=("--validate")
    flags+=("--alsologtostderr")
    flags+=("--api-version=")
    flags+=("--as=")
    flags+=("--certificate-authority=")
    flags+=("--client-certificate=")
    flags+=("--client-key=")
    flags+=("--cluster=")
    flags+=("--context=")
    flags+=("--insecure-skip-tls-verify")
    flags+=("--kubeconfig=")
    flags+=("--log-backtrace-at=")
    flags+=("--log-dir=")
    flags+=("--log-flush-frequency=")
    flags+=("--logtostderr")
    flags+=("--match-server-version")
    flags+=("--namespace=")
    flags_with_completion+=("--namespace")
    flags_completion+=("__kubectl_get_namespaces")
    flags+=("--password=")
    flags+=("--server=")
    two_word_flags+=("-s")
    flags+=("--stderrthreshold=")
    flags+=("--token=")
    flags+=("--user=")
    flags+=("--username=")
    flags+=("--v=")
    flags+=("--vmodule=")

    must_have_one_flag=()
    must_have_one_flag+=("--filename=")
    must_have_one_flag+=("-f")
    must_have_one_flag+=("--image=")
    must_have_one_noun=()
    noun_aliases=()
}

_kubectl_scale()
{
    last_command="kubectl_scale"
    commands=()

    flags=()
    two_word_flags=()
    flags_with_completion=()
    flags_completion=()

    flags+=("--current-replicas=")
    flags+=("--filename=")
    flags_with_completion+=("--filename")
    flags_completion+=("__handle_filename_extension_flag json|yaml|yml")
    two_word_flags+=("-f")
    flags_with_completion+=("-f")
    flags_completion+=("__handle_filename_extension_flag json|yaml|yml")
    flags+=("--include-extended-apis")
    flags+=("--output=")
    two_word_flags+=("-o")
    flags+=("--record")
    flags+=("--recursive")
    flags+=("-R")
    flags+=("--replicas=")
    flags+=("--resource-version=")
    flags+=("--timeout=")
    flags+=("--alsologtostderr")
    flags+=("--api-version=")
    flags+=("--as=")
    flags+=("--certificate-authority=")
    flags+=("--client-certificate=")
    flags+=("--client-key=")
    flags+=("--cluster=")
    flags+=("--context=")
    flags+=("--insecure-skip-tls-verify")
    flags+=("--kubeconfig=")
    flags+=("--log-backtrace-at=")
    flags+=("--log-dir=")
    flags+=("--log-flush-frequency=")
    flags+=("--logtostderr")
    flags+=("--match-server-version")
    flags+=("--namespace=")
    flags_with_completion+=("--namespace")
    flags_completion+=("__kubectl_get_namespaces")
    flags+=("--password=")
    flags+=("--server=")
    two_word_flags+=("-s")
    flags+=("--stderrthreshold=")
    flags+=("--token=")
    flags+=("--user=")
    flags+=("--username=")
    flags+=("--v=")
    flags+=("--vmodule=")

    must_have_one_flag=()
    must_have_one_flag+=("--replicas=")
    must_have_one_noun=()
    noun_aliases=()
}

_kubectl_cordon()
{
    last_command="kubectl_cordon"
    commands=()

    flags=()
    two_word_flags=()
    flags_with_completion=()
    flags_completion=()

    flags+=("--alsologtostderr")
    flags+=("--api-version=")
    flags+=("--as=")
    flags+=("--certificate-authority=")
    flags+=("--client-certificate=")
    flags+=("--client-key=")
    flags+=("--cluster=")
    flags+=("--context=")
    flags+=("--insecure-skip-tls-verify")
    flags+=("--kubeconfig=")
    flags+=("--log-backtrace-at=")
    flags+=("--log-dir=")
    flags+=("--log-flush-frequency=")
    flags+=("--logtostderr")
    flags+=("--match-server-version")
    flags+=("--namespace=")
    flags_with_completion+=("--namespace")
    flags_completion+=("__kubectl_get_namespaces")
    flags+=("--password=")
    flags+=("--server=")
    two_word_flags+=("-s")
    flags+=("--stderrthreshold=")
    flags+=("--token=")
    flags+=("--user=")
    flags+=("--username=")
    flags+=("--v=")
    flags+=("--vmodule=")

    must_have_one_flag=()
    must_have_one_noun=()
    noun_aliases=()
}

_kubectl_drain()
{
    last_command="kubectl_drain"
    commands=()

    flags=()
    two_word_flags=()
    flags_with_completion=()
    flags_completion=()

    flags+=("--delete-local-data")
    flags+=("--force")
    flags+=("--grace-period=")
    flags+=("--ignore-daemonsets")
    flags+=("--alsologtostderr")
    flags+=("--api-version=")
    flags+=("--as=")
    flags+=("--certificate-authority=")
    flags+=("--client-certificate=")
    flags+=("--client-key=")
    flags+=("--cluster=")
    flags+=("--context=")
    flags+=("--insecure-skip-tls-verify")
    flags+=("--kubeconfig=")
    flags+=("--log-backtrace-at=")
    flags+=("--log-dir=")
    flags+=("--log-flush-frequency=")
    flags+=("--logtostderr")
    flags+=("--match-server-version")
    flags+=("--namespace=")
    flags_with_completion+=("--namespace")
    flags_completion+=("__kubectl_get_namespaces")
    flags+=("--password=")
    flags+=("--server=")
    two_word_flags+=("-s")
    flags+=("--stderrthreshold=")
    flags+=("--token=")
    flags+=("--user=")
    flags+=("--username=")
    flags+=("--v=")
    flags+=("--vmodule=")

    must_have_one_flag=()
    must_have_one_noun=()
    noun_aliases=()
}

_kubectl_uncordon()
{
    last_command="kubectl_uncordon"
    commands=()

    flags=()
    two_word_flags=()
    flags_with_completion=()
    flags_completion=()

    flags+=("--alsologtostderr")
    flags+=("--api-version=")
    flags+=("--as=")
    flags+=("--certificate-authority=")
    flags+=("--client-certificate=")
    flags+=("--client-key=")
    flags+=("--cluster=")
    flags+=("--context=")
    flags+=("--insecure-skip-tls-verify")
    flags+=("--kubeconfig=")
    flags+=("--log-backtrace-at=")
    flags+=("--log-dir=")
    flags+=("--log-flush-frequency=")
    flags+=("--logtostderr")
    flags+=("--match-server-version")
    flags+=("--namespace=")
    flags_with_completion+=("--namespace")
    flags_completion+=("__kubectl_get_namespaces")
    flags+=("--password=")
    flags+=("--server=")
    two_word_flags+=("-s")
    flags+=("--stderrthreshold=")
    flags+=("--token=")
    flags+=("--user=")
    flags+=("--username=")
    flags+=("--v=")
    flags+=("--vmodule=")

    must_have_one_flag=()
    must_have_one_noun=()
    noun_aliases=()
}

_kubectl_attach()
{
    last_command="kubectl_attach"
    commands=()

    flags=()
    two_word_flags=()
    flags_with_completion=()
    flags_completion=()

    flags+=("--container=")
    two_word_flags+=("-c")
    flags+=("--stdin")
    flags+=("-i")
    flags+=("--tty")
    flags+=("-t")
    flags+=("--alsologtostderr")
    flags+=("--api-version=")
    flags+=("--as=")
    flags+=("--certificate-authority=")
    flags+=("--client-certificate=")
    flags+=("--client-key=")
    flags+=("--cluster=")
    flags+=("--context=")
    flags+=("--insecure-skip-tls-verify")
    flags+=("--kubeconfig=")
    flags+=("--log-backtrace-at=")
    flags+=("--log-dir=")
    flags+=("--log-flush-frequency=")
    flags+=("--logtostderr")
    flags+=("--match-server-version")
    flags+=("--namespace=")
    flags_with_completion+=("--namespace")
    flags_completion+=("__kubectl_get_namespaces")
    flags+=("--password=")
    flags+=("--server=")
    two_word_flags+=("-s")
    flags+=("--stderrthreshold=")
    flags+=("--token=")
    flags+=("--user=")
    flags+=("--username=")
    flags+=("--v=")
    flags+=("--vmodule=")

    must_have_one_flag=()
    must_have_one_noun=()
    noun_aliases=()
}

_kubectl_exec()
{
    last_command="kubectl_exec"
    commands=()

    flags=()
    two_word_flags=()
    flags_with_completion=()
    flags_completion=()

    flags+=("--container=")
    two_word_flags+=("-c")
    flags+=("--pod=")
    two_word_flags+=("-p")
    flags+=("--stdin")
    flags+=("-i")
    flags+=("--tty")
    flags+=("-t")
    flags+=("--alsologtostderr")
    flags+=("--api-version=")
    flags+=("--as=")
    flags+=("--certificate-authority=")
    flags+=("--client-certificate=")
    flags+=("--client-key=")
    flags+=("--cluster=")
    flags+=("--context=")
    flags+=("--insecure-skip-tls-verify")
    flags+=("--kubeconfig=")
    flags+=("--log-backtrace-at=")
    flags+=("--log-dir=")
    flags+=("--log-flush-frequency=")
    flags+=("--logtostderr")
    flags+=("--match-server-version")
    flags+=("--namespace=")
    flags_with_completion+=("--namespace")
    flags_completion+=("__kubectl_get_namespaces")
    flags+=("--password=")
    flags+=("--server=")
    two_word_flags+=("-s")
    flags+=("--stderrthreshold=")
    flags+=("--token=")
    flags+=("--user=")
    flags+=("--username=")
    flags+=("--v=")
    flags+=("--vmodule=")

    must_have_one_flag=()
    must_have_one_noun=()
    noun_aliases=()
}

_kubectl_port-forward()
{
    last_command="kubectl_port-forward"
    commands=()

    flags=()
    two_word_flags=()
    flags_with_completion=()
    flags_completion=()

    flags+=("--pod=")
    two_word_flags+=("-p")
    flags+=("--alsologtostderr")
    flags+=("--api-version=")
    flags+=("--as=")
    flags+=("--certificate-authority=")
    flags+=("--client-certificate=")
    flags+=("--client-key=")
    flags+=("--cluster=")
    flags+=("--context=")
    flags+=("--insecure-skip-tls-verify")
    flags+=("--kubeconfig=")
    flags+=("--log-backtrace-at=")
    flags+=("--log-dir=")
    flags+=("--log-flush-frequency=")
    flags+=("--logtostderr")
    flags+=("--match-server-version")
    flags+=("--namespace=")
    flags_with_completion+=("--namespace")
    flags_completion+=("__kubectl_get_namespaces")
    flags+=("--password=")
    flags+=("--server=")
    two_word_flags+=("-s")
    flags+=("--stderrthreshold=")
    flags+=("--token=")
    flags+=("--user=")
    flags+=("--username=")
    flags+=("--v=")
    flags+=("--vmodule=")

    must_have_one_flag=()
    must_have_one_noun=()
    noun_aliases=()
}

_kubectl_proxy()
{
    last_command="kubectl_proxy"
    commands=()

    flags=()
    two_word_flags=()
    flags_with_completion=()
    flags_completion=()

    flags+=("--accept-hosts=")
    flags+=("--accept-paths=")
    flags+=("--address=")
    flags+=("--api-prefix=")
    flags+=("--disable-filter")
    flags+=("--port=")
    two_word_flags+=("-p")
    flags+=("--reject-methods=")
    flags+=("--reject-paths=")
    flags+=("--unix-socket=")
    two_word_flags+=("-u")
    flags+=("--www=")
    two_word_flags+=("-w")
    flags+=("--www-prefix=")
    two_word_flags+=("-P")
    flags+=("--alsologtostderr")
    flags+=("--api-version=")
    flags+=("--as=")
    flags+=("--certificate-authority=")
    flags+=("--client-certificate=")
    flags+=("--client-key=")
    flags+=("--cluster=")
    flags+=("--context=")
    flags+=("--insecure-skip-tls-verify")
    flags+=("--kubeconfig=")
    flags+=("--log-backtrace-at=")
    flags+=("--log-dir=")
    flags+=("--log-flush-frequency=")
    flags+=("--logtostderr")
    flags+=("--match-server-version")
    flags+=("--namespace=")
    flags_with_completion+=("--namespace")
    flags_completion+=("__kubectl_get_namespaces")
    flags+=("--password=")
    flags+=("--server=")
    two_word_flags+=("-s")
    flags+=("--stderrthreshold=")
    flags+=("--token=")
    flags+=("--user=")
    flags+=("--username=")
    flags+=("--v=")
    flags+=("--vmodule=")

    must_have_one_flag=()
    must_have_one_noun=()
    noun_aliases=()
}

_kubectl_run()
{
    last_command="kubectl_run"
    commands=()

    flags=()
    two_word_flags=()
    flags_with_completion=()
    flags_completion=()

    flags+=("--attach")
    flags+=("--command")
    flags+=("--dry-run")
    flags+=("--env=")
    flags+=("--expose")
    flags+=("--generator=")
    flags+=("--hostport=")
    flags+=("--image=")
    flags+=("--include-extended-apis")
    flags+=("--labels=")
    two_word_flags+=("-l")
    flags+=("--leave-stdin-open")
    flags+=("--limits=")
    flags+=("--no-headers")
    flags+=("--output=")
    two_word_flags+=("-o")
    flags+=("--output-version=")
    flags+=("--overrides=")
    flags+=("--port=")
    flags+=("--record")
    flags+=("--replicas=")
    two_word_flags+=("-r")
    flags+=("--requests=")
    flags+=("--restart=")
    flags+=("--rm")
    flags+=("--save-config")
    flags+=("--service-generator=")
    flags+=("--service-overrides=")
    flags+=("--show-all")
    flags+=("-a")
    flags+=("--show-labels")
    flags+=("--sort-by=")
    flags+=("--stdin")
    flags+=("-i")
    flags+=("--template=")
    flags_with_completion+=("--template")
    flags_completion+=("_filedir")
    flags+=("--tty")
    flags+=("-t")
    flags+=("--alsologtostderr")
    flags+=("--api-version=")
    flags+=("--as=")
    flags+=("--certificate-authority=")
    flags+=("--client-certificate=")
    flags+=("--client-key=")
    flags+=("--cluster=")
    flags+=("--context=")
    flags+=("--insecure-skip-tls-verify")
    flags+=("--kubeconfig=")
    flags+=("--log-backtrace-at=")
    flags+=("--log-dir=")
    flags+=("--log-flush-frequency=")
    flags+=("--logtostderr")
    flags+=("--match-server-version")
    flags+=("--namespace=")
    flags_with_completion+=("--namespace")
    flags_completion+=("__kubectl_get_namespaces")
    flags+=("--password=")
    flags+=("--server=")
    two_word_flags+=("-s")
    flags+=("--stderrthreshold=")
    flags+=("--token=")
    flags+=("--user=")
    flags+=("--username=")
    flags+=("--v=")
    flags+=("--vmodule=")

    must_have_one_flag=()
    must_have_one_flag+=("--image=")
    must_have_one_noun=()
    noun_aliases=()
}

_kubectl_expose()
{
    last_command="kubectl_expose"
    commands=()

    flags=()
    two_word_flags=()
    flags_with_completion=()
    flags_completion=()

    flags+=("--container-port=")
    flags+=("--create-external-load-balancer")
    flags+=("--dry-run")
    flags+=("--external-ip=")
    flags+=("--filename=")
    flags_with_completion+=("--filename")
    flags_completion+=("__handle_filename_extension_flag json|yaml|yml")
    two_word_flags+=("-f")
    flags_with_completion+=("-f")
    flags_completion+=("__handle_filename_extension_flag json|yaml|yml")
    flags+=("--generator=")
    flags+=("--labels=")
    two_word_flags+=("-l")
    flags+=("--load-balancer-ip=")
    flags+=("--name=")
    flags+=("--no-headers")
    flags+=("--output=")
    two_word_flags+=("-o")
    flags+=("--output-version=")
    flags+=("--overrides=")
    flags+=("--port=")
    flags+=("--protocol=")
    flags+=("--record")
    flags+=("--recursive")
    flags+=("-R")
    flags+=("--save-config")
    flags+=("--selector=")
    flags+=("--session-affinity=")
    flags+=("--show-all")
    flags+=("-a")
    flags+=("--show-labels")
    flags+=("--sort-by=")
    flags+=("--target-port=")
    flags+=("--template=")
    flags_with_completion+=("--template")
    flags_completion+=("_filedir")
    flags+=("--type=")
    flags+=("--alsologtostderr")
    flags+=("--api-version=")
    flags+=("--as=")
    flags+=("--certificate-authority=")
    flags+=("--client-certificate=")
    flags+=("--client-key=")
    flags+=("--cluster=")
    flags+=("--context=")
    flags+=("--insecure-skip-tls-verify")
    flags+=("--kubeconfig=")
    flags+=("--log-backtrace-at=")
    flags+=("--log-dir=")
    flags+=("--log-flush-frequency=")
    flags+=("--logtostderr")
    flags+=("--match-server-version")
    flags+=("--namespace=")
    flags_with_completion+=("--namespace")
    flags_completion+=("__kubectl_get_namespaces")
    flags+=("--password=")
    flags+=("--server=")
    two_word_flags+=("-s")
    flags+=("--stderrthreshold=")
    flags+=("--token=")
    flags+=("--user=")
    flags+=("--username=")
    flags+=("--v=")
    flags+=("--vmodule=")

    must_have_one_flag=()
    must_have_one_noun=()
    must_have_one_noun+=("deployment")
    must_have_one_noun+=("pod")
    must_have_one_noun+=("replicaset")
    must_have_one_noun+=("replicationcontroller")
    must_have_one_noun+=("service")
    noun_aliases=()
    noun_aliases+=("deployments")
    noun_aliases+=("po")
    noun_aliases+=("pods")
    noun_aliases+=("rc")
    noun_aliases+=("replicasets")
    noun_aliases+=("replicationcontrollers")
    noun_aliases+=("rs")
    noun_aliases+=("services")
    noun_aliases+=("svc")
}

_kubectl_autoscale()
{
    last_command="kubectl_autoscale"
    commands=()

    flags=()
    two_word_flags=()
    flags_with_completion=()
    flags_completion=()

    flags+=("--cpu-percent=")
    flags+=("--dry-run")
    flags+=("--filename=")
    flags_with_completion+=("--filename")
    flags_completion+=("__handle_filename_extension_flag json|yaml|yml")
    two_word_flags+=("-f")
    flags_with_completion+=("-f")
    flags_completion+=("__handle_filename_extension_flag json|yaml|yml")
    flags+=("--generator=")
    flags+=("--include-extended-apis")
    flags+=("--max=")
    flags+=("--min=")
    flags+=("--name=")
    flags+=("--no-headers")
    flags+=("--output=")
    two_word_flags+=("-o")
    flags+=("--output-version=")
    flags+=("--record")
    flags+=("--recursive")
    flags+=("-R")
    flags+=("--save-config")
    flags+=("--show-all")
    flags+=("-a")
    flags+=("--show-labels")
    flags+=("--sort-by=")
    flags+=("--template=")
    flags_with_completion+=("--template")
    flags_completion+=("_filedir")
    flags+=("--alsologtostderr")
    flags+=("--api-version=")
    flags+=("--as=")
    flags+=("--certificate-authority=")
    flags+=("--client-certificate=")
    flags+=("--client-key=")
    flags+=("--cluster=")
    flags+=("--context=")
    flags+=("--insecure-skip-tls-verify")
    flags+=("--kubeconfig=")
    flags+=("--log-backtrace-at=")
    flags+=("--log-dir=")
    flags+=("--log-flush-frequency=")
    flags+=("--logtostderr")
    flags+=("--match-server-version")
    flags+=("--namespace=")
    flags_with_completion+=("--namespace")
    flags_completion+=("__kubectl_get_namespaces")
    flags+=("--password=")
    flags+=("--server=")
    two_word_flags+=("-s")
    flags+=("--stderrthreshold=")
    flags+=("--token=")
    flags+=("--user=")
    flags+=("--username=")
    flags+=("--v=")
    flags+=("--vmodule=")

    must_have_one_flag=()
    must_have_one_flag+=("--max=")
    must_have_one_noun=()
    noun_aliases=()
}

_kubectl_rollout_history()
{
    last_command="kubectl_rollout_history"
    commands=()

    flags=()
    two_word_flags=()
    flags_with_completion=()
    flags_completion=()

    flags+=("--filename=")
    flags_with_completion+=("--filename")
    flags_completion+=("__handle_filename_extension_flag json|yaml|yml")
    two_word_flags+=("-f")
    flags_with_completion+=("-f")
    flags_completion+=("__handle_filename_extension_flag json|yaml|yml")
    flags+=("--recursive")
    flags+=("-R")
    flags+=("--revision=")
    flags+=("--alsologtostderr")
    flags+=("--api-version=")
    flags+=("--as=")
    flags+=("--certificate-authority=")
    flags+=("--client-certificate=")
    flags+=("--client-key=")
    flags+=("--cluster=")
    flags+=("--context=")
    flags+=("--insecure-skip-tls-verify")
    flags+=("--kubeconfig=")
    flags+=("--log-backtrace-at=")
    flags+=("--log-dir=")
    flags+=("--log-flush-frequency=")
    flags+=("--logtostderr")
    flags+=("--match-server-version")
    flags+=("--namespace=")
    flags_with_completion+=("--namespace")
    flags_completion+=("__kubectl_get_namespaces")
    flags+=("--password=")
    flags+=("--server=")
    two_word_flags+=("-s")
    flags+=("--stderrthreshold=")
    flags+=("--token=")
    flags+=("--user=")
    flags+=("--username=")
    flags+=("--v=")
    flags+=("--vmodule=")

    must_have_one_flag=()
    must_have_one_noun=()
    noun_aliases=()
}

_kubectl_rollout_pause()
{
    last_command="kubectl_rollout_pause"
    commands=()

    flags=()
    two_word_flags=()
    flags_with_completion=()
    flags_completion=()

    flags+=("--filename=")
    flags_with_completion+=("--filename")
    flags_completion+=("__handle_filename_extension_flag json|yaml|yml")
    two_word_flags+=("-f")
    flags_with_completion+=("-f")
    flags_completion+=("__handle_filename_extension_flag json|yaml|yml")
    flags+=("--recursive")
    flags+=("-R")
    flags+=("--alsologtostderr")
    flags+=("--api-version=")
    flags+=("--as=")
    flags+=("--certificate-authority=")
    flags+=("--client-certificate=")
    flags+=("--client-key=")
    flags+=("--cluster=")
    flags+=("--context=")
    flags+=("--insecure-skip-tls-verify")
    flags+=("--kubeconfig=")
    flags+=("--log-backtrace-at=")
    flags+=("--log-dir=")
    flags+=("--log-flush-frequency=")
    flags+=("--logtostderr")
    flags+=("--match-server-version")
    flags+=("--namespace=")
    flags_with_completion+=("--namespace")
    flags_completion+=("__kubectl_get_namespaces")
    flags+=("--password=")
    flags+=("--server=")
    two_word_flags+=("-s")
    flags+=("--stderrthreshold=")
    flags+=("--token=")
    flags+=("--user=")
    flags+=("--username=")
    flags+=("--v=")
    flags+=("--vmodule=")

    must_have_one_flag=()
    must_have_one_noun=()
    noun_aliases=()
}

_kubectl_rollout_resume()
{
    last_command="kubectl_rollout_resume"
    commands=()

    flags=()
    two_word_flags=()
    flags_with_completion=()
    flags_completion=()

    flags+=("--filename=")
    flags_with_completion+=("--filename")
    flags_completion+=("__handle_filename_extension_flag json|yaml|yml")
    two_word_flags+=("-f")
    flags_with_completion+=("-f")
    flags_completion+=("__handle_filename_extension_flag json|yaml|yml")
    flags+=("--recursive")
    flags+=("-R")
    flags+=("--alsologtostderr")
    flags+=("--api-version=")
    flags+=("--as=")
    flags+=("--certificate-authority=")
    flags+=("--client-certificate=")
    flags+=("--client-key=")
    flags+=("--cluster=")
    flags+=("--context=")
    flags+=("--insecure-skip-tls-verify")
    flags+=("--kubeconfig=")
    flags+=("--log-backtrace-at=")
    flags+=("--log-dir=")
    flags+=("--log-flush-frequency=")
    flags+=("--logtostderr")
    flags+=("--match-server-version")
    flags+=("--namespace=")
    flags_with_completion+=("--namespace")
    flags_completion+=("__kubectl_get_namespaces")
    flags+=("--password=")
    flags+=("--server=")
    two_word_flags+=("-s")
    flags+=("--stderrthreshold=")
    flags+=("--token=")
    flags+=("--user=")
    flags+=("--username=")
    flags+=("--v=")
    flags+=("--vmodule=")

    must_have_one_flag=()
    must_have_one_noun=()
    noun_aliases=()
}

_kubectl_rollout_undo()
{
    last_command="kubectl_rollout_undo"
    commands=()

    flags=()
    two_word_flags=()
    flags_with_completion=()
    flags_completion=()

    flags+=("--filename=")
    flags_with_completion+=("--filename")
    flags_completion+=("__handle_filename_extension_flag json|yaml|yml")
    two_word_flags+=("-f")
    flags_with_completion+=("-f")
    flags_completion+=("__handle_filename_extension_flag json|yaml|yml")
    flags+=("--recursive")
    flags+=("-R")
    flags+=("--to-revision=")
    flags+=("--alsologtostderr")
    flags+=("--api-version=")
    flags+=("--as=")
    flags+=("--certificate-authority=")
    flags+=("--client-certificate=")
    flags+=("--client-key=")
    flags+=("--cluster=")
    flags+=("--context=")
    flags+=("--insecure-skip-tls-verify")
    flags+=("--kubeconfig=")
    flags+=("--log-backtrace-at=")
    flags+=("--log-dir=")
    flags+=("--log-flush-frequency=")
    flags+=("--logtostderr")
    flags+=("--match-server-version")
    flags+=("--namespace=")
    flags_with_completion+=("--namespace")
    flags_completion+=("__kubectl_get_namespaces")
    flags+=("--password=")
    flags+=("--server=")
    two_word_flags+=("-s")
    flags+=("--stderrthreshold=")
    flags+=("--token=")
    flags+=("--user=")
    flags+=("--username=")
    flags+=("--v=")
    flags+=("--vmodule=")

    must_have_one_flag=()
    must_have_one_noun=()
    noun_aliases=()
}

_kubectl_rollout_status()
{
    last_command="kubectl_rollout_status"
    commands=()

    flags=()
    two_word_flags=()
    flags_with_completion=()
    flags_completion=()

    flags+=("--filename=")
    flags_with_completion+=("--filename")
    flags_completion+=("__handle_filename_extension_flag json|yaml|yml")
    two_word_flags+=("-f")
    flags_with_completion+=("-f")
    flags_completion+=("__handle_filename_extension_flag json|yaml|yml")
    flags+=("--recursive")
    flags+=("-R")
    flags+=("--alsologtostderr")
    flags+=("--api-version=")
    flags+=("--as=")
    flags+=("--certificate-authority=")
    flags+=("--client-certificate=")
    flags+=("--client-key=")
    flags+=("--cluster=")
    flags+=("--context=")
    flags+=("--insecure-skip-tls-verify")
    flags+=("--kubeconfig=")
    flags+=("--log-backtrace-at=")
    flags+=("--log-dir=")
    flags+=("--log-flush-frequency=")
    flags+=("--logtostderr")
    flags+=("--match-server-version")
    flags+=("--namespace=")
    flags_with_completion+=("--namespace")
    flags_completion+=("__kubectl_get_namespaces")
    flags+=("--password=")
    flags+=("--server=")
    two_word_flags+=("-s")
    flags+=("--stderrthreshold=")
    flags+=("--token=")
    flags+=("--user=")
    flags+=("--username=")
    flags+=("--v=")
    flags+=("--vmodule=")

    must_have_one_flag=()
    must_have_one_noun=()
    noun_aliases=()
}

_kubectl_rollout()
{
    last_command="kubectl_rollout"
    commands=()
    commands+=("history")
    commands+=("pause")
    commands+=("resume")
    commands+=("undo")
    commands+=("status")

    flags=()
    two_word_flags=()
    flags_with_completion=()
    flags_completion=()

    flags+=("--alsologtostderr")
    flags+=("--api-version=")
    flags+=("--as=")
    flags+=("--certificate-authority=")
    flags+=("--client-certificate=")
    flags+=("--client-key=")
    flags+=("--cluster=")
    flags+=("--context=")
    flags+=("--insecure-skip-tls-verify")
    flags+=("--kubeconfig=")
    flags+=("--log-backtrace-at=")
    flags+=("--log-dir=")
    flags+=("--log-flush-frequency=")
    flags+=("--logtostderr")
    flags+=("--match-server-version")
    flags+=("--namespace=")
    flags_with_completion+=("--namespace")
    flags_completion+=("__kubectl_get_namespaces")
    flags+=("--password=")
    flags+=("--server=")
    two_word_flags+=("-s")
    flags+=("--stderrthreshold=")
    flags+=("--token=")
    flags+=("--user=")
    flags+=("--username=")
    flags+=("--v=")
    flags+=("--vmodule=")

    must_have_one_flag=()
    must_have_one_noun=()
    noun_aliases=()
}

_kubectl_label()
{
    last_command="kubectl_label"
    commands=()

    flags=()
    two_word_flags=()
    flags_with_completion=()
    flags_completion=()

    flags+=("--all")
    flags+=("--dry-run")
    flags+=("--filename=")
    flags_with_completion+=("--filename")
    flags_completion+=("__handle_filename_extension_flag json|yaml|yml")
    two_word_flags+=("-f")
    flags_with_completion+=("-f")
    flags_completion+=("__handle_filename_extension_flag json|yaml|yml")
    flags+=("--include-extended-apis")
    flags+=("--no-headers")
    flags+=("--output=")
    two_word_flags+=("-o")
    flags+=("--output-version=")
    flags+=("--overwrite")
    flags+=("--record")
    flags+=("--recursive")
    flags+=("-R")
    flags+=("--resource-version=")
    flags+=("--selector=")
    two_word_flags+=("-l")
    flags+=("--show-all")
    flags+=("-a")
    flags+=("--show-labels")
    flags+=("--sort-by=")
    flags+=("--template=")
    flags_with_completion+=("--template")
    flags_completion+=("_filedir")
    flags+=("--alsologtostderr")
    flags+=("--api-version=")
    flags+=("--as=")
    flags+=("--certificate-authority=")
    flags+=("--client-certificate=")
    flags+=("--client-key=")
    flags+=("--cluster=")
    flags+=("--context=")
    flags+=("--insecure-skip-tls-verify")
    flags+=("--kubeconfig=")
    flags+=("--log-backtrace-at=")
    flags+=("--log-dir=")
    flags+=("--log-flush-frequency=")
    flags+=("--logtostderr")
    flags+=("--match-server-version")
    flags+=("--namespace=")
    flags_with_completion+=("--namespace")
    flags_completion+=("__kubectl_get_namespaces")
    flags+=("--password=")
    flags+=("--server=")
    two_word_flags+=("-s")
    flags+=("--stderrthreshold=")
    flags+=("--token=")
    flags+=("--user=")
    flags+=("--username=")
    flags+=("--v=")
    flags+=("--vmodule=")

    must_have_one_flag=()
    must_have_one_noun=()
    must_have_one_noun+=("cluster")
    must_have_one_noun+=("clusterrole")
    must_have_one_noun+=("clusterrolebinding")
    must_have_one_noun+=("componentstatus")
    must_have_one_noun+=("configmap")
    must_have_one_noun+=("daemonset")
    must_have_one_noun+=("deployment")
    must_have_one_noun+=("endpoints")
    must_have_one_noun+=("event")
    must_have_one_noun+=("horizontalpodautoscaler")
    must_have_one_noun+=("ingress")
    must_have_one_noun+=("job")
    must_have_one_noun+=("limitrange")
    must_have_one_noun+=("namespace")
    must_have_one_noun+=("networkpolicy")
    must_have_one_noun+=("node")
    must_have_one_noun+=("persistentvolume")
    must_have_one_noun+=("persistentvolumeclaim")
    must_have_one_noun+=("petset")
    must_have_one_noun+=("pod")
    must_have_one_noun+=("podsecuritypolicy")
    must_have_one_noun+=("podtemplate")
    must_have_one_noun+=("replicaset")
    must_have_one_noun+=("replicationcontroller")
    must_have_one_noun+=("resourcequota")
    must_have_one_noun+=("role")
    must_have_one_noun+=("rolebinding")
    must_have_one_noun+=("secret")
    must_have_one_noun+=("service")
    must_have_one_noun+=("serviceaccount")
    must_have_one_noun+=("thirdpartyresource")
    must_have_one_noun+=("thirdpartyresourcedata")
    noun_aliases=()
    noun_aliases+=("clusterrolebindings")
    noun_aliases+=("clusterroles")
    noun_aliases+=("clusters")
    noun_aliases+=("componentstatuses")
    noun_aliases+=("configmaps")
    noun_aliases+=("cs")
    noun_aliases+=("daemonsets")
    noun_aliases+=("deployments")
    noun_aliases+=("ds")
    noun_aliases+=("endpoints")
    noun_aliases+=("ep")
    noun_aliases+=("ev")
    noun_aliases+=("events")
    noun_aliases+=("horizontalpodautoscalers")
    noun_aliases+=("hpa")
    noun_aliases+=("ing")
    noun_aliases+=("ingresses")
    noun_aliases+=("jobs")
    noun_aliases+=("limitranges")
    noun_aliases+=("limits")
    noun_aliases+=("namespaces")
    noun_aliases+=("networkpolicies")
    noun_aliases+=("no")
    noun_aliases+=("nodes")
    noun_aliases+=("ns")
    noun_aliases+=("persistentvolumeclaims")
    noun_aliases+=("persistentvolumes")
    noun_aliases+=("petsets")
    noun_aliases+=("po")
    noun_aliases+=("pods")
    noun_aliases+=("podsecuritypolicies")
    noun_aliases+=("podtemplates")
    noun_aliases+=("pv")
    noun_aliases+=("pvc")
    noun_aliases+=("quota")
    noun_aliases+=("rc")
    noun_aliases+=("replicasets")
    noun_aliases+=("replicationcontrollers")
    noun_aliases+=("resourcequotas")
    noun_aliases+=("rolebindings")
    noun_aliases+=("roles")
    noun_aliases+=("rs")
    noun_aliases+=("sa")
    noun_aliases+=("secrets")
    noun_aliases+=("serviceaccounts")
    noun_aliases+=("services")
    noun_aliases+=("svc")
    noun_aliases+=("thirdpartyresourcedatas")
    noun_aliases+=("thirdpartyresources")
}

_kubectl_annotate()
{
    last_command="kubectl_annotate"
    commands=()

    flags=()
    two_word_flags=()
    flags_with_completion=()
    flags_completion=()

    flags+=("--all")
    flags+=("--filename=")
    flags_with_completion+=("--filename")
    flags_completion+=("__handle_filename_extension_flag json|yaml|yml")
    two_word_flags+=("-f")
    flags_with_completion+=("-f")
    flags_completion+=("__handle_filename_extension_flag json|yaml|yml")
    flags+=("--include-extended-apis")
    flags+=("--no-headers")
    flags+=("--output=")
    two_word_flags+=("-o")
    flags+=("--output-version=")
    flags+=("--overwrite")
    flags+=("--record")
    flags+=("--recursive")
    flags+=("-R")
    flags+=("--resource-version=")
    flags+=("--selector=")
    two_word_flags+=("-l")
    flags+=("--show-all")
    flags+=("-a")
    flags+=("--show-labels")
    flags+=("--sort-by=")
    flags+=("--template=")
    flags_with_completion+=("--template")
    flags_completion+=("_filedir")
    flags+=("--alsologtostderr")
    flags+=("--api-version=")
    flags+=("--as=")
    flags+=("--certificate-authority=")
    flags+=("--client-certificate=")
    flags+=("--client-key=")
    flags+=("--cluster=")
    flags+=("--context=")
    flags+=("--insecure-skip-tls-verify")
    flags+=("--kubeconfig=")
    flags+=("--log-backtrace-at=")
    flags+=("--log-dir=")
    flags+=("--log-flush-frequency=")
    flags+=("--logtostderr")
    flags+=("--match-server-version")
    flags+=("--namespace=")
    flags_with_completion+=("--namespace")
    flags_completion+=("__kubectl_get_namespaces")
    flags+=("--password=")
    flags+=("--server=")
    two_word_flags+=("-s")
    flags+=("--stderrthreshold=")
    flags+=("--token=")
    flags+=("--user=")
    flags+=("--username=")
    flags+=("--v=")
    flags+=("--vmodule=")

    must_have_one_flag=()
    must_have_one_noun=()
    must_have_one_noun+=("componentstatuse")
    must_have_one_noun+=("event")
    must_have_one_noun+=("horizontalpodautoscaler")
    must_have_one_noun+=("limitrange")
    must_have_one_noun+=("node")
    must_have_one_noun+=("persistentvolume")
    must_have_one_noun+=("persistentvolumeclaim")
    must_have_one_noun+=("pod")
    must_have_one_noun+=("replicationcontroller")
    must_have_one_noun+=("resourcequota")
    must_have_one_noun+=("secret")
    must_have_one_noun+=("service")
    noun_aliases=()
    noun_aliases+=("componentstatuses")
    noun_aliases+=("cs")
    noun_aliases+=("ev")
    noun_aliases+=("events")
    noun_aliases+=("horizontalpodautoscalers")
    noun_aliases+=("hpa")
    noun_aliases+=("limitranges")
    noun_aliases+=("limits")
    noun_aliases+=("no")
    noun_aliases+=("nodes")
    noun_aliases+=("persistentvolumeclaims")
    noun_aliases+=("persistentvolumes")
    noun_aliases+=("po")
    noun_aliases+=("pods")
    noun_aliases+=("pv")
    noun_aliases+=("pvc")
    noun_aliases+=("quota")
    noun_aliases+=("rc")
    noun_aliases+=("replicationcontrollers")
    noun_aliases+=("resourcequotas")
    noun_aliases+=("secrets")
    noun_aliases+=("services")
    noun_aliases+=("svc")
}

_kubectl_taint()
{
    last_command="kubectl_taint"
    commands=()

    flags=()
    two_word_flags=()
    flags_with_completion=()
    flags_completion=()

    flags+=("--all")
    flags+=("--include-extended-apis")
    flags+=("--no-headers")
    flags+=("--output=")
    two_word_flags+=("-o")
    flags+=("--output-version=")
    flags+=("--overwrite")
    flags+=("--schema-cache-dir=")
    flags_with_completion+=("--schema-cache-dir")
    flags_completion+=("_filedir")
    flags+=("--selector=")
    two_word_flags+=("-l")
    flags+=("--show-all")
    flags+=("-a")
    flags+=("--show-labels")
    flags+=("--sort-by=")
    flags+=("--template=")
    flags_with_completion+=("--template")
    flags_completion+=("_filedir")
    flags+=("--validate")
    flags+=("--alsologtostderr")
    flags+=("--api-version=")
    flags+=("--as=")
    flags+=("--certificate-authority=")
    flags+=("--client-certificate=")
    flags+=("--client-key=")
    flags+=("--cluster=")
    flags+=("--context=")
    flags+=("--insecure-skip-tls-verify")
    flags+=("--kubeconfig=")
    flags+=("--log-backtrace-at=")
    flags+=("--log-dir=")
    flags+=("--log-flush-frequency=")
    flags+=("--logtostderr")
    flags+=("--match-server-version")
    flags+=("--namespace=")
    flags_with_completion+=("--namespace")
    flags_completion+=("__kubectl_get_namespaces")
    flags+=("--password=")
    flags+=("--server=")
    two_word_flags+=("-s")
    flags+=("--stderrthreshold=")
    flags+=("--token=")
    flags+=("--user=")
    flags+=("--username=")
    flags+=("--v=")
    flags+=("--vmodule=")

    must_have_one_flag=()
    must_have_one_noun=()
    must_have_one_noun+=("cluster")
    must_have_one_noun+=("clusterrole")
    must_have_one_noun+=("clusterrolebinding")
    must_have_one_noun+=("componentstatus")
    must_have_one_noun+=("configmap")
    must_have_one_noun+=("daemonset")
    must_have_one_noun+=("deployment")
    must_have_one_noun+=("endpoints")
    must_have_one_noun+=("event")
    must_have_one_noun+=("horizontalpodautoscaler")
    must_have_one_noun+=("ingress")
    must_have_one_noun+=("job")
    must_have_one_noun+=("limitrange")
    must_have_one_noun+=("namespace")
    must_have_one_noun+=("networkpolicy")
    must_have_one_noun+=("node")
    must_have_one_noun+=("persistentvolume")
    must_have_one_noun+=("persistentvolumeclaim")
    must_have_one_noun+=("petset")
    must_have_one_noun+=("pod")
    must_have_one_noun+=("podsecuritypolicy")
    must_have_one_noun+=("podtemplate")
    must_have_one_noun+=("replicaset")
    must_have_one_noun+=("replicationcontroller")
    must_have_one_noun+=("resourcequota")
    must_have_one_noun+=("role")
    must_have_one_noun+=("rolebinding")
    must_have_one_noun+=("secret")
    must_have_one_noun+=("service")
    must_have_one_noun+=("serviceaccount")
    must_have_one_noun+=("thirdpartyresource")
    must_have_one_noun+=("thirdpartyresourcedata")
    noun_aliases=()
}

_kubectl_config_view()
{
    last_command="kubectl_config_view"
    commands=()

    flags=()
    two_word_flags=()
    flags_with_completion=()
    flags_completion=()

    flags+=("--flatten")
    flags+=("--merge=")
    flags+=("--minify")
    flags+=("--no-headers")
    flags+=("--output=")
    two_word_flags+=("-o")
    flags+=("--output-version=")
    flags+=("--raw")
    flags+=("--show-all")
    flags+=("-a")
    flags+=("--show-labels")
    flags+=("--sort-by=")
    flags+=("--template=")
    flags_with_completion+=("--template")
    flags_completion+=("_filedir")
    flags+=("--alsologtostderr")
    flags+=("--api-version=")
    flags+=("--as=")
    flags+=("--certificate-authority=")
    flags+=("--client-certificate=")
    flags+=("--client-key=")
    flags+=("--cluster=")
    flags+=("--context=")
    flags+=("--insecure-skip-tls-verify")
    flags+=("--kubeconfig=")
    flags+=("--log-backtrace-at=")
    flags+=("--log-dir=")
    flags+=("--log-flush-frequency=")
    flags+=("--logtostderr")
    flags+=("--match-server-version")
    flags+=("--namespace=")
    flags_with_completion+=("--namespace")
    flags_completion+=("__kubectl_get_namespaces")
    flags+=("--password=")
    flags+=("--server=")
    two_word_flags+=("-s")
    flags+=("--stderrthreshold=")
    flags+=("--token=")
    flags+=("--user=")
    flags+=("--username=")
    flags+=("--v=")
    flags+=("--vmodule=")

    must_have_one_flag=()
    must_have_one_noun=()
    noun_aliases=()
}

_kubectl_config_set-cluster()
{
    last_command="kubectl_config_set-cluster"
    commands=()

    flags=()
    two_word_flags=()
    flags_with_completion=()
    flags_completion=()

    flags+=("--api-version=")
    flags+=("--certificate-authority=")
    flags_with_completion+=("--certificate-authority")
    flags_completion+=("_filedir")
    flags+=("--embed-certs=")
    flags+=("--insecure-skip-tls-verify=")
    flags+=("--server=")
    flags+=("--alsologtostderr")
    flags+=("--as=")
    flags+=("--client-certificate=")
    flags+=("--client-key=")
    flags+=("--cluster=")
    flags+=("--context=")
    flags+=("--kubeconfig=")
    flags+=("--log-backtrace-at=")
    flags+=("--log-dir=")
    flags+=("--log-flush-frequency=")
    flags+=("--logtostderr")
    flags+=("--match-server-version")
    flags+=("--namespace=")
    flags_with_completion+=("--namespace")
    flags_completion+=("__kubectl_get_namespaces")
    flags+=("--password=")
    flags+=("--stderrthreshold=")
    flags+=("--token=")
    flags+=("--user=")
    flags+=("--username=")
    flags+=("--v=")
    flags+=("--vmodule=")

    must_have_one_flag=()
    must_have_one_noun=()
    noun_aliases=()
}

_kubectl_config_set-credentials()
{
    last_command="kubectl_config_set-credentials"
    commands=()

    flags=()
    two_word_flags=()
    flags_with_completion=()
    flags_completion=()

    flags+=("--client-certificate=")
    flags_with_completion+=("--client-certificate")
    flags_completion+=("_filedir")
    flags+=("--client-key=")
    flags_with_completion+=("--client-key")
    flags_completion+=("_filedir")
    flags+=("--embed-certs=")
    flags+=("--password=")
    flags+=("--token=")
    flags+=("--username=")
    flags+=("--alsologtostderr")
    flags+=("--api-version=")
    flags+=("--as=")
    flags+=("--certificate-authority=")
    flags+=("--cluster=")
    flags+=("--context=")
    flags+=("--insecure-skip-tls-verify")
    flags+=("--kubeconfig=")
    flags+=("--log-backtrace-at=")
    flags+=("--log-dir=")
    flags+=("--log-flush-frequency=")
    flags+=("--logtostderr")
    flags+=("--match-server-version")
    flags+=("--namespace=")
    flags_with_completion+=("--namespace")
    flags_completion+=("__kubectl_get_namespaces")
    flags+=("--server=")
    two_word_flags+=("-s")
    flags+=("--stderrthreshold=")
    flags+=("--user=")
    flags+=("--v=")
    flags+=("--vmodule=")

    must_have_one_flag=()
    must_have_one_noun=()
    noun_aliases=()
}

_kubectl_config_set-context()
{
    last_command="kubectl_config_set-context"
    commands=()

    flags=()
    two_word_flags=()
    flags_with_completion=()
    flags_completion=()

    flags+=("--cluster=")
    flags+=("--namespace=")
    flags+=("--user=")
    flags+=("--alsologtostderr")
    flags+=("--api-version=")
    flags+=("--as=")
    flags+=("--certificate-authority=")
    flags+=("--client-certificate=")
    flags+=("--client-key=")
    flags+=("--context=")
    flags+=("--insecure-skip-tls-verify")
    flags+=("--kubeconfig=")
    flags+=("--log-backtrace-at=")
    flags+=("--log-dir=")
    flags+=("--log-flush-frequency=")
    flags+=("--logtostderr")
    flags+=("--match-server-version")
    flags+=("--password=")
    flags+=("--server=")
    two_word_flags+=("-s")
    flags+=("--stderrthreshold=")
    flags+=("--token=")
    flags+=("--username=")
    flags+=("--v=")
    flags+=("--vmodule=")

    must_have_one_flag=()
    must_have_one_noun=()
    noun_aliases=()
}

_kubectl_config_set()
{
    last_command="kubectl_config_set"
    commands=()

    flags=()
    two_word_flags=()
    flags_with_completion=()
    flags_completion=()

    flags+=("--set-raw-bytes=")
    flags+=("--alsologtostderr")
    flags+=("--api-version=")
    flags+=("--as=")
    flags+=("--certificate-authority=")
    flags+=("--client-certificate=")
    flags+=("--client-key=")
    flags+=("--cluster=")
    flags+=("--context=")
    flags+=("--insecure-skip-tls-verify")
    flags+=("--kubeconfig=")
    flags+=("--log-backtrace-at=")
    flags+=("--log-dir=")
    flags+=("--log-flush-frequency=")
    flags+=("--logtostderr")
    flags+=("--match-server-version")
    flags+=("--namespace=")
    flags_with_completion+=("--namespace")
    flags_completion+=("__kubectl_get_namespaces")
    flags+=("--password=")
    flags+=("--server=")
    two_word_flags+=("-s")
    flags+=("--stderrthreshold=")
    flags+=("--token=")
    flags+=("--user=")
    flags+=("--username=")
    flags+=("--v=")
    flags+=("--vmodule=")

    must_have_one_flag=()
    must_have_one_noun=()
    noun_aliases=()
}

_kubectl_config_unset()
{
    last_command="kubectl_config_unset"
    commands=()

    flags=()
    two_word_flags=()
    flags_with_completion=()
    flags_completion=()

    flags+=("--alsologtostderr")
    flags+=("--api-version=")
    flags+=("--as=")
    flags+=("--certificate-authority=")
    flags+=("--client-certificate=")
    flags+=("--client-key=")
    flags+=("--cluster=")
    flags+=("--context=")
    flags+=("--insecure-skip-tls-verify")
    flags+=("--kubeconfig=")
    flags+=("--log-backtrace-at=")
    flags+=("--log-dir=")
    flags+=("--log-flush-frequency=")
    flags+=("--logtostderr")
    flags+=("--match-server-version")
    flags+=("--namespace=")
    flags_with_completion+=("--namespace")
    flags_completion+=("__kubectl_get_namespaces")
    flags+=("--password=")
    flags+=("--server=")
    two_word_flags+=("-s")
    flags+=("--stderrthreshold=")
    flags+=("--token=")
    flags+=("--user=")
    flags+=("--username=")
    flags+=("--v=")
    flags+=("--vmodule=")

    must_have_one_flag=()
    must_have_one_noun=()
    noun_aliases=()
}

_kubectl_config_current-context()
{
    last_command="kubectl_config_current-context"
    commands=()

    flags=()
    two_word_flags=()
    flags_with_completion=()
    flags_completion=()

    flags+=("--alsologtostderr")
    flags+=("--api-version=")
    flags+=("--as=")
    flags+=("--certificate-authority=")
    flags+=("--client-certificate=")
    flags+=("--client-key=")
    flags+=("--cluster=")
    flags+=("--context=")
    flags+=("--insecure-skip-tls-verify")
    flags+=("--kubeconfig=")
    flags+=("--log-backtrace-at=")
    flags+=("--log-dir=")
    flags+=("--log-flush-frequency=")
    flags+=("--logtostderr")
    flags+=("--match-server-version")
    flags+=("--namespace=")
    flags_with_completion+=("--namespace")
    flags_completion+=("__kubectl_get_namespaces")
    flags+=("--password=")
    flags+=("--server=")
    two_word_flags+=("-s")
    flags+=("--stderrthreshold=")
    flags+=("--token=")
    flags+=("--user=")
    flags+=("--username=")
    flags+=("--v=")
    flags+=("--vmodule=")

    must_have_one_flag=()
    must_have_one_noun=()
    noun_aliases=()
}

_kubectl_config_use-context()
{
    last_command="kubectl_config_use-context"
    commands=()

    flags=()
    two_word_flags=()
    flags_with_completion=()
    flags_completion=()

    flags+=("--alsologtostderr")
    flags+=("--api-version=")
    flags+=("--as=")
    flags+=("--certificate-authority=")
    flags+=("--client-certificate=")
    flags+=("--client-key=")
    flags+=("--cluster=")
    flags+=("--context=")
    flags+=("--insecure-skip-tls-verify")
    flags+=("--kubeconfig=")
    flags+=("--log-backtrace-at=")
    flags+=("--log-dir=")
    flags+=("--log-flush-frequency=")
    flags+=("--logtostderr")
    flags+=("--match-server-version")
    flags+=("--namespace=")
    flags_with_completion+=("--namespace")
    flags_completion+=("__kubectl_get_namespaces")
    flags+=("--password=")
    flags+=("--server=")
    two_word_flags+=("-s")
    flags+=("--stderrthreshold=")
    flags+=("--token=")
    flags+=("--user=")
    flags+=("--username=")
    flags+=("--v=")
    flags+=("--vmodule=")

    must_have_one_flag=()
    must_have_one_noun=()
    noun_aliases=()
}

_kubectl_config()
{
    last_command="kubectl_config"
    commands=()
    commands+=("view")
    commands+=("set-cluster")
    commands+=("set-credentials")
    commands+=("set-context")
    commands+=("set")
    commands+=("unset")
    commands+=("current-context")
    commands+=("use-context")

    flags=()
    two_word_flags=()
    flags_with_completion=()
    flags_completion=()

    flags+=("--kubeconfig=")
    flags+=("--alsologtostderr")
    flags+=("--api-version=")
    flags+=("--as=")
    flags+=("--certificate-authority=")
    flags+=("--client-certificate=")
    flags+=("--client-key=")
    flags+=("--cluster=")
    flags+=("--context=")
    flags+=("--insecure-skip-tls-verify")
    flags+=("--log-backtrace-at=")
    flags+=("--log-dir=")
    flags+=("--log-flush-frequency=")
    flags+=("--logtostderr")
    flags+=("--match-server-version")
    flags+=("--namespace=")
    flags_with_completion+=("--namespace")
    flags_completion+=("__kubectl_get_namespaces")
    flags+=("--password=")
    flags+=("--server=")
    two_word_flags+=("-s")
    flags+=("--stderrthreshold=")
    flags+=("--token=")
    flags+=("--user=")
    flags+=("--username=")
    flags+=("--v=")
    flags+=("--vmodule=")

    must_have_one_flag=()
    must_have_one_noun=()
    noun_aliases=()
}

_kubectl_cluster-info_dump()
{
    last_command="kubectl_cluster-info_dump"
    commands=()

    flags=()
    two_word_flags=()
    flags_with_completion=()
    flags_completion=()

    flags+=("--all-namespaces")
    flags+=("--namespaces=")
    flags+=("--output-directory=")
    flags+=("--alsologtostderr")
    flags+=("--api-version=")
    flags+=("--as=")
    flags+=("--certificate-authority=")
    flags+=("--client-certificate=")
    flags+=("--client-key=")
    flags+=("--cluster=")
    flags+=("--context=")
    flags+=("--insecure-skip-tls-verify")
    flags+=("--kubeconfig=")
    flags+=("--log-backtrace-at=")
    flags+=("--log-dir=")
    flags+=("--log-flush-frequency=")
    flags+=("--logtostderr")
    flags+=("--match-server-version")
    flags+=("--namespace=")
    flags_with_completion+=("--namespace")
    flags_completion+=("__kubectl_get_namespaces")
    flags+=("--password=")
    flags+=("--server=")
    two_word_flags+=("-s")
    flags+=("--stderrthreshold=")
    flags+=("--token=")
    flags+=("--user=")
    flags+=("--username=")
    flags+=("--v=")
    flags+=("--vmodule=")

    must_have_one_flag=()
    must_have_one_noun=()
    noun_aliases=()
}

_kubectl_cluster-info()
{
    last_command="kubectl_cluster-info"
    commands=()
    commands+=("dump")

    flags=()
    two_word_flags=()
    flags_with_completion=()
    flags_completion=()

    flags+=("--include-extended-apis")
    flags+=("--alsologtostderr")
    flags+=("--api-version=")
    flags+=("--as=")
    flags+=("--certificate-authority=")
    flags+=("--client-certificate=")
    flags+=("--client-key=")
    flags+=("--cluster=")
    flags+=("--context=")
    flags+=("--insecure-skip-tls-verify")
    flags+=("--kubeconfig=")
    flags+=("--log-backtrace-at=")
    flags+=("--log-dir=")
    flags+=("--log-flush-frequency=")
    flags+=("--logtostderr")
    flags+=("--match-server-version")
    flags+=("--namespace=")
    flags_with_completion+=("--namespace")
    flags_completion+=("__kubectl_get_namespaces")
    flags+=("--password=")
    flags+=("--server=")
    two_word_flags+=("-s")
    flags+=("--stderrthreshold=")
    flags+=("--token=")
    flags+=("--user=")
    flags+=("--username=")
    flags+=("--v=")
    flags+=("--vmodule=")

    must_have_one_flag=()
    must_have_one_noun=()
    noun_aliases=()
}

_kubectl_api-versions()
{
    last_command="kubectl_api-versions"
    commands=()

    flags=()
    two_word_flags=()
    flags_with_completion=()
    flags_completion=()

    flags+=("--alsologtostderr")
    flags+=("--api-version=")
    flags+=("--as=")
    flags+=("--certificate-authority=")
    flags+=("--client-certificate=")
    flags+=("--client-key=")
    flags+=("--cluster=")
    flags+=("--context=")
    flags+=("--insecure-skip-tls-verify")
    flags+=("--kubeconfig=")
    flags+=("--log-backtrace-at=")
    flags+=("--log-dir=")
    flags+=("--log-flush-frequency=")
    flags+=("--logtostderr")
    flags+=("--match-server-version")
    flags+=("--namespace=")
    flags_with_completion+=("--namespace")
    flags_completion+=("__kubectl_get_namespaces")
    flags+=("--password=")
    flags+=("--server=")
    two_word_flags+=("-s")
    flags+=("--stderrthreshold=")
    flags+=("--token=")
    flags+=("--user=")
    flags+=("--username=")
    flags+=("--v=")
    flags+=("--vmodule=")

    must_have_one_flag=()
    must_have_one_noun=()
    noun_aliases=()
}

_kubectl_version()
{
    last_command="kubectl_version"
    commands=()

    flags=()
    two_word_flags=()
    flags_with_completion=()
    flags_completion=()

    flags+=("--client")
    flags+=("-c")
    flags+=("--alsologtostderr")
    flags+=("--api-version=")
    flags+=("--as=")
    flags+=("--certificate-authority=")
    flags+=("--client-certificate=")
    flags+=("--client-key=")
    flags+=("--cluster=")
    flags+=("--context=")
    flags+=("--insecure-skip-tls-verify")
    flags+=("--kubeconfig=")
    flags+=("--log-backtrace-at=")
    flags+=("--log-dir=")
    flags+=("--log-flush-frequency=")
    flags+=("--logtostderr")
    flags+=("--match-server-version")
    flags+=("--namespace=")
    flags_with_completion+=("--namespace")
    flags_completion+=("__kubectl_get_namespaces")
    flags+=("--password=")
    flags+=("--server=")
    two_word_flags+=("-s")
    flags+=("--stderrthreshold=")
    flags+=("--token=")
    flags+=("--user=")
    flags+=("--username=")
    flags+=("--v=")
    flags+=("--vmodule=")

    must_have_one_flag=()
    must_have_one_noun=()
    noun_aliases=()
}

_kubectl_explain()
{
    last_command="kubectl_explain"
    commands=()

    flags=()
    two_word_flags=()
    flags_with_completion=()
    flags_completion=()

    flags+=("--include-extended-apis")
    flags+=("--recursive")
    flags+=("--alsologtostderr")
    flags+=("--api-version=")
    flags+=("--as=")
    flags+=("--certificate-authority=")
    flags+=("--client-certificate=")
    flags+=("--client-key=")
    flags+=("--cluster=")
    flags+=("--context=")
    flags+=("--insecure-skip-tls-verify")
    flags+=("--kubeconfig=")
    flags+=("--log-backtrace-at=")
    flags+=("--log-dir=")
    flags+=("--log-flush-frequency=")
    flags+=("--logtostderr")
    flags+=("--match-server-version")
    flags+=("--namespace=")
    flags_with_completion+=("--namespace")
    flags_completion+=("__kubectl_get_namespaces")
    flags+=("--password=")
    flags+=("--server=")
    two_word_flags+=("-s")
    flags+=("--stderrthreshold=")
    flags+=("--token=")
    flags+=("--user=")
    flags+=("--username=")
    flags+=("--v=")
    flags+=("--vmodule=")

    must_have_one_flag=()
    must_have_one_noun=()
    noun_aliases=()
}

_kubectl_convert()
{
    last_command="kubectl_convert"
    commands=()

    flags=()
    two_word_flags=()
    flags_with_completion=()
    flags_completion=()

    flags+=("--filename=")
    flags_with_completion+=("--filename")
    flags_completion+=("__handle_filename_extension_flag json|yaml|yml")
    two_word_flags+=("-f")
    flags_with_completion+=("-f")
    flags_completion+=("__handle_filename_extension_flag json|yaml|yml")
    flags+=("--include-extended-apis")
    flags+=("--local")
    flags+=("--no-headers")
    flags+=("--output=")
    two_word_flags+=("-o")
    flags+=("--output-version=")
    flags+=("--recursive")
    flags+=("-R")
    flags+=("--schema-cache-dir=")
    flags_with_completion+=("--schema-cache-dir")
    flags_completion+=("_filedir")
    flags+=("--show-all")
    flags+=("-a")
    flags+=("--show-labels")
    flags+=("--sort-by=")
    flags+=("--template=")
    flags_with_completion+=("--template")
    flags_completion+=("_filedir")
    flags+=("--validate")
    flags+=("--alsologtostderr")
    flags+=("--api-version=")
    flags+=("--as=")
    flags+=("--certificate-authority=")
    flags+=("--client-certificate=")
    flags+=("--client-key=")
    flags+=("--cluster=")
    flags+=("--context=")
    flags+=("--insecure-skip-tls-verify")
    flags+=("--kubeconfig=")
    flags+=("--log-backtrace-at=")
    flags+=("--log-dir=")
    flags+=("--log-flush-frequency=")
    flags+=("--logtostderr")
    flags+=("--match-server-version")
    flags+=("--namespace=")
    flags_with_completion+=("--namespace")
    flags_completion+=("__kubectl_get_namespaces")
    flags+=("--password=")
    flags+=("--server=")
    two_word_flags+=("-s")
    flags+=("--stderrthreshold=")
    flags+=("--token=")
    flags+=("--user=")
    flags+=("--username=")
    flags+=("--v=")
    flags+=("--vmodule=")

    must_have_one_flag=()
    must_have_one_flag+=("--filename=")
    must_have_one_flag+=("-f")
    must_have_one_noun=()
    noun_aliases=()
}

_kubectl_completion()
{
    last_command="kubectl_completion"
    commands=()

    flags=()
    two_word_flags=()
    flags_with_completion=()
    flags_completion=()

    flags+=("--alsologtostderr")
    flags+=("--api-version=")
    flags+=("--as=")
    flags+=("--certificate-authority=")
    flags+=("--client-certificate=")
    flags+=("--client-key=")
    flags+=("--cluster=")
    flags+=("--context=")
    flags+=("--insecure-skip-tls-verify")
    flags+=("--kubeconfig=")
    flags+=("--log-backtrace-at=")
    flags+=("--log-dir=")
    flags+=("--log-flush-frequency=")
    flags+=("--logtostderr")
    flags+=("--match-server-version")
    flags+=("--namespace=")
    flags_with_completion+=("--namespace")
    flags_completion+=("__kubectl_get_namespaces")
    flags+=("--password=")
    flags+=("--server=")
    two_word_flags+=("-s")
    flags+=("--stderrthreshold=")
    flags+=("--token=")
    flags+=("--user=")
    flags+=("--username=")
    flags+=("--v=")
    flags+=("--vmodule=")

    must_have_one_flag=()
    must_have_one_noun=()
    must_have_one_noun+=("bash")
    must_have_one_noun+=("zsh")
    noun_aliases=()
}

_kubectl()
{
    last_command="kubectl"
    commands=()
    commands+=("get")
    commands+=("set")
    commands+=("describe")
    commands+=("create")
    commands+=("replace")
    commands+=("patch")
    commands+=("delete")
    commands+=("edit")
    commands+=("apply")
    commands+=("namespace")
    commands+=("logs")
    commands+=("rolling-update")
    commands+=("scale")
    commands+=("cordon")
    commands+=("drain")
    commands+=("uncordon")
    commands+=("attach")
    commands+=("exec")
    commands+=("port-forward")
    commands+=("proxy")
    commands+=("run")
    commands+=("expose")
    commands+=("autoscale")
    commands+=("rollout")
    commands+=("label")
    commands+=("annotate")
    commands+=("taint")
    commands+=("config")
    commands+=("cluster-info")
    commands+=("api-versions")
    commands+=("version")
    commands+=("explain")
    commands+=("convert")
    commands+=("completion")

    flags=()
    two_word_flags=()
    flags_with_completion=()
    flags_completion=()

    flags+=("--alsologtostderr")
    flags+=("--api-version=")
    flags+=("--as=")
    flags+=("--certificate-authority=")
    flags+=("--client-certificate=")
    flags+=("--client-key=")
    flags+=("--cluster=")
    flags+=("--context=")
    flags+=("--insecure-skip-tls-verify")
    flags+=("--kubeconfig=")
    flags+=("--log-backtrace-at=")
    flags+=("--log-dir=")
    flags+=("--log-flush-frequency=")
    flags+=("--logtostderr")
    flags+=("--match-server-version")
    flags+=("--namespace=")
    flags_with_completion+=("--namespace")
    flags_completion+=("__kubectl_get_namespaces")
    flags+=("--password=")
    flags+=("--server=")
    two_word_flags+=("-s")
    flags+=("--stderrthreshold=")
    flags+=("--token=")
    flags+=("--user=")
    flags+=("--username=")
    flags+=("--v=")
    flags+=("--vmodule=")

    must_have_one_flag=()
    must_have_one_noun=()
    noun_aliases=()
}

__start_kubectl()
{
    local cur prev words cword
    declare -A flaghash 2>/dev/null || :
    if declare -F _init_completion >/dev/null 2>&1; then
        _init_completion -s || return
    else
        __my_init_completion -n "=" || return
    fi

    local c=0
    local flags=()
    local two_word_flags=()
    local flags_with_completion=()
    local flags_completion=()
    local commands=("kubectl")
    local must_have_one_flag=()
    local must_have_one_noun=()
    local last_command
    local nouns=()

    __handle_word
}

if [[ $(type -t compopt) = "builtin" ]]; then
    complete -o default -F __start_kubectl kubectl
else
    complete -o default -o nospace -F __start_kubectl kubectl
fi

# ex: ts=4 sw=4 et filetype=sh

BASH_COMPLETION_EOF
)
