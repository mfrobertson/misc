#! /bin/sh

DIR=$(pwd)
MEM=<desired_memory>
QUEUE=<apollo_queue>
CONDA_VERSION="2020.11"
CONDA_ENV=<your_conda_env>
PORT=<port_of_choice>


[ -e screenlog.0 ] && rm screenlog.0
screen -S jupyter_screen -d -m -L
screen -S jupyter_screen -X stuff "qlogin -l h_vmem=$MEM -q $QUEUE\r"
screen -S jupyter_screen -X stuff "module load easybuild/software\r"
screen -S jupyter_screen -X stuff "module load Anaconda3/$CONDA_VERSION\r"
screen -S jupyter_screen -X stuff "conda activate $CONDA_ENV\r"
screen -S jupyter_screen -X stuff "cd $DIR\r"
screen -S jupyter_screen -X stuff "jupyter notebook --ip=0.0.0.0 --port=$PORT --no-browser\r"
until grep -E 'session to host' screenlog.0 >> /dev/null; do : ; done
NN=$(grep -E 'session to host' screenlog.0 | sed -n -e 's/^.*session to host node//p' | sed 's/....$//')
echo "Node number: $NN"
until grep -E 'http://127.0.0.1' screenlog.0 >> /dev/null; do : ; done
grep -E 'http://127.0.0.1' screenlog.0 | head -1 | sed -n -e 's/^.*or //p'
