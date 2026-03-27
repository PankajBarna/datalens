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
