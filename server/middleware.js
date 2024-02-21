const jwt = require('jsonwebtoken');
const { JWT_SECRET } = require('./config');
function authMiddleware(req, res, next) {
    const authHeader = req.headers['authorization'];
    const token = authHeader && authHeader.split(' ')[1];

    if (!token) {
        res.status(403).json({
            message: 'Unauthorized',
        });
    }

    jwt.verify(token, JWT_SECRET, (err, decoded) => {
        if (err) {
            res.status(403).json({
                message: 'Invalid Token'
            });
        }

        console.log("JWT decoded is :", decoded);


        // get id and set into request

        req.userId = decoded.userId;

        next();
    });
}

module.exports = {
    authMiddleware
}