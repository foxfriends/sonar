'use strict';
// TODO: authorization
async function sendRequest() {
  const method = document.querySelector('#method').value;
  const url = document.querySelector('#api-url').value;
  const body = document.querySelector('#body').value || '{}';
  try {
    JSON.parse(body);
    const xhr = new XMLHttpRequest();
    xhr.open(method, '/' + url, true);
    xhr.setRequestHeader('Content-Type', 'application/json;charset=UTF-8');
    const wait = new Promise(resolve => xhr.addEventListener('load', () => resolve(xhr.responseText)));
    xhr.send(body);
    const response = await wait;
    console.log(response);
    document.querySelector('#response').innerHTML = JSON.stringify(JSON.parse(response), null, 2);
  } catch(error) {
    alert('Could not parse JSON!');
    console.log(error);
  }
}
