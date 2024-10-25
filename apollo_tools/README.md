# Apollo Tools

### Jupyter on Apollo
Quick scripts for automating jupyter notebook connections on University of Sussex Apollo
HPC. 

### Instructions
- Edit parameters in ```start_service.sh``` and ```open_jupyter_port_forward.sh``` and ```open_jupyter_port_forward.sh``` to match your use-case 
(ensure same ports in start_service match the ports in the port_forward scripts) 
- Execute script on Apollo to start jupyter or vscode (for 2 cores each with 4G ram)
  ```
  $ ./start_service.sh -c 2 -m 4 -t <"jupyter" or "vscode">
  ```
  (you may first need to make it executable ```chmod +x start_service.sh```)
- When ready, the script will output the host node ID and url of the session, e.g.
  ```
  Node number: 007
  http://127.0.0.1:12345/?token=762a0a8cf98a5f22ff88d01d20a71ffe1f98d2184459d6c2
  ```
- Now on your local machine execute either 
  ```
  $ open_port_forward.sh <node_id> <port>
  ```
  where ```<node_id>``` matches the previously output Node number (in this example ```007```)
- Everything is set up and the jupyter (or vscode) session can now be accessed on your local machine at the specified url
- Note that vscode requires a password (default is "supersecurepassword") which can be changed by editing the ```start_service.sh``` file
