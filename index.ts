import 'dotenv/config';
import express, { Request, Response } from 'express';

const app = express();
const PORT = process.env.PORT || 3000;

app.use(express.json());
app.use(express.urlencoded({ extended: true }));

// ── Basic ────────────────────────────────────────────────────────────────────

app.get('/', (_req: Request, res: Response) => {
  res.json({ message: 'Security Test API' });
});

app.get('/api/health', (_req: Request, res: Response) => {
  res.json({ status: 'OK', timestamp: new Date().toISOString() });
});

// ── A01: Broken Access Control ───────────────────────────────────────────────
// IDOR: user ID comes from query param with no ownership check
app.get('/api/users/:id', (req: Request, res: Response) => {
  const users: Record<string, object> = {
    '1': { id: 1, name: 'Alice', email: 'alice@example.com', role: 'admin' },
    '2': { id: 2, name: 'Bob', email: 'bob@example.com', role: 'user' },
  };
  const user = users[req.params.id as string];
  if (!user) return res.status(404).json({ error: 'User not found' });
  res.json(user);
});

// Admin endpoint with no auth check
app.get('/api/admin/users', (_req: Request, res: Response) => {
  res.json([
    { id: 1, name: 'Alice', email: 'alice@example.com', role: 'admin' },
    { id: 2, name: 'Bob', email: 'bob@example.com', role: 'user' },
  ]);
});

// ── A02: Cryptographic Failures ──────────────────────────────────────────────
// Sensitive data returned in plaintext, no HTTPS enforcement
app.get('/api/sensitive-data', (_req: Request, res: Response) => {
  res.json({
    creditCard: '4111-1111-1111-1111',
    ssn: '123-45-6789',
    apiKey: 'sk_test_supersecretkey123',
  });
});

// ── A03: Injection ───────────────────────────────────────────────────────────
// SQL injection: user input interpolated directly into a simulated query
app.get('/api/products', (req: Request, res: Response) => {
  const search = req.query.search as string || '';
  // Intentionally vulnerable: simulates SELECT * FROM products WHERE name = '<input>'
  const simulatedQuery = `SELECT * FROM products WHERE name = '${search}'`;
  res.json({ query: simulatedQuery, results: [] });
});

// ── A03: XSS ─────────────────────────────────────────────────────────────────
// Reflected XSS: echoes user input directly into an HTML response
app.get('/api/search', (req: Request, res: Response) => {
  const query = req.query.q as string || '';
  res.setHeader('Content-Type', 'text/html');
  res.send(`<html><body><h1>Search results for: ${query}</h1></body></html>`);
});

// ── A04: Insecure Design ─────────────────────────────────────────────────────
// No rate limiting or lockout on login
app.post('/api/login', (req: Request, res: Response) => {
  const { username, password } = req.body;
  if (username === 'admin' && password === 'admin123') {
    return res.json({ token: 'hardcoded-jwt-token-abc123', role: 'admin' });
  }
  res.status(401).json({ error: 'Invalid credentials' });
});

// ── A05: Security Misconfiguration ───────────────────────────────────────────
// No security headers (no helmet), verbose error messages
app.get('/api/config', (_req: Request, res: Response) => {
  res.json({
    env: process.env.NODE_ENV,
    dbHost: process.env.DB_HOST || 'localhost',
    dbUser: process.env.DB_USER || 'root',
    debug: true,
  });
});

// Stack trace exposed on error
app.get('/api/error', (_req: Request, res: Response) => {
  try {
    throw new Error('Database connection failed: host=db.internal user=root');
  } catch (err: any) {
    res.status(500).json({ error: err.message, stack: err.stack });
  }
});

// ── A07: Authentication Failures ─────────────────────────────────────────────
// Weak token check — accepts any Bearer token
app.get('/api/profile', (req: Request, res: Response) => {
  const auth = req.headers.authorization;
  if (!auth || !auth.startsWith('Bearer ')) {
    return res.status(401).json({ error: 'No token provided' });
  }
  // No actual token validation
  res.json({ id: 1, name: 'Alice', email: 'alice@example.com', role: 'admin' });
});

// Password reset with predictable token
app.post('/api/password-reset', (req: Request, res: Response) => {
  const { email } = req.body;
  const resetToken = Buffer.from(email).toString('base64'); // weak, reversible
  res.json({ message: 'Reset link sent', token: resetToken });
});

// ── A08: Software & Data Integrity Failures ───────────────────────────────────
// Accepts serialized data without validation
app.post('/api/import', (req: Request, res: Response) => {
  const data = req.body;
  res.json({ imported: data, count: Array.isArray(data) ? data.length : 1 });
});

// ── A09: Logging & Monitoring Failures ───────────────────────────────────────
// Logs credentials in plaintext (no sanitization)
app.post('/api/audit-log', (req: Request, res: Response) => {
  const { action, user, password } = req.body;
  console.log(`[AUDIT] user=${user} password=${password} action=${action}`);
  res.json({ logged: true });
});

// ── A10: SSRF ────────────────────────────────────────────────────────────────
// Fetches an arbitrary URL provided by the caller
app.get('/api/fetch', async (req: Request, res: Response) => {
  const url = req.query.url as string;
  if (!url) return res.status(400).json({ error: 'url param required' });
  try {
    const response = await fetch(url);
    const text = await response.text();
    res.json({ url, status: response.status, body: text.slice(0, 500) });
  } catch (err: any) {
    res.status(500).json({ error: err.message });
  }
});

// ── Open Redirect ────────────────────────────────────────────────────────────
app.get('/api/redirect', (req: Request, res: Response) => {
  const target = req.query.to as string;
  if (!target) return res.status(400).json({ error: 'to param required' });
  res.redirect(target); // no allowlist check
});

export default app;

// Start the server only when run directly
if (require.main === module) {
  app.listen(PORT, () => {
    console.log(`Server running on http://localhost:${PORT}`);
  });
}
