require('dotenv').config();
const express = require('express');
const { Pool } = require('pg');
const cors = require('cors');
const path = require('path');

const app = express();
app.use(cors());
app.use(express.json());
app.use(express.static(path.join(__dirname, '.')));

const pool = new Pool({
  user: process.env.DB_USER || 'postgres',
  host: process.env.DB_HOST || 'localhost',
  database: process.env.DB_NAME || 'modernization_portal',
  password: process.env.DB_PASSWORD || 'password',
  port: parseInt(process.env.DB_PORT) || 5000,
});

const logAction = async (userId, action, entityType, entityId, details) => {
    try {
        await pool.query(
            'INSERT INTO audit_logs (user_id, action, entity_type, entity_id, details) VALUES ($1, $2, $3, $4, $5)',
            [userId || 1, action, entityType, entityId, details]
        );
    } catch (err) { console.error("Audit Log Error:", err); }
};

app.post('/login', async (req, res) => {
    const { pin } = req.body;
    try {
        const result = await pool.query('SELECT * FROM employees WHERE pin = $1', [pin]);
        if (result.rows.length > 0) res.json({ success: true, user: result.rows[0] });
        else res.status(401).json({ success: false, message: 'Invalid PIN' });
    } catch (err) { res.status(500).json({ error: err.message }); }
});

app.get('/api/properties', async (req, res) => {
    try {
        const result = await pool.query('SELECT * FROM properties ORDER BY id ASC');
        res.json(result.rows);
    } catch (err) { res.json([]); }
});

app.get('/api/maintenance', async (req, res) => {
    try {
        const result = await pool.query(`
            SELECT m.*, p.property_name 
            FROM maintenance_requests m
            LEFT JOIN properties p ON m.property_id = p.id
            ORDER BY m.created_at DESC
        `);
        res.json(result.rows);
    } catch (err) { 
        console.error("Fetch Error:", err.message);
        res.json([]); 
    }
});

app.post('/api/maintenance', async (req, res) => {
    const { property_id, issue_description, priority, user_id } = req.body;
    try {
        const result = await pool.query(
            'INSERT INTO maintenance_requests (property_id, issue_description, priority, reported_by) VALUES ($1, $2, $3, $4) RETURNING *',
            [property_id, issue_description, priority, user_id]
        );
        await logAction(user_id, 'CREATE', 'MAINTENANCE', result.rows[0].id, `Work Order Created`);
        res.json(result.rows[0]);
    } catch (err) { res.status(500).json({ error: err.message }); }
});

app.get('/api/audit-logs', async (req, res) => {
    try {
        const result = await pool.query('SELECT a.*, e.name as user_name FROM audit_logs a LEFT JOIN employees e ON a.user_id = e.id ORDER BY a.created_at DESC LIMIT 50');
        res.json(result.rows);
    } catch (err) { res.json([]); }
});

app.get(/^.*$/, (req, res) => { res.sendFile(path.join(__dirname, 'index.html')); });

app.listen(5001, () => console.log(`🚀 System Online: http://localhost:5001`));