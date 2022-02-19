const express = require('express');
const path = require('path');
const request = require('request');

const buildDir = 'calculator-app/build';
const app = express();
const isDev = process.env.NODE_ENV == 'development';
const port = process.env.PORT || 80;
const daprPort = process.env.DAPR_HTTP_PORT || 3500;
const devServerUrl = 'http://localhost:44464';
const daprUrl = `http://localhost:${daprPort}/v1.0/invoke`;
const stateUrl = `http://localhost:${daprPort}/v1.0/state/statestore`;

/** The following routes forward requests (using pipe) from our React client to our dapr-enabled services.*/
app.post('/api/*', async (req, res) => {
    var url = `${daprUrl}/api/method/${req.url.replace('/api/', '')}`;
    console.log('NODE:req:' + url);
    req.pipe(request(url)).pipe(res);
});

// Forward state retrieval to Dapr state endpoint
app.get('/state', async (req, res) => {
    var url = `${stateUrl}/calculatorState`;
    console.log('NODE:state:' + url);
    req.pipe(request(url)).pipe(res);
});
app.post('/state', async (req, res) => req.pipe(request(stateUrl)).pipe(res));

// For all other requests, route to React client
if (isDev) {
    app.get('*', (req, res) => req.pipe(request(devServerUrl + req.path)).pipe(res));
} else {
    app.use(express.static(path.join(buildDir)));
    app.get('*', (_req, res) => res.sendFile(path.join(__dirname, buildDir, 'index.html')));
}

app.listen(port, () => console.log(`Listening on port ${port}!`));
