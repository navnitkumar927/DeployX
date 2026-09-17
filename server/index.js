import { createServer } from 'node:http';

const port = Number(process.env.PORT ?? 8080);

// This intentionally exposes only operational endpoints. Product APIs belong in
// dedicated, authenticated route modules when backend functionality is added.
const server = createServer((request, response) => {
  if (request.url === '/healthz' && request.method === 'GET') {
    response.writeHead(200, { 'content-type': 'application/json', 'cache-control': 'no-store' });
    response.end(JSON.stringify({ status: 'ok' }));
    return;
  }

  response.writeHead(404, { 'content-type': 'application/json' });
  response.end(JSON.stringify({ error: 'Not found' }));
});

server.listen(port, '0.0.0.0');
