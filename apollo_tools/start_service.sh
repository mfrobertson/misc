#!/bin/sh

print_usage() {
  printf "Usage: -c Number of cores
       -m Memory
       -f Force restart of existing screen session (optional)
       -t <type> (default=jupyter)
       -n <screen_name> (optional)
"
}

FORCE=false
TYP="jupyter"
SCREEN_NAME=""
while getopts 'm:c:ft:n:' flag; do
  case "${flag}" in
    m) MEM="$OPTARG" ;;
    c) NCORE="$OPTARG" ;;
    f) FORCE=true ;;
    t) TYP="$OPTARG" ;;
    n) SCREEN_NAME="${OPTARG}" ;;
    *) print_usage
       exit 1 ;;
  esac
done
shift $((OPTIND - 1))

DIR=$(pwd)
QUEUE=<apollo_queue>
CONDA_ENV=<your_conda_env>
PORT=<port_of_choice>
CONDA_VERSION="2020.11"
JC="verylong"

JUPYTER=false
VSCODE=false
if [ "$TYP" = "jupyter" ]; then
    JUPYTER=true
fi
if [ "$TYP" = "vscode" ]; then
    VSCODE=true
fi

if [ "$SCREEN_NAME" = "" ]; then
    SCREEN_NAME="${TYP}_screen"
fi

LOG="${SCREEN_NAME}.log"
SCREEN_EXIST=$(screen -list | grep $SCREEN_NAME >> /dev/null; echo $?)
if [[ $SCREEN_EXIST -eq 1 ]] || [[ $FORCE = true ]]; then
screen -S $SCREEN_NAME -X quit >> \dev\null
[ -e screenlog.0 ] && rm screenlog.0
screen -S $SCREEN_NAME -d -m -L
screen -S $SCREEN_NAME -X stuff "qlogin -N $TYP -now no -jc $JC -l h_vmem=$MEM -q $QUEUE -pe openmp $NCORE -l 'h=!node010&!node018&!node019'\r"

if [[ $JUPYTER = true ]]; then
screen -S $SCREEN_NAME -X stuff "module load easybuild/software\r"
screen -S $SCREEN_NAME -X stuff "module load Anaconda3/$CONDA_VERSION\r"
screen -S $SCREEN_NAME -X stuff "conda activate $CONDA_ENV\r"
screen -S $SCREEN_NAME -X stuff "cd $DIR\r"
screen -S $SCREEN_NAME -X stuff "jupyter-lab --ip=0.0.0.0 --port=$PORT --no-browser\r"
fi

if [[ $VSCODE = true ]]; then
screen -S $SCREEN_NAME -X stuff "module load code-server\r"
screen -S $SCREEN_NAME -X stuff "echo -e '\nbind-addr: 0.0.0.0:$((PORT+1))\nauth: password\npassword: vscodepassword\ncert: false'>~/.config/code-server/config.yaml\r"
screen -S $SCREEN_NAME -X stuff "code-server\r"
fi

until grep -E 'http://' screenlog.0 >> /dev/null; do : ; done
cp screenlog.0 $LOG

fi

#until grep -E 'session to host' screenlog.0 >> /dev/null; do : ; done
NN=$(grep -E 'session to host' $LOG | sed -n -e 's/^.*session to host node//p' | sed 's/....$//')
echo "Node number: $NN"
#until grep -E 'http://' screenlog.0 >> /dev/null; do : ; done
grep -E 'http://127.0.0.1' $LOG | head -1 | sed -n -e 's/^.*or //p'
grep -E 'http://' $LOG | head -1 | sed -n -e 's/^.*on //p'
