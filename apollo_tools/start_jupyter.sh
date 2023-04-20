#! /bin/sh

DIR=$(pwd)
MEM=<desired_memory>
QUEUE=<apollo_queue>
CONDA_VERSION="2020.11"
CONDA_ENV=<your_conda_env>
PORT=<port_of_choice>

print_usage() {
  printf "Usage: -f Force restart of existing screen session
       -n <screen_name>
"
}

FORCE=false
SCREEN_NAME="jupyter_screen"
while getopts 'fn:' flag; do
  case "${flag}" in
    f) FORCE=true ;;
    n) SCREEN_NAME="${OPTARG}" ;;
    *) print_usage
       exit 1 ;;
  esac
done

SCREEN_EXIST=$(screen -list | grep $SCREEN_NAME >>\dev\null; echo $?)

if [[ $SCREEN_EXIST -eq 1 ]] || [[ $FORCE = true ]]; then

screen -S $SCREEN_NAME -X quit >> \dev\null
[ -e screenlog.0 ] && rm screenlog.0
screen -S $SCREEN_NAME -d -m -L
screen -S $SCREEN_NAME -X stuff "qlogin -l h_vmem=$MEM -q $QUEUE\r"
screen -S $SCREEN_NAME -X stuff "module load easybuild/software\r"
screen -S $SCREEN_NAME -X stuff "module load Anaconda3/$CONDA_VERSION\r"
screen -S $SCREEN_NAME -X stuff "conda activate $CONDA_ENV\r"
screen -S $SCREEN_NAME -X stuff "cd $DIR\r"
screen -S $SCREEN_NAME -X stuff "jupyter notebook --ip=0.0.0.0 --port=$PORT --no-browser\r"

fi

until grep -E 'session to host' screenlog.0 >> /dev/null; do : ; done
NN=$(grep -E 'session to host' screenlog.0 | sed -n -e 's/^.*session to host node//p' | sed 's/....$//')
echo "Node number: $NN"
until grep -E 'http://127.0.0.1' screenlog.0 >> /dev/null; do : ; done
grep -E 'http://127.0.0.1' screenlog.0 | head -1 | sed -n -e 's/^.*or //p'
