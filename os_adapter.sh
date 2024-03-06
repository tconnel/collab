#!/usr/bin/bash -e
readonly prompt='Please input your Password:'
case "$(uname -s)" in
    Linux*)
        ;;
    Darwin*)
        ;;
    *)
        echo 'failed to determine OS type' >&2
        exit 1
        ;;
esac
