'use strict';
const clientId = 'c496fe2e11c842109d9cee3fc7a2cfc6';
const clientSecret = '1b35877e9d1d4d79a250ca5fb06bd890'; // TODO: take the secret out of the code!
const redirectUri = 'http://localhost:19786/spotify/authorized';

const SpotifyWebApi = require('spotify-web-api-node');

const spotify = new SpotifyWebApi({ clientId, clientSecret, redirectUri });

const authenticated = spotify.clientCredentialsGrant()
  .then(data => spotify.setAccessToken(data.body.access_token))
  .catch(err => console.log('Something went wrong when retrieving an access token', err));

async function identifySong(query) {
  await authenticated;
  const queries = Object.entries(query)
    .filter(([key,value]) => value && ['album', 'artist', 'title'].indexOf(key) !== -1)
    .map(([key, value]) => `${key}:${value}`);
  const result = await spotify.searchTracks(queries.join(' '));
  if(result.body.tracks.items.length === 1) {
    return result.body.tracks.items[0];
  }
  throw new Error(`Could not find song for ${JSON.stringify(query)}`);
}

async function lookupSongs(uris) {
  uris = uris.map(uri => uri.indexOf('spotify:') === 0 ? uri.split(':')[2] : uri)

  await authenticated;

  const result = await spotify.getTracks(uris);
  return result.body.tracks;
}

module.exports = { identifySong, lookupSongs };
