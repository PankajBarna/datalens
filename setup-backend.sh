#!/bin/bash
set -e

echo "🚀 Creating backend folder structure..."

# 1. Create backend/ folder at the same level as csv-dashboard
mkdir -p backend
cd backend

# 2. Init npm
echo "📦 Initialising npm..."
npm init -y

# 3. Install dependencies
echo "📦 Installing dependencies..."
npm install express cors express-rate-limit @anthropic-ai/sdk dotenv

# 4. Create folder structure
echo "📁 Creating folder structure..."
mkdir -p routes
mkdir -p middleware
mkdir -p services

# 5. Create files

# index.js
cat > index.js << 'EOF'
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
EOF

# routes/insights.js
cat > routes/insights.js << 'EOF'
import { Router } from 'express';
import { authenticate } from '../middleware/auth.js';
import { getInsights } from '../services/claudeService.js';
import { sanitizeCSVPayload } from '../services/sanitizer.js';

const router = Router();

router.post('/', authenticate, async (req, res) => {
  try {
    const sanitized = sanitizeCSVPayload(req.body);
    const insights = await getInsights(sanitized);
    res.json({ success: true, insights });
  } catch (err) {
    console.error(err);
    res.status(500).json({ success: false, error: err.message });
  }
});

export default router;
EOF

# middleware/auth.js
cat > middleware/auth.js << 'EOF'
// Auth middleware — verify Clerk session token
export const authenticate = (req, res, next) => {
  // TODO: Verify Clerk JWT from Authorization header
  // const token = req.headers.authorization?.split(' ')[1];
  next();
};
EOF

# middleware/rateLimit.js
cat > middleware/rateLimit.js << 'EOF'
import rateLimit from 'express-rate-limit';

export const rateLimiter = rateLimit({
  windowMs: 60 * 1000,       // 1 minute window
  max: 20,                    // max 20 requests per window
  standardHeaders: true,
  legacyHeaders: false,
  message: { success: false, error: 'Too many requests. Please slow down.' },
});
EOF

# services/claudeService.js
cat > services/claudeService.js << 'EOF'
import Anthropic from '@anthropic-ai/sdk';

const client = new Anthropic({ apiKey: process.env.ANTHROPIC_API_KEY });

export const getInsights = async ({ columns, sample, kpis, domain }) => {
  const message = await client.messages.create({
    model: 'claude-opus-4-5',
    max_tokens: 1024,
    messages: [
      {
        role: 'user',
        content: `You are a data analyst. Analyze this CSV summary and return 5 key insights.
Domain: ${domain}
Columns: ${JSON.stringify(columns)}
KPIs: ${JSON.stringify(kpis)}
Sample rows: ${JSON.stringify(sample)}

Return a JSON array of insight objects: [{ title, description, type }]`,
      },
    ],
  });

  return message.content[0].text;
};
EOF

# services/sanitizer.js
cat > services/sanitizer.js << 'EOF'
// Sanitizer — strips raw CSV rows, keeps only summary-level data for Claude
export const sanitizeCSVPayload = ({ columns, sample, kpis, domain }) => {
  if (!columns || !Array.isArray(columns)) throw new Error('Invalid columns');
  if (!sample || !Array.isArray(sample)) throw new Error('Invalid sample');

  return {
    domain: String(domain ?? 'unknown').slice(0, 100),
    columns: columns.slice(0, 50),
    kpis: kpis ?? {},
    // Send at most 10 sample rows to Claude to keep token usage low
    sample: sample.slice(0, 10).map(row =>
      Object.fromEntries(
        Object.entries(row).map(([k, v]) => [String(k).slice(0, 50), String(v).slice(0, 200)])
      )
    ),
  };
};
EOF

# 6. Create .env
echo "🔑 Creating .env..."
cat > .env << 'EOF'
ANTHROPIC_API_KEY=your_key_here
CLERK_SECRET_KEY=your_key_here
RAZORPAY_KEY_ID=your_key_here
RAZORPAY_KEY_SECRET=your_key_here
FRONTEND_URL=http://localhost:5173
PORT=4000
EOF

# 7. Create .gitignore
echo "🙈 Creating .gitignore..."
cat > .gitignore << 'EOF'
node_modules/
.env
EOF

# 8. Set type: module in package.json for ES module support
node -e "
const fs = require('fs');
const pkg = JSON.parse(fs.readFileSync('package.json', 'utf8'));
pkg.type = 'module';
pkg.scripts = { ...pkg.scripts, start: 'node index.js', dev: 'node --watch index.js' };
fs.writeFileSync('package.json', JSON.stringify(pkg, null, 2));
"

echo ""
echo "✅ Backend created successfully!"
echo ""
echo "📂 Project structure:"
find . -not -path './node_modules/*' -type f | sort
echo ""
echo "👉 Next steps:"
echo "   cd backend"
echo "   npm run dev"