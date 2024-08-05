# First Docker Project

It contains a MongoDB database and a Node.js REST API. It has two environments: production and development.

During this first attempt, I encountered problems with the development container, specifically with how Nodemon listens to events with volumes in a Windows environment.

Solution
To address this issue, use the --legacy-watch option with Nodemon to ensure file changes are detected correctly:

```
nodemon --legacy-watch index.js
```


### To deploy Dev:

docker-compose -f docker-compose-dev.yml up --build

docker-compose -f docker-compose-dev.yml down --rmi all --volumes --remove-orphans

### To access Container CLI:

docker exec -it proyect_1-app-1 /bin/sh 