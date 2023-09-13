# Implementing a MERN stack 

MERN stack = MongoDB, ExpressJS, ReactJS, Node.js

- MongoDB:  MongoDB is a cross-platform, document-oriented database program. 

- ExpressJS: Express.js is a web application framework for Node.js.

- ReactJS: This is a javascript framework used to build the UI.

- Node.js: Node.js is an open-source, cross-platform, JavaScript runtime environment that executes JavaScript code outside of a web browser.

For this project, a simple to-do list app will be deployed.

spin up an Ec2 instance on AWS, SSH into the instance.

# SETTIN UP NODE.JS

run the below commands to upgrade and update the ubuntu distro

```
sudo apt update -y && sudo apt upgrade -y
```

to install nodejs, here is a link to the source ![repo](https://github.com/nodesource/distributions)

run the below command to Download and import the Nodesource GPG key:

```
sudo apt-get update
sudo apt-get install -y ca-certificates curl gnupg
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | sudo gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg
```

create DEB repository:

```
NODE_MAJOR=20
echo "deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_$NODE_MAJOR.x nodistro main" | sudo tee /etc/apt/sources.list.d/nodesource.list
```

install node and npm:

```
sudo apt update -y && sudo apt upgrade -y
sudo apt install nodejs npm -y 
node -v
npm -v
```


# CREATE A FILE DIRECTORY FOR THE TO-DO PROJECT:
create a directory for the project:

```
mkdir To-do
```

change directory to the created directory, intialize npm in that directory. Press enter repeatedly to accept default values, lastly press yes. Now there should be a package.json file in that directory

```
cd To-do
npm init
ls
```

# INSTALLING EXPRESSJS


In the to-do directory, Install express and dotenv module using npm:

```
npm install express dotenv
```

create an index.js file, open it a text editor:

````
touch index.js
nano index.js
```

Put the below code in index.js.

```
const express = require('express');
require('dotenv').config();

const app = express();

const port = process.env.PORT || 5000;

app.use((req, res, next) => {
res.header("Access-Control-Allow-Origin", "\*");
res.header("Access-Control-Allow-Headers", "Origin, X-Requested-With, Content-Type, Accept");
next();
});

app.use((req, res, next) => {
res.send('Welcome to Express');
});

app.listen(port, () => {
console.log(`Server running on port ${port}`)
});
```

save the file. Now, it's time to start the express server, in the directory of the to-do app. There should be a display of "Server running on port 5000". We specified that both in the above code. 

```
node index.js
```

proceed to the security groups of your EC2 instance, allow in-bound rules from port 5000.

open your browser. access the express instance with your <public-ip-address>:5000. Remember we specified port 5000.


![express](express.jpg)


## ROUTES
 Routes are used to define how the application will respond to different requests. What actions do you want your applications to take? For the to-do app, we want to do:

1. Create a new task
2. See list of all created tasks
3. Delete tasks

For each task, routes needs to be created for the endpoints. The tasks will be associated with the endpoints using different http requests method(GET, PUT, POST, DELETE). In the to-do folder, Make a folder routes and create an api file in the directory.

```
mkdir routes
cd routes
touch api.js
```

copy the below code into the created file.

```
const express = require ('express');
const router = express.Router();

router.get('/todos', (req, res, next) => {

});

router.post('/todos', (req, res, next) => {

});

router.delete('/todos/:id', (req, res, next) => {

})

module.exports = router;
```

# MODELS

Models help you to ensure that all documents in a collection have the same fields and that the values of those fields are of the correct type. This can help you to write cleaner, more efficient code and to avoid errors. 

Models provide a convenient way to perform CRUD (create, read, update, and delete) operations on documents. We will also use models to define the database schema.

Change directory to the to-do folder, install mongoose which is a MongoDB library, it makes it easier to work with MongoDB.

```
npm install mongoose
```

In the to-do directory, create a folder for models && a file model.js.

```
mkdir models && nano model.js
```

update the model.js app with the below code.

```
const mongoose = require('mongoose');
const Schema = mongoose.Schema;

//create schema for todo
const TodoSchema = new Schema({
action: {
type: String,
required: [true, 'The todo text field is required']
}
})

//create model for todo
const Todo = mongoose.model('todo', TodoSchema);

module.exports = Todo;
```

Remember we created a Routes folder earlier and created a file api.js in it. Update the api.js code to make use of the model. In short, delete the code and put in the below code.

```
const express = require ('express');
const router = express.Router();
const Todo = require('../models/todo');

router.get('/todos', (req, res, next) => {

//this will return all the data, exposing only the id and action field to the client
Todo.find({}, 'action')
.then(data => res.json(data))
.catch(next)
});

router.post('/todos', (req, res, next) => {
if(req.body.action){
Todo.create(req.body)
.then(data => res.json(data))
.catch(next)
}else {
res.json({
error: "The input field is empty"
})
}
});

router.delete('/todos/:id', (req, res, next) => {
Todo.findOneAndDelete({"_id": req.params.id})
.then(data => res.json(data))
.catch(next)
})

module.exports = router;
```

# SETTING UP MONGODB DATABASE









