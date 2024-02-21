const express = require('express');
const morgan = require('morgan');
const dgram = require('dgram');
const http = require('http');
const path = require('path');
const WebSocket = require('ws');
const app = express();
const httpPort = 8000;

/* ************* */
/* THE HTTP PART */
// Use morgan to log HTTP requests 
app.use(morgan('dev'));

// Serve static files from 'pyry-peli' directory
// set default html to 'main.html'
app.get('/', (req, res) => {
  res.sendFile(path.join(__dirname, 'site', 'index.html'));
})
app.use(express.static('site'));

// Start the server
app.listen(httpPort, () => {
  console.log(`Server running at http://localhost:${httpPort}/`);
});
/* ************* */