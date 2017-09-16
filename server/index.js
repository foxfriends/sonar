'use strict';
const express = require('express');
const bodyParser = require('body-parser');
const path = require('path');

const app = express();

app.listen(process.env.PORT || 8080, () => {
  console.log('Server is listening on port 8080');
});

app.use(bodyParser.json());
