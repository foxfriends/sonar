'use strict';

function success(data = null) {
  return JSON.stringify({ status: 'SUCCESS', data });
}

function failure(reason) {
  return JSON.stringify({ status: 'FAILURE', reason });
}

module.exports = { success, failure };
