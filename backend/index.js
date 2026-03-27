import express from 'express';
import cors from 'cors';
import dotenv from 'dotenv';
import { rateLimiter } from './middleware/rateLimit.js';
import insightsRouter from './routes/insights.js';

dotenv.config();

const app = express();
const PORT = process.env.PORT || 4000;

app.use(cors({ origin: process.env.FRONTEND_URL }));
app.use(express.json({ limit: '10mb' }));
app.use(rateLimiter);

app.use('/api/insights', insightsRouter);

app.get('/health', (req, res) => res.json({ status: 'ok' }));

app.listen(PORT, () => console.log(`✅ Backend running on http://localhost:${PORT}`));
