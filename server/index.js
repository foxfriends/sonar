'use strict';
const express = require('express');
const bodyParser = require('body-parser');
const path = require('path');

const app = express();

app.listen(process.env.PORT || 19786, () => {
  console.log('Server is listening on port 19786');
});

app.use(bodyParser.json());
