const express = require('express');
const { Pool } = require('pg');
const cors = require('cors');

const app = express();
const port = 3001;

// Middleware
app.use(cors());
app.use(express.json());

// Configuración de PostgreSQL
const pool = new Pool({
  user: 'gatoaa',
  host: 'localhost',
  database: 'minecraft_wordle',
  password: 'phisiaa',
  port: 5432,
});

// Test database connection
pool.query('SELECT NOW()', (err, res) => {
  if (err) {
    console.error('Error connecting to the database:', err);
  } else {
    console.log('Connected to PostgreSQL database at:', res.rows[0].now);
  }
});

// API Routes

// Get random item for game start
app.get('/api/:category/random', async (req, res) => {
  try {
    const { category } = req.params;
    let query;
    
    switch(category) {
      case 'items':
        query = 'SELECT * FROM items ORDER BY RANDOM() LIMIT 1';
        break;
      case 'mobs':
        query = 'SELECT * FROM mobs ORDER BY RANDOM() LIMIT 1';
        break;
      case 'blocks':
        query = 'SELECT * FROM blocks ORDER BY RANDOM() LIMIT 1';
        break;
      default:
        return res.status(400).json({ error: 'Invalid category' });
    }
    
    const result = await pool.query(query);
    
    if (result.rows.length === 0) {
      return res.status(404).json({ error: 'No items found' });
    }
    
    res.json(result.rows[0]);
  } catch (error) {
    console.error('Error getting random item:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
});

// Search items
app.get('/api/items/search', async (req, res) => {
  try {
    const { q, exclude } = req.query;
    
    if (!q || q.trim().length === 0) {
      return res.json([]);
    }
    
    let query = `
      SELECT id, name, release, stack_size, rarity, creative_category, where_crafted, how_to_obtain 
      FROM items 
      WHERE LOWER(name) LIKE LOWER($1)
    `;
    const params = [`%${q.trim()}%`];
    
    // Exclude already guessed items
    if (exclude) {
      const excludeArray = Array.isArray(exclude) ? exclude : [exclude];
      const placeholders = excludeArray.map((_, index) => `$${index + 2}`).join(',');
      query += ` AND name NOT IN (${placeholders})`;
      params.push(...excludeArray);
    }
    
    query += ' ORDER BY name LIMIT 7';
    
    const result = await pool.query(query, params);
    res.json(result.rows);
  } catch (error) {
    console.error('Error searching items:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
});

// Search mobs
app.get('/api/mobs/search', async (req, res) => {
  try {
    const { q, exclude } = req.query;
    
    if (!q || q.trim().length === 0) {
      return res.json([]);
    }
    
    let query = `
      SELECT id, name, release, health, height, behavior, spawn_category 
      FROM mobs 
      WHERE LOWER(name) LIKE LOWER($1)
    `;
    const params = [`%${q.trim()}%`];
    
    // Exclude already guessed items
    if (exclude) {
      const excludeArray = Array.isArray(exclude) ? exclude : [exclude];
      const placeholders = excludeArray.map((_, index) => `$${index + 2}`).join(',');
      query += ` AND name NOT IN (${placeholders})`;
      params.push(...excludeArray);
    }
    
    query += ' ORDER BY name LIMIT 7';
    
    const result = await pool.query(query, params);
    res.json(result.rows);
  } catch (error) {
    console.error('Error searching mobs:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
});

// Search blocks
app.get('/api/blocks/search', async (req, res) => {
  try {
    const { q, exclude } = req.query;
    
    if (!q || q.trim().length === 0) {
      return res.json([]);
    }
    
    let query = `
      SELECT id, name, release, stack_size, tool, hardness, blast_resistance, flammable, full_block 
      FROM blocks 
      WHERE LOWER(name) LIKE LOWER($1)
    `;
    const params = [`%${q.trim()}%`];
    
    // Exclude already guessed items
    if (exclude) {
      const excludeArray = Array.isArray(exclude) ? exclude : [exclude];
      const placeholders = excludeArray.map((_, index) => `$${index + 2}`).join(',');
      query += ` AND name NOT IN (${placeholders})`;
      params.push(...excludeArray);
    }
    
    query += ' ORDER BY name LIMIT 7';
    
    const result = await pool.query(query, params);
    res.json(result.rows);
  } catch (error) {
    console.error('Error searching blocks:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
});

// Get item by name (for guessing)
app.get('/api/items/:name', async (req, res) => {
  try {
    const { name } = req.params;
    const query = 'SELECT * FROM items WHERE LOWER(name) = LOWER($1)';
    const result = await pool.query(query, [name]);
    
    if (result.rows.length === 0) {
      return res.status(404).json({ error: 'Item not found' });
    }
    
    res.json(result.rows[0]);
  } catch (error) {
    console.error('Error getting item:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
});

// Get mob by name
app.get('/api/mobs/:name', async (req, res) => {
  try {
    const { name } = req.params;
    const query = 'SELECT * FROM mobs WHERE LOWER(name) = LOWER($1)';
    const result = await pool.query(query, [name]);
    
    if (result.rows.length === 0) {
      return res.status(404).json({ error: 'Mob not found' });
    }
    
    res.json(result.rows[0]);
  } catch (error) {
    console.error('Error getting mob:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
});

// Get block by name
app.get('/api/blocks/:name', async (req, res) => {
  try {
    const { name } = req.params;
    const query = 'SELECT * FROM blocks WHERE LOWER(name) = LOWER($1)';
    const result = await pool.query(query, [name]);
    
    if (result.rows.length === 0) {
      return res.status(404).json({ error: 'Block not found' });
    }
    
    res.json(result.rows[0]);
  } catch (error) {
    console.error('Error getting block:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
});

// Health check endpoint
app.get('/api/health', (req, res) => {
  res.json({ status: 'OK', timestamp: new Date().toISOString() });
});

// Get all items count (for statistics)
app.get('/api/stats', async (req, res) => {
  try {
    const itemsCount = await pool.query('SELECT COUNT(*) FROM items');
    const mobsCount = await pool.query('SELECT COUNT(*) FROM mobs');
    const blocksCount = await pool.query('SELECT COUNT(*) FROM blocks');
    
    res.json({
      items: parseInt(itemsCount.rows[0].count),
      mobs: parseInt(mobsCount.rows[0].count),
      blocks: parseInt(blocksCount.rows[0].count),
      total: parseInt(itemsCount.rows[0].count) + parseInt(mobsCount.rows[0].count) + parseInt(blocksCount.rows[0].count)
    });
  } catch (error) {
    console.error('Error getting stats:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
});

// Error handling middleware
app.use((err, req, res, next) => {
  console.error('Unhandled error:', err);
  res.status(500).json({ error: 'Internal server error' });
});

// 404 handler
app.use((req, res) => {
  res.status(404).json({ error: 'Endpoint not found' });
});

app.listen(port, () => {
  console.log(`Server running on port ${port}`);
  console.log(`API endpoints available at http://localhost:${port}/api`);
});