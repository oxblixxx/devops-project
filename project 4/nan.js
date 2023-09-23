var Book = require('./models/book');

module.exports = function(app) {

  // GET /book
  app.get('/book', async function(req, res) {
    const books = await Book.find({});
    res.json(books);
  });

  // POST /book
  app.post('/book', async function(req, res) {
    const book = new Book({
      name: req.body.name,
      isbn: req.body.isbn,
      author: req.body.author,
      pages: req.body.pages
    });
    await book.save();
    res.json({
      message: 'Successfully added book',
      book
    });
  });

  // DELETE /book/:isbn
  app.delete('/book/:isbn', async function(req, res) {
    const book = await Book.findOneAndRemove({ isbn: req.params.isbn });
    res.json({
      message: 'Successfully deleted the book',
      book
    });
  });

  // Serve the index.html file for all other routes
  app.get('*', function(req, res) {
    res.sendFile('public/index.html');
  });

};
