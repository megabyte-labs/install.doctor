_deno() {
    local i cur prev opts cmds
    COMPREPLY=()
    cur="${COMP_WORDS[COMP_CWORD]}"
    prev="${COMP_WORDS[COMP_CWORD-1]}"
    cmd=""
    opts=""

    for i in ${COMP_WORDS[@]}
    do
        case "${i}" in
            "$1")
                cmd="deno"
                ;;
            bench)
                cmd+="__bench"
                ;;
            bundle)
                cmd+="__bundle"
                ;;
            cache)
                cmd+="__cache"
                ;;
            check)
                cmd+="__check"
                ;;
            compile)
                cmd+="__compile"
                ;;
            completions)
                cmd+="__completions"
                ;;
            coverage)
                cmd+="__coverage"
                ;;
            doc)
                cmd+="__doc"
                ;;
            eval)
                cmd+="__eval"
                ;;
            fmt)
                cmd+="__fmt"
                ;;
            help)
                cmd+="__help"
                ;;
            info)
                cmd+="__info"
                ;;
            init)
                cmd+="__init"
                ;;
            install)
                cmd+="__install"
                ;;
            lint)
                cmd+="__lint"
                ;;
            lsp)
                cmd+="__lsp"
                ;;
            repl)
                cmd+="__repl"
                ;;
            run)
                cmd+="__run"
                ;;
            task)
                cmd+="__task"
                ;;
            test)
                cmd+="__test"
                ;;
            types)
                cmd+="__types"
                ;;
            uninstall)
                cmd+="__uninstall"
                ;;
            upgrade)
                cmd+="__upgrade"
                ;;
            vendor)
                cmd+="__vendor"
                ;;
            *)
                ;;
        esac
    done

    case "${cmd}" in
        deno)
            opts="-h -V -L -q --help --version --unstable --log-level --quiet bench bundle cache check compile completions coverage doc eval fmt init info install uninstall lsp lint repl run task test types upgrade vendor help"
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 1 ]] ; then
                COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
                return 0
            fi
            case "${prev}" in
                --log-level)
                    COMPREPLY=($(compgen -W "" -- "${cur}"))
                    return 0
                    ;;
                -L)
                    COMPREPLY=($(compgen -W "" -- "${cur}"))
                    return 0
                    ;;
                *)
                    COMPREPLY=()
                    ;;
            esac
            COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
            return 0
            ;;
        deno__bench)
            opts="-c -r -A -h -L -q --import-map --no-remote --no-npm --node-modules-dir --no-config --config --no-check --check --reload --lock --lock-write --no-lock --cert --allow-read --allow-write --allow-net --unsafely-ignore-certificate-errors --allow-env --allow-sys --allow-run --allow-ffi --allow-hrtime --allow-all --prompt --no-prompt --cached-only --location --v8-flags --seed --enable-testing-features-do-not-use --ignore --filter --watch --no-clear-screen --help --unstable --log-level --quiet <files>... <SCRIPT_ARG>..."
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 2 ]] ; then
                COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
                return 0
            fi
            case "${prev}" in
                --import-map)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --config)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                -c)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --no-check)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --check)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --reload)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                -r)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --lock)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --cert)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --allow-read)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --allow-write)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --allow-net)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --unsafely-ignore-certificate-errors)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --allow-env)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --allow-sys)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --allow-run)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --allow-ffi)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --location)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --v8-flags)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --seed)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --ignore)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --filter)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --log-level)
                    COMPREPLY=($(compgen -W "" -- "${cur}"))
                    return 0
                    ;;
                -L)
                    COMPREPLY=($(compgen -W "" -- "${cur}"))
                    return 0
                    ;;
                *)
                    COMPREPLY=()
                    ;;
            esac
            COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
            return 0
            ;;
        deno__bundle)
            opts="-c -r -h -L -q --import-map --no-remote --no-npm --node-modules-dir --no-config --config --no-check --check --reload --lock --lock-write --no-lock --cert --watch --no-clear-screen --help --unstable --log-level --quiet <source_file> <out_file>"
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 2 ]] ; then
                COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
                return 0
            fi
            case "${prev}" in
                --import-map)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --config)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                -c)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --no-check)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --check)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --reload)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                -r)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --lock)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --cert)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --log-level)
                    COMPREPLY=($(compgen -W "" -- "${cur}"))
                    return 0
                    ;;
                -L)
                    COMPREPLY=($(compgen -W "" -- "${cur}"))
                    return 0
                    ;;
                *)
                    COMPREPLY=()
                    ;;
            esac
            COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
            return 0
            ;;
        deno__cache)
            opts="-c -r -h -L -q --import-map --no-remote --no-npm --node-modules-dir --no-config --config --no-check --check --reload --lock --lock-write --no-lock --cert --help --unstable --log-level --quiet <file>..."
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 2 ]] ; then
                COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
                return 0
            fi
            case "${prev}" in
                --import-map)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --config)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                -c)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --no-check)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --check)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --reload)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                -r)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --lock)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --cert)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --log-level)
                    COMPREPLY=($(compgen -W "" -- "${cur}"))
                    return 0
                    ;;
                -L)
                    COMPREPLY=($(compgen -W "" -- "${cur}"))
                    return 0
                    ;;
                *)
                    COMPREPLY=()
                    ;;
            esac
            COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
            return 0
            ;;
        deno__check)
            opts="-c -r -h -L -q --import-map --no-remote --no-npm --node-modules-dir --config --no-config --reload --lock --lock-write --no-lock --cert --remote --help --unstable --log-level --quiet <file>..."
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 2 ]] ; then
                COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
                return 0
            fi
            case "${prev}" in
                --import-map)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --config)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                -c)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --reload)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                -r)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --lock)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --cert)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --log-level)
                    COMPREPLY=($(compgen -W "" -- "${cur}"))
                    return 0
                    ;;
                -L)
                    COMPREPLY=($(compgen -W "" -- "${cur}"))
                    return 0
                    ;;
                *)
                    COMPREPLY=()
                    ;;
            esac
            COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
            return 0
            ;;
        deno__compile)
            opts="-c -r -A -o -h -L -q --import-map --no-remote --no-npm --node-modules-dir --no-config --config --no-check --check --reload --lock --lock-write --no-lock --cert --allow-read --allow-write --allow-net --unsafely-ignore-certificate-errors --allow-env --allow-sys --allow-run --allow-ffi --allow-hrtime --allow-all --prompt --no-prompt --cached-only --location --v8-flags --seed --enable-testing-features-do-not-use --output --target --help --unstable --log-level --quiet <SCRIPT_ARG>..."
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 2 ]] ; then
                COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
                return 0
            fi
            case "${prev}" in
                --import-map)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --config)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                -c)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --no-check)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --check)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --reload)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                -r)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --lock)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --cert)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --allow-read)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --allow-write)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --allow-net)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --unsafely-ignore-certificate-errors)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --allow-env)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --allow-sys)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --allow-run)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --allow-ffi)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --location)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --v8-flags)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --seed)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --output)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                -o)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --target)
                    COMPREPLY=($(compgen -W "" -- "${cur}"))
                    return 0
                    ;;
                --log-level)
                    COMPREPLY=($(compgen -W "" -- "${cur}"))
                    return 0
                    ;;
                -L)
                    COMPREPLY=($(compgen -W "" -- "${cur}"))
                    return 0
                    ;;
                *)
                    COMPREPLY=()
                    ;;
            esac
            COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
            return 0
            ;;
        deno__completions)
            opts="-h -L -q --help --unstable --log-level --quiet bash fish powershell zsh fig"
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 2 ]] ; then
                COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
                return 0
            fi
            case "${prev}" in
                --log-level)
                    COMPREPLY=($(compgen -W "" -- "${cur}"))
                    return 0
                    ;;
                -L)
                    COMPREPLY=($(compgen -W "" -- "${cur}"))
                    return 0
                    ;;
                *)
                    COMPREPLY=()
                    ;;
            esac
            COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
            return 0
            ;;
        deno__coverage)
            opts="-h -L -q --ignore --include --exclude --lcov --output --help --unstable --log-level --quiet <files>..."
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 2 ]] ; then
                COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
                return 0
            fi
            case "${prev}" in
                --ignore)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --include)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --exclude)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --output)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --log-level)
                    COMPREPLY=($(compgen -W "" -- "${cur}"))
                    return 0
                    ;;
                -L)
                    COMPREPLY=($(compgen -W "" -- "${cur}"))
                    return 0
                    ;;
                *)
                    COMPREPLY=()
                    ;;
            esac
            COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
            return 0
            ;;
        deno__doc)
            opts="-r -h -L -q --import-map --reload --json --private --help --unstable --log-level --quiet <source_file> <filter>"
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 2 ]] ; then
                COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
                return 0
            fi
            case "${prev}" in
                --import-map)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --reload)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                -r)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --log-level)
                    COMPREPLY=($(compgen -W "" -- "${cur}"))
                    return 0
                    ;;
                -L)
                    COMPREPLY=($(compgen -W "" -- "${cur}"))
                    return 0
                    ;;
                *)
                    COMPREPLY=()
                    ;;
            esac
            COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
            return 0
            ;;
        deno__eval)
            opts="-c -r -T -p -h -L -q --import-map --no-remote --no-npm --node-modules-dir --no-config --config --no-check --check --reload --lock --lock-write --no-lock --cert --inspect --inspect-brk --cached-only --location --v8-flags --seed --enable-testing-features-do-not-use --ts --ext --print --help --unstable --log-level --quiet <CODE_ARG>..."
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 2 ]] ; then
                COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
                return 0
            fi
            case "${prev}" in
                --import-map)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --config)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                -c)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --no-check)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --check)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --reload)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                -r)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --lock)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --cert)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --inspect)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --inspect-brk)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --location)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --v8-flags)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --seed)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --ext)
                    COMPREPLY=($(compgen -W "" -- "${cur}"))
                    return 0
                    ;;
                --log-level)
                    COMPREPLY=($(compgen -W "" -- "${cur}"))
                    return 0
                    ;;
                -L)
                    COMPREPLY=($(compgen -W "" -- "${cur}"))
                    return 0
                    ;;
                *)
                    COMPREPLY=()
                    ;;
            esac
            COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
            return 0
            ;;
        deno__fmt)
            opts="-c -h -L -q --config --no-config --check --ext --ignore --watch --no-clear-screen --options-use-tabs --options-line-width --options-indent-width --options-single-quote --options-prose-wrap --help --unstable --log-level --quiet <files>..."
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 2 ]] ; then
                COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
                return 0
            fi
            case "${prev}" in
                --config)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                -c)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --ext)
                    COMPREPLY=($(compgen -W "" -- "${cur}"))
                    return 0
                    ;;
                --ignore)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --options-line-width)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --options-indent-width)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --options-prose-wrap)
                    COMPREPLY=($(compgen -W "" -- "${cur}"))
                    return 0
                    ;;
                --log-level)
                    COMPREPLY=($(compgen -W "" -- "${cur}"))
                    return 0
                    ;;
                -L)
                    COMPREPLY=($(compgen -W "" -- "${cur}"))
                    return 0
                    ;;
                *)
                    COMPREPLY=()
                    ;;
            esac
            COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
            return 0
            ;;
        deno__help)
            opts="-L -q --unstable --log-level --quiet <SUBCOMMAND>..."
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 2 ]] ; then
                COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
                return 0
            fi
            case "${prev}" in
                --log-level)
                    COMPREPLY=($(compgen -W "" -- "${cur}"))
                    return 0
                    ;;
                -L)
                    COMPREPLY=($(compgen -W "" -- "${cur}"))
                    return 0
                    ;;
                *)
                    COMPREPLY=()
                    ;;
            esac
            COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
            return 0
            ;;
        deno__info)
            opts="-r -c -h -L -q --reload --cert --location --no-check --no-config --config --import-map --node-modules-dir --json --help --unstable --log-level --quiet <file>"
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 2 ]] ; then
                COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
                return 0
            fi
            case "${prev}" in
                --reload)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                -r)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --cert)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --location)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --no-check)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --config)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                -c)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --import-map)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --log-level)
                    COMPREPLY=($(compgen -W "" -- "${cur}"))
                    return 0
                    ;;
                -L)
                    COMPREPLY=($(compgen -W "" -- "${cur}"))
                    return 0
                    ;;
                *)
                    COMPREPLY=()
                    ;;
            esac
            COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
            return 0
            ;;
        deno__init)
            opts="-h -L -q --help --unstable --log-level --quiet <dir>"
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 2 ]] ; then
                COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
                return 0
            fi
            case "${prev}" in
                --log-level)
                    COMPREPLY=($(compgen -W "" -- "${cur}"))
                    return 0
                    ;;
                -L)
                    COMPREPLY=($(compgen -W "" -- "${cur}"))
                    return 0
                    ;;
                *)
                    COMPREPLY=()
                    ;;
            esac
            COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
            return 0
            ;;
        deno__install)
            opts="-c -r -A -n -f -h -L -q --import-map --no-remote --no-npm --node-modules-dir --no-config --config --no-check --check --reload --lock --lock-write --no-lock --cert --allow-read --allow-write --allow-net --unsafely-ignore-certificate-errors --allow-env --allow-sys --allow-run --allow-ffi --allow-hrtime --allow-all --prompt --no-prompt --inspect --inspect-brk --cached-only --location --v8-flags --seed --enable-testing-features-do-not-use --name --root --force --help --unstable --log-level --quiet <cmd>..."
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 2 ]] ; then
                COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
                return 0
            fi
            case "${prev}" in
                --import-map)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --config)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                -c)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --no-check)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --check)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --reload)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                -r)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --lock)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --cert)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --allow-read)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --allow-write)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --allow-net)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --unsafely-ignore-certificate-errors)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --allow-env)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --allow-sys)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --allow-run)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --allow-ffi)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --inspect)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --inspect-brk)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --location)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --v8-flags)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --seed)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --name)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                -n)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --root)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --log-level)
                    COMPREPLY=($(compgen -W "" -- "${cur}"))
                    return 0
                    ;;
                -L)
                    COMPREPLY=($(compgen -W "" -- "${cur}"))
                    return 0
                    ;;
                *)
                    COMPREPLY=()
                    ;;
            esac
            COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
            return 0
            ;;
        deno__lint)
            opts="-c -h -L -q --rules --rules-tags --rules-include --rules-exclude --no-config --config --ignore --json --compact --watch --no-clear-screen --help --unstable --log-level --quiet <files>..."
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 2 ]] ; then
                COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
                return 0
            fi
            case "${prev}" in
                --rules-tags)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --rules-include)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --rules-exclude)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --config)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                -c)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --ignore)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --log-level)
                    COMPREPLY=($(compgen -W "" -- "${cur}"))
                    return 0
                    ;;
                -L)
                    COMPREPLY=($(compgen -W "" -- "${cur}"))
                    return 0
                    ;;
                *)
                    COMPREPLY=()
                    ;;
            esac
            COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
            return 0
            ;;
        deno__lsp)
            opts="-h -L -q --help --unstable --log-level --quiet"
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 2 ]] ; then
                COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
                return 0
            fi
            case "${prev}" in
                --log-level)
                    COMPREPLY=($(compgen -W "" -- "${cur}"))
                    return 0
                    ;;
                -L)
                    COMPREPLY=($(compgen -W "" -- "${cur}"))
                    return 0
                    ;;
                *)
                    COMPREPLY=()
                    ;;
            esac
            COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
            return 0
            ;;
        deno__repl)
            opts="-c -r -h -L -q --import-map --no-remote --no-npm --node-modules-dir --no-config --config --no-check --check --reload --lock --lock-write --no-lock --cert --inspect --inspect-brk --cached-only --location --v8-flags --seed --enable-testing-features-do-not-use --eval-file --eval --unsafely-ignore-certificate-errors --help --unstable --log-level --quiet"
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 2 ]] ; then
                COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
                return 0
            fi
            case "${prev}" in
                --import-map)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --config)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                -c)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --no-check)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --check)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --reload)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                -r)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --lock)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --cert)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --inspect)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --inspect-brk)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --location)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --v8-flags)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --seed)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --eval-file)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --eval)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --unsafely-ignore-certificate-errors)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --log-level)
                    COMPREPLY=($(compgen -W "" -- "${cur}"))
                    return 0
                    ;;
                -L)
                    COMPREPLY=($(compgen -W "" -- "${cur}"))
                    return 0
                    ;;
                *)
                    COMPREPLY=()
                    ;;
            esac
            COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
            return 0
            ;;
        deno__run)
            opts="-c -r -A -h -L -q --import-map --no-remote --no-npm --node-modules-dir --no-config --config --no-check --check --reload --lock --lock-write --no-lock --cert --allow-read --allow-write --allow-net --unsafely-ignore-certificate-errors --allow-env --allow-sys --allow-run --allow-ffi --allow-hrtime --allow-all --prompt --no-prompt --inspect --inspect-brk --cached-only --location --v8-flags --seed --enable-testing-features-do-not-use --watch --no-clear-screen --help --unstable --log-level --quiet <SCRIPT_ARG>..."
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 2 ]] ; then
                COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
                return 0
            fi
            case "${prev}" in
                --import-map)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --config)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                -c)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --no-check)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --check)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --reload)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                -r)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --lock)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --cert)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --allow-read)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --allow-write)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --allow-net)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --unsafely-ignore-certificate-errors)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --allow-env)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --allow-sys)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --allow-run)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --allow-ffi)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --inspect)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --inspect-brk)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --location)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --v8-flags)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --seed)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --watch)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --log-level)
                    COMPREPLY=($(compgen -W "" -- "${cur}"))
                    return 0
                    ;;
                -L)
                    COMPREPLY=($(compgen -W "" -- "${cur}"))
                    return 0
                    ;;
                *)
                    COMPREPLY=()
                    ;;
            esac
            COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
            return 0
            ;;
        deno__task)
            opts="-c -h -L -q --config --cwd --help --unstable --log-level --quiet <task_name_and_args>..."
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 2 ]] ; then
                COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
                return 0
            fi
            case "${prev}" in
                --config)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                -c)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --cwd)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --log-level)
                    COMPREPLY=($(compgen -W "" -- "${cur}"))
                    return 0
                    ;;
                -L)
                    COMPREPLY=($(compgen -W "" -- "${cur}"))
                    return 0
                    ;;
                *)
                    COMPREPLY=()
                    ;;
            esac
            COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
            return 0
            ;;
        deno__test)
            opts="-c -r -A -j -h -L -q --import-map --no-remote --no-npm --node-modules-dir --no-config --config --no-check --check --reload --lock --lock-write --no-lock --cert --allow-read --allow-write --allow-net --unsafely-ignore-certificate-errors --allow-env --allow-sys --allow-run --allow-ffi --allow-hrtime --allow-all --prompt --no-prompt --inspect --inspect-brk --cached-only --location --v8-flags --seed --enable-testing-features-do-not-use --ignore --no-run --trace-ops --doc --fail-fast --allow-none --filter --shuffle --coverage --parallel --jobs --watch --no-clear-screen --help --unstable --log-level --quiet <files>... <SCRIPT_ARG>..."
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 2 ]] ; then
                COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
                return 0
            fi
            case "${prev}" in
                --import-map)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --config)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                -c)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --no-check)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --check)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --reload)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                -r)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --lock)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --cert)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --allow-read)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --allow-write)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --allow-net)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --unsafely-ignore-certificate-errors)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --allow-env)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --allow-sys)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --allow-run)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --allow-ffi)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --inspect)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --inspect-brk)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --location)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --v8-flags)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --seed)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --ignore)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --fail-fast)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --filter)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --shuffle)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --coverage)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --jobs)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                -j)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --log-level)
                    COMPREPLY=($(compgen -W "" -- "${cur}"))
                    return 0
                    ;;
                -L)
                    COMPREPLY=($(compgen -W "" -- "${cur}"))
                    return 0
                    ;;
                *)
                    COMPREPLY=()
                    ;;
            esac
            COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
            return 0
            ;;
        deno__types)
            opts="-h -L -q --help --unstable --log-level --quiet"
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 2 ]] ; then
                COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
                return 0
            fi
            case "${prev}" in
                --log-level)
                    COMPREPLY=($(compgen -W "" -- "${cur}"))
                    return 0
                    ;;
                -L)
                    COMPREPLY=($(compgen -W "" -- "${cur}"))
                    return 0
                    ;;
                *)
                    COMPREPLY=()
                    ;;
            esac
            COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
            return 0
            ;;
        deno__uninstall)
            opts="-h -L -q --root --help --unstable --log-level --quiet <name>"
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 2 ]] ; then
                COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
                return 0
            fi
            case "${prev}" in
                --root)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --log-level)
                    COMPREPLY=($(compgen -W "" -- "${cur}"))
                    return 0
                    ;;
                -L)
                    COMPREPLY=($(compgen -W "" -- "${cur}"))
                    return 0
                    ;;
                *)
                    COMPREPLY=()
                    ;;
            esac
            COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
            return 0
            ;;
        deno__upgrade)
            opts="-f -h -L -q --version --output --dry-run --force --canary --cert --help --unstable --log-level --quiet"
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 2 ]] ; then
                COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
                return 0
            fi
            case "${prev}" in
                --version)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --output)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --cert)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --log-level)
                    COMPREPLY=($(compgen -W "" -- "${cur}"))
                    return 0
                    ;;
                -L)
                    COMPREPLY=($(compgen -W "" -- "${cur}"))
                    return 0
                    ;;
                *)
                    COMPREPLY=()
                    ;;
            esac
            COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
            return 0
            ;;
        deno__vendor)
            opts="-f -c -r -h -L -q --output --force --no-config --config --import-map --lock --reload --cert --help --unstable --log-level --quiet <specifiers>..."
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 2 ]] ; then
                COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
                return 0
            fi
            case "${prev}" in
                --output)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --config)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                -c)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --import-map)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --lock)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --reload)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                -r)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --cert)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --log-level)
                    COMPREPLY=($(compgen -W "" -- "${cur}"))
                    return 0
                    ;;
                -L)
                    COMPREPLY=($(compgen -W "" -- "${cur}"))
                    return 0
                    ;;
                *)
                    COMPREPLY=()
                    ;;
            esac
            COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
            return 0
            ;;
    esac
}

complete -F _deno -o bashdefault -o default deno
