'use strict';

let jwt;

async function sendRequest() {
  const method = document.querySelector('#method').value;
  const url = document.querySelector('#api-url').value;
  const usr = document.querySelector('#username').value;
  const psw = document.querySelector('#password').value;
  const body = document.querySelector('#body').value || '{}';
  try {
    JSON.parse(body);
    const xhr = new XMLHttpRequest();
    xhr.open(method, '/' + url, true);
    xhr.setRequestHeader('Content-Type', 'application/json;charset=UTF-8');

    if(!jwt && usr && psw) {
      await signIn(usr, psw);
    }

    if(jwt) {
      xhr.setRequestHeader('Authorization', `Bearer ${jwt}`);
    }

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

async function signIn(usr, psw) {
  const xhr = new XMLHttpRequest();
  xhr.open('POST', '/auth', true);
  xhr.setRequestHeader('Content-Type', 'application/json;charset=UTF-8');
  const wait = new Promise(resolve => xhr.addEventListener('load', () => resolve(xhr.responseText)));
  xhr.send(JSON.stringify({ usr, psw }));
  const response = JSON.parse(await wait);
  console.log(response);
  if(response.status === 'SUCCESS') {
    jwt = response.data;
    console.log("Signed in!");
  } else {
    alert('incorrect username/password');
  }
}
