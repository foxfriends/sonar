'use strict';
const apn = require('apn');

function suggestion(devices, user, track) {
  // TODO: exact message and payload??
  const note = new apn.Notification({
    aps: {
      alert: `${user.name} suggests you listen to ${track.name} by ${track.artists[0].name}`
    },
    song: track.id,
    from: user,
  });
}

module.exports = { suggestion };
