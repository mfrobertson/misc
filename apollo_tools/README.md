# Apollo Tools

### Jupyter on Apollo
Quick scripts for automating jupyter notebook connections on University of Sussex Apollo
HPC. 

### Instructions
- Edit parameters in ```start_jupyter.sh``` and ```open_jupyter_port_forward.sh``` to match your use-case 
(ensure same port is used in both) 
- Execute script on Apollo
  ```
  $ ./start_jupyter.sh
  ```
  (you may first need to make it executable ```chmod +x start_jupyter.sh```)
- When ready, the script will output the host node ID and url of the jupyter notebook session, e.g.
  ```
  $ ./start_jupyter.sh
  Node number: 007
  http://127.0.0.1:12345/?token=762a0a8cf98a5f22ff88d01d20a71ffe1f98d2184459d6c2
  ```
- Now on your local machine execute 
  ```
  $ open_jupyter_port_forward.sh <node_id>
  ```
  where ```<node_id>``` matches the previously output Node number (in this example ```007```)
- Everything is set up and jupyter can now be accessed on your local machine at the specified url