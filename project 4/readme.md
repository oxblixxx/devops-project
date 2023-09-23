# MEAN STACK

In this project we will be deploying a MEAN stack project. The components of MEAN are:
- MongoDB : A database to store and retrieve data.
- Express : A back-end application framework.
- Angular : This is a frontend application framework.
- Node.js : Javascript runtime environment.


Spin up an instance on AWS, if you don't know how to do so watch this quick [video](https://www.youtube.com/watch?v=LZXWlF5udYs&pp=ygURc3BpbiBhd3MgaW5zdGFuY2U%3D). Instance type ec2 micro is sufficient fro this project. Allow port 22 and port 80 access to the instance. Use your preferred access to the instance either the console or ssh client. 

For this project we are implementing a book register. 


Create a folder 'book-register' also create a folder named apps

````sh
mkdir book-register
cd book-register
mkdir apps
```


# SETTING UP NODEJS
SSH into the spinned instance. run:

```sh
sudo apt update -y && sudo apt upgrade -y
sudo apt -y install curl dirmngr apt-transport-https lsb-release ca-certificates
```

Add Nodejs certificate

```sh
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | sudo gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg
```


```sh
NODE_MAJOR=20
echo "deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_$NODE_MAJOR.x nodistro main" | sudo tee /etc/apt/sources.list.d/nodesource.list
sudo apt install nodejs -y
node -v
```

Install npm - Node package manager

```sh
sudo apt install npm -y
npm -v
```

We need 'body-parser' to process JSON files sent in requests to the server.

```sh
sudo npm install body-parser
```

Change directory to book-register, initialize the npm project in there, add a file server.js
press enter after the prompt then yes

```sh
sudo npm init
nano server.js
```

paste the below code in server.js
```
var express = require('express');
var bodyParser = require('body-parser');
var app = express();
app.use(express.static(__dirname + '/public'));
app.use(bodyParser.json());
require('./apps/routes')(app);
app.set('port', 3300);
app.listen(app.get('port'), function() {
    console.log('Server up: http://localhost:' + app.get('port'));
});
```




# Install MongoDB
In our MongoDB server, we will be adding the book records. 

```sh
sudo apt install mongodb -y
```

Check if Mongodb is running if it's not running, then start it and verify if it's up.

```sh
sudo systemctl status mongodb
sudo systemctl start mongodb
sudo systemctl status mongodb
```

# INSTALL EXPRESSS AND SET UP ROUTES
We will use Express to interact with our server. Mongoose package will initiate a schema for the database to store data of our book in the server.

```sh
sudo npm install express mongoose
```

Change directory to our previously created apps folder, then create a file routes.js

```sh
nano routes.js
```

copy and paste the below code to routes.js

```js
var Book = require('./models/book');
module.exports = function(app) {
  app.get('/book', function(req, res) {
    Book.find({}, function(err, result) {
      if ( err ) throw err;
      res.json(result);
    });
  }); 
  app.post('/book', function(req, res) {
    var book = new Book( {
      name:req.body.name,
      isbn:req.body.isbn,
      author:req.body.author,
      pages:req.body.pages
    });
    book.save(function(err, result) {
      if ( err ) throw err;
      res.json( {
        message:"Successfully added book",
        book:result
      });
    });
  });
  app.delete("/book/:isbn", function(req, res) {
    Book.findOneAndRemove(req.query, function(err, result) {
      if ( err ) throw err;
      res.json( {
        message: "Successfully deleted the book",
        book: result
      });
    });
  });
  var path = require('path');
  app.get('*', function(req, res) {
    res.sendfile(path.join(__dirname + '/public', 'index.html'));
  });
};
```

In the apps directory, create a folder models then create a book.js in the models directory

```sh
mkdir models
cd models
nano book.js
```

Paste the below code in book.js

```js
var mongoose = require('mongoose');
var dbHost = 'mongodb://localhost:27017/test';
mongoose.connect(dbHost);
mongoose.connection;
mongoose.set('debug', true);
var bookSchema = mongoose.Schema( {
  name: String,
  isbn: {type: String, index: true},
  author: String,
  pages: Number
});
var Book = mongoose.model('Book', bookSchema);
module.exports = mongoose.model('Book', bookSchema);
```

# SETIING UP ANGULAR

Set up Angular to connect with Express and interact with our database with chosen actions.

Change directory to book-register

```sh
cd ../..
```

Create a folder named public and a file script.js in it.

```sh
mkdir public && cd public && touch script.js
```

paste the code below(controller configuration) into script.js

```js
var app = angular.module('myApp', []);
app.controller('myCtrl', function($scope, $http) {
  $http( {
    method: 'GET',
    url: '/book'
  }).then(function successCallback(response) {
    $scope.books = response.data;
  }, function errorCallback(response) {
    console.log('Error: ' + response);
  });
  $scope.del_book = function(book) {
    $http( {
      method: 'DELETE',
      url: '/book/:isbn',
      params: {'isbn': book.isbn}
    }).then(function successCallback(response) {
      console.log(response);
    }, function errorCallback(response) {
      console.log('Error: ' + response);
    });
  };
  $scope.add_book = function() {
    var body = '{ "name": "' + $scope.Name + 
    '", "isbn": "' + $scope.Isbn +
    '", "author": "' + $scope.Author + 
    '", "pages": "' + $scope.Pages + '" }';
    $http({
      method: 'POST',
      url: '/book',
      data: body
    }).then(function successCallback(response) {
      console.log(response);
    }, function errorCallback(response) {
      console.log('Error: ' + response);
    });
  };
});
```

Change directory to the public folder create a file index.html

```sh
pwd
touch index.html
```

paste the below code into index.html

```html
<!doctype html>
<html ng-app="myApp" ng-controller="myCtrl">
  <head>
    <script src="https://ajax.googleapis.com/ajax/libs/angularjs/1.6.4/angular.min.js"></script>
    <script src="script.js"></script>
  </head>
  <body>
    <div>
      <table>
        <tr>
          <td>Name:</td>
          <td><input type="text" ng-model="Name"></td>
        </tr>
        <tr>
          <td>Isbn:</td>
          <td><input type="text" ng-model="Isbn"></td>
        </tr>
        <tr>
          <td>Author:</td>
          <td><input type="text" ng-model="Author"></td>
        </tr>
        <tr>
          <td>Pages:</td>
          <td><input type="number" ng-model="Pages"></td>
        </tr>
      </table>
      <button ng-click="add_book()">Add</button>
    </div>
    <hr>
    <div>
      <table>
        <tr>
          <th>Name</th>
          <th>Isbn</th>
          <th>Author</th>
          <th>Pages</th>

        </tr>
        <tr ng-repeat="book in books">
          <td>{{book.name}}</td>
          <td>{{book.isbn}}</td>
          <td>{{book.author}}</td>
          <td>{{book.pages}}</td>

          <td><input type="button" value="Delete" data-ng-click="del_book(book)"></td>
        </tr>
      </table>
    </div>
  </body>
</html>
```







