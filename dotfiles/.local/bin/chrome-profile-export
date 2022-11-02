#!/usr/bin/env bash
#
# This script will spawn a new Chrome process restricted to a profile that
# is created on demand and (optionally) deleted on exit. If a root profile
# directory is given, it will be used as the template for the newly created
# profile.
#
# NOTES:
#
# Chrome spawning takes place irrespective of any currently running Chrome
# processes. The script will always spawn a new Chrome process.
#
# If a root profile directory is not configured/passed-in as an argument, the
# created profile will be a fresh, first-time profile that does not contain
# any configuration data or extensions that may be present in a different
# profile for the same installed Chrome browser.
#
# To create a root profile, execute `chrome-private.sh --name name --keep',
# and after installing extensions and modifying browser configuration, you
# can copy/rename its directory and set it as ROOT_PROFILE_DIR (or pass it
# as an argument with --root-profile).
#
# This is free and unencumbered software released into the public domain.
# xristos@sdf.org

set -em


#
# Configuration
#


CONFIG=~/.chrome-private.rc

if [ -f "${CONFIG}" ]; then
  source "${CONFIG}"
fi

# All of the following user configuration variables can be set in
# ~/.chrome-private.rc

: "${CHROME:=google-chrome}"
: "${TMP:=/tmp}"

# A root chrome profile directory, if it exists it will be used as a template
: "${ROOT_PROFILE_DIR:=}"

# GNU mktemp is required, set this to gmktemp (coreutils) on macOS
: "${MKTEMP:=mktemp}"
: "${PROFILE_MKTEMP:=chrome.priv.prof_XXXXXXXXXX}"

: "${PROXY=socks5://127.0.0.1:5060}"

# Using a ramdisk rather than TMP is a good idea, but doubly so if you're going
# to go heavy on number of disposable profiles. hdiutil can be used to create
# a ramdisk on macOS.
: "${RAMDISK:=}"

# Remote debugging port
: "${DEBUG_PORT:=}"


#
# End of user configuration
#


CHROME_ARGS=(--disable-bundled-ppapi-flash --disable-offline-load-stale-cache
             --disk-cache-size=1 --media-cache-size=1 --disk-cache-dir=/dev/null
             --no-first-run --no-referrers --save-page-as-mhtml --no-default-browser-check)

CHROME_NO_GPU_ARGS=(--disable-gpu)
CHROME_NO_3D_ARGS=(--disable-3d-apis --disable-webgl)

keep=0
delete=0
incognito=0
use_gpu=0
use_3d=0
use_proxy=0
profile=
profile_name=
chrome_pid=0
color=0
start_color="\e[1;34m"
end_color="\e[0m"
basename="$(basename "${ROOT_PROFILE_DIR}")"

if [ -t 1 ]; then
  color=1
fi


#
# Functions
#


function usage {
  echo "Usage: $0 [--name name] [--temp-name (${PROFILE_MKTEMP})] [--keep] [--delete] [--gpu] [--3d] [--incognito] [--root-profile dir] [--profile dir] [--port port] [--proxy (${PROXY})] -- chrome-arguments"
  echo -e "  --name          name of created profile directory"
  echo -e "                  this will override --temp-name if given"
  echo -e "  --temp-name     this will be passed to mktemp(1) to generate a"
  echo -e "                  disposable profile directory name"
  echo
  echo -e "  --keep          do not delete/rename profile directory on exit"
  echo -e "                  (implied with --profile)"
  echo -e "  --delete        delete rather than rename profile directory"
  echo -e "                  (ignored with --keep / --profile)"
  echo
  echo -e "  --gpu           enable gpu acceleration"
  echo -e "  --3d            enable WebGL / 3D APIs"
  echo
  echo -e "  --incognito     start Chrome in incognito mode"
  echo -e "  --root-profile  use given directory as root profile directory"
  echo -e "  --profile dir   use given directory as profile directory (needs to exist)"
  echo -e "                  (--root-profile, --name and --temp-name are ignored)"
  echo -e "  --proxy         if given, Chrome will use a proxy (default or specified)"
  echo -e "  --port          use given port as remote debugging port"
  echo
}

function msg {
  if [ "${color}" -eq 1 ]; then
    printf "${start_color}$1${end_color}\n"
  else
    printf "%s\n" "$1"
  fi
}

function err {
  echo "Error: $*" >&2
}

function setup {
  # Optional, executed first when --profile is not given.
  # Currently used to setup the ram disk (if configured).
  if [ -d "${RAMDISK}" ]; then
    if [ -d "${ROOT_PROFILE_DIR}" ]; then
      if [ ! -d "${RAMDISK}/${basename}" ]; then
        # Copy the root profile to ramdisk
        msg "Copying reference profile from: ${ROOT_PROFILE_DIR} to: ${RAMDISK}/${basename}"
        cp -R "${ROOT_PROFILE_DIR}/." "${RAMDISK}/${basename}"
      fi
      ROOT_PROFILE_DIR="${RAMDISK}/${basename}"
    fi
    TMP="${RAMDISK}"
  fi
}

