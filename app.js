const express = require('express');
const { exec } = require('child_process');
const app = express();

// Serve static files from the "public" directory
app.use(express.static('public'));
app.use(express.json());

// Vulnerable route that executes a shell command
app.get('/ping', (req, res) => {
    const { host } = req.query;

    if (!host) {
        return res.status(400).send('Host is required');
    }

    // Vulnerable to command injection
    exec(`ping -c 4 ${host}`, (error, stdout, stderr) => {
        if (error) {
            return res.status(500).send(`Error: ${error.message}`);
        }
        if (stderr) {
            return res.status(500).send(`Stderr: ${stderr}`);
        }
        res.send(stdout);
    });
});

app.listen(3000, () => {
    console.log('Vulnerable command injection demo app with UI listening on port 3000');
});
