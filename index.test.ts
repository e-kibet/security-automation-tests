import request from 'supertest';
import app from './index';

describe('API endpoints', () => {
  it('GET / returns welcome message', async () => {
    const res = await request(app).get('/');
    expect(res.status).toBe(200);
    expect(res.body.message).toBe('Security Test API');
  });

  it('GET /api/health returns OK status', async () => {
    const res = await request(app).get('/api/health');
    expect(res.status).toBe(200);
    expect(res.body.status).toBe('OK');
    expect(res.body.timestamp).toBeDefined();
  });
});
