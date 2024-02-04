const express = require('express');
const jwt = require('jsonwebtoken');
const bodyParser = require('body-parser');
const bcrypt = require('bcrypt');

const app = express();
const PORT = 5433;
// speedev
app.use(express.json());
app.use(bodyParser.urlencoded({ extended: true }));

const users = [
    {
        id: 1,
        username: 'user1',
        password: '0b14d501a594442a01c6859541bcb3e8164d183d32937b851835442f69d5c94e', // password1 SHA256
    },
    {
        id: 2,
        username: "user2",
        password: "6cf615d5bcaac778352a8f1f3360d23f02f34ec182e259897fd6ce485d7870d4", // password2 SHA256
    }
];


const generateToken = (user) => {
    return jwt.sign({ id: user.id, username: user.username }, 'secret_key', { expiresIn: '1h' });
};

const getUserInfo = async (username, password) => {
    try {
        const user = users.find(u => u.username === username && password === u.password);
        if (user) {
            return {
                id: user.id,
                username: user.username,
            };
        } else {
            return null;
        }
    } catch (error) {
        console.error('Error:', error);
        throw error;
    }
};

app.post('/login', async (req, res) => {
    const { username, password } = req.body;
    try {
        const user = await getUserInfo(username, password);

        if (user) {
            const token = generateToken(user);
            res.status(200).json({ token, username });
        } else {
            res.status(401).json({ message: 'Email or password is incorrect.' });
        }
    } catch (error) {
        res.status(500).json({ message: 'Server error' });
    }
});




app.get('/secure', (req, res) => {
    const token = req.headers.authorization;

    if (!token) {
        return res.status(401).json({ message: 'Token is not defined.' });
    }

    jwt.verify(token, 'secret_key', (err, decoded) => {
        if (err) {
            return res.status(401).json({ message: 'Invalid token' });
        }

        res.status(200).json({ message: 'Token is valid.', user: decoded });
    });
});

app.listen(PORT, 'localhost', () => {
    console.log(`Server is running on port ${PORT}`);
});
