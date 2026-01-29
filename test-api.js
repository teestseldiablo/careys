const http = require('http');

const data = JSON.stringify({pin: '1234'});
const options = {
  hostname: 'localhost',
  port: 5001,
  path: '/login',
  method: 'POST',
  headers: {
    'Content-Type': 'application/json',
    'Content-Length': data.length
  }
};

console.log('Making request to /login...');
const req = http.request(options, (res) => {
  console.log(`Status: ${res.statusCode}`);
  let body = '';
  res.on('data', (chunk) => {
    body += chunk;
  });
  res.on('end', () => {
    console.log('Response:', body);
  });
});

req.on('error', (err) => {
  console.error('Request error:', err);
});

req.write(data);
req.end();