function cleanup {
  if [ -d "${profile}" ]; then
    if [ "${keep}" -eq 0 ]; then
      if [ "${delete}" -eq 0 ]; then
        mv "${profile}" "${profile}.deleted"
        msg "Renamed: ${profile}"
      else
        rm -rf "${profile}"
        msg "Deleted: ${profile}"
      fi
    fi
  else
    err "Directory ${profile} does not exist"
  fi
}

function interrupt {
  if [ "${chrome_pid}" -ne 0 ] && ps "${chrome_pid}" &>/dev/null; then
    kill "${chrome_pid}"
    wait
  fi
}


#
# Argument parsing
#


while :; do
  case "$1" in
    -h|--help)
      usage
      exit 0
      ;;
    --keep)
      keep=1
      ;;
    --delete)
      delete=1
      ;;
    --gpu)
      use_gpu=1
      ;;
    --3d)
      use_3d=1
      ;;
    --incognito)
      incognito=1
      ;;
    --name)
      if [ "$2" ] && [[ "$2" != --* ]]; then
        profile_name="$2"
        shift
      else
        err "--name requires an argument"
        exit 1
      fi
      ;;
    --temp-name)
      if [ "$2" ] && [[ "$2" != --* ]]; then
        PROFILE_MKTEMP="$2"
        shift
      else
        err "--temp-name requires an argument"
        exit 1
      fi
      ;;
    --root-profile)
      if [ "$2" ] && [[ "$2" != --* ]]; then
        ROOT_PROFILE_DIR="$2"
        basename="$(basename "${ROOT_PROFILE_DIR}")"
        shift
      else
        err "--root-profile requires a profile directory"
        exit 1
      fi
      ;;
    --profile)
      if [ "$2" ] && [[ "$2" != --* ]]; then
        profile="$2"
        shift
      else
        err "--profile requires a profile directory"
        exit 1
      fi
      ;;
    --proxy)
      use_proxy=1
      if [ "$2" ] && [[ "$2" != --* ]]; then
        PROXY="$2"
        shift
      fi
      ;;
    --port)
      if [ "$2" ] && [[ "$2" != --* ]]; then
        DEBUG_PORT="$2"
        shift
      fi
      ;;
    --)
      shift
      break
      ;;
    -?*)
      err "Unknown option: $1"
      exit 1
      ;;
    *)
      break
  esac
  shift
done


#
# End of argument parsing
#


builtin type -P "${CHROME}" &>/dev/null || { err "${CHROME}" not found; exit 1; }

if [ "${profile}" ]; then
  keep=1
  if [ -d "${profile}" ]; then
    msg "Using existing profile dir: ${profile}"
  else
    err "Directory ${profile} does not exist"
    exit 1
  fi
else
  setup
  if [ "${profile_name}" ]; then
    profile="${profile_name}"
  else
    profile="$("${MKTEMP}" -d -p "${TMP}" "${PROFILE_MKTEMP}")"
  fi

  if [ -d "${ROOT_PROFILE_DIR}" ]; then
    msg "Copying reference profile from: ${ROOT_PROFILE_DIR} to: ${profile}"
    cp -R "${ROOT_PROFILE_DIR}/." "${profile}"
  else
    msg "Using new profile dir: ${profile}"
  fi
fi

MY_ARGS=(--user-data-dir="${profile}")

if [ "${use_proxy}" -eq 1 ]; then
  msg "Using proxy: ${PROXY}"
  MY_ARGS+=(--proxy-server="${PROXY}")
fi

if [ "${incognito}" -eq 1 ]; then
  msg "Incognito mode enabled"

  MY_ARGS+=(--incognito)
fi

if [ "${use_gpu}" -eq 0 ]; then
  CHROME_ARGS=("${CHROME_ARGS[@]}" "${CHROME_NO_GPU_ARGS[@]}")
else
  msg "GPU enabled"
fi

if [ "${use_3d}" -eq 0 ]; then
  CHROME_ARGS=("${CHROME_ARGS[@]}" "${CHROME_NO_3D_ARGS[@]}")
else
  msg "3D APIs enabled"
fi

if [ "${DEBUG_PORT}" ]; then
  MY_ARGS+=(--remote-debugging-port="${DEBUG_PORT}")
  msg "Remote debugging port: ${DEBUG_PORT}"
fi


#
# Execution
#


trap cleanup EXIT
trap interrupt INT

"${CHROME}" "${CHROME_ARGS[@]}" "${MY_ARGS[@]}" "$@" 2>/dev/null &


#
# Post-execution
#


chrome_pid=$!
msg "Chrome PID: ${chrome_pid}"

wait
