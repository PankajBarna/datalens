#!/bin/bash
set -e

echo "🚀 Creating CSV Dashboard project..."

# 1. Create Vite + React project
npm create vite@latest csv-dashboard -- --template react
cd csv-dashboard

# 2. Install base dependencies
echo "📦 Installing dependencies..."
npm install
npm install recharts papaparse zustand react-router-dom axios date-fns jspdf html2canvas

# 3. Install Tailwind CSS
echo "🎨 Setting up Tailwind CSS..."
npm install -D tailwindcss@3 postcss autoprefixer
npx tailwindcss init -p

# Update tailwind.config.js
cat > tailwind.config.js << 'EOF'
/** @type {import('tailwindcss').Config} */
export default {
  content: [
    "./index.html",
    "./src/**/*.{js,ts,jsx,tsx}",
  ],
  theme: {
    extend: {},
  },
  plugins: [],
}
EOF

# Update src/index.css with Tailwind directives
cat > src/index.css << 'EOF'
@tailwind base;
@tailwind components;
@tailwind utilities;
EOF

# 4. Configure Vite alias
cat > vite.config.js << 'EOF'
import { defineConfig } from 'vite'
import react from '@vitejs/plugin-react'
import path from 'path'

export default defineConfig({
  plugins: [react()],
  resolve: {
    alias: {
      "@": path.resolve(__dirname, "./src"),
    },
  },
})
EOF

cat > jsconfig.json << 'EOF'
{
  "compilerOptions": {
    "baseUrl": ".",
    "paths": {
      "@/*": ["./src/*"]
    }
  }
}
EOF

npm install -D @types/node

# 5. Create ALL folders explicitly
echo "📁 Creating folder structure..."
mkdir -p src/pages
mkdir -p src/components/upload
mkdir -p src/components/dashboard
mkdir -p src/components/charts
mkdir -p src/components/filters
mkdir -p src/components/ui
mkdir -p src/engine
mkdir -p src/store
mkdir -p src/hooks
mkdir -p src/utils

# 6. Create all placeholder files
echo "📄 Creating placeholder files..."

# ── Pages ──────────────────────────────────────────────
cat > src/pages/Landing.jsx << 'EOF'
const Landing = () => <div>Landing Page</div>;
export default Landing;
EOF

cat > src/pages/Upload.jsx << 'EOF'
const Upload = () => <div>Upload Page</div>;
export default Upload;
EOF

cat > src/pages/Dashboard.jsx << 'EOF'
const Dashboard = () => <div>Dashboard Page</div>;
export default Dashboard;
EOF

cat > src/pages/Pricing.jsx << 'EOF'
const Pricing = () => <div>Pricing Page</div>;
export default Pricing;
EOF

cat > src/pages/Auth.jsx << 'EOF'
const Auth = () => <div>Auth Page</div>;
export default Auth;
EOF

# ── Engine ─────────────────────────────────────────────
cat > src/engine/csvParser.js << 'EOF'
// CSV Parser — uses PapaParse to parse uploaded CSV files
export const parseCSV = (file) => {};
EOF

cat > src/engine/columnDetector.js << 'EOF'
// Column Detector — infers column types (string, number, date, boolean)
export const detectColumns = (data) => {};
EOF

cat > src/engine/domainDetector.js << 'EOF'
// Domain Detector — guesses the data domain (sales, finance, HR, etc.)
export const detectDomain = (columns) => {};
EOF

cat > src/engine/kpiGenerator.js << 'EOF'
// KPI Generator — auto-generates KPI cards from parsed data
export const generateKPIs = (data, columns) => {};
EOF

cat > src/engine/timeEngine.js << 'EOF'
// Time Engine — detects time columns and builds time series
export const buildTimeSeries = (data, timeCol) => {};
EOF

cat > src/engine/chartSelector.js << 'EOF'
// Chart Selector — recommends chart types per column combination
export const selectCharts = (columns, domain) => {};
EOF

cat > src/engine/dataIndexer.js << 'EOF'
// Data Indexer — indexes rows for fast filter + aggregation
export const indexData = (data) => {};
EOF

# ── Store ──────────────────────────────────────────────
cat > src/store/dashboardStore.js << 'EOF'
// Dashboard Store — Zustand store for dashboard state
import { create } from 'zustand';
export const useDashboardStore = create((set) => ({}));
EOF

cat > src/store/filterStore.js << 'EOF'
// Filter Store — Zustand store for active filters
import { create } from 'zustand';
export const useFilterStore = create((set) => ({}));
EOF

cat > src/store/userStore.js << 'EOF'
// User Store — Zustand store for user/auth state
import { create } from 'zustand';
export const useUserStore = create((set) => ({}));
EOF

# ── Hooks ──────────────────────────────────────────────
cat > src/hooks/useCSVUpload.js << 'EOF'
// useCSVUpload — handles file selection, validation, and parsing trigger
export const useCSVUpload = () => {};
EOF

cat > src/hooks/useFilters.js << 'EOF'
// useFilters — reads/writes filter state and returns filtered data
export const useFilters = () => {};
EOF

cat > src/hooks/useExport.js << 'EOF'
// useExport — exports dashboard as PDF or PNG using jsPDF + html2canvas
export const useExport = () => {};
EOF

# ── Utils ──────────────────────────────────────────────
cat > src/utils/formatters.js << 'EOF'
// Formatters — number, currency, date, and percentage formatters
export const formatNumber = (n) => n;
export const formatCurrency = (n) => n;
export const formatDate = (d) => d;
export const formatPercent = (n) => n;
EOF

cat > src/utils/colorPalette.js << 'EOF'
// Color Palette — chart color tokens and theme palette
export const COLORS = ['#6366f1', '#22d3ee', '#f59e0b', '#10b981', '#ef4444'];
EOF

cat > src/utils/constants.js << 'EOF'
// Constants — app-wide constants and config values
export const APP_NAME = 'CSV Dashboard';
export const MAX_FILE_SIZE_MB = 50;
EOF

# ── Component placeholder files ────────────────────────
touch src/components/upload/DropZone.jsx
touch src/components/upload/FilePreview.jsx
touch src/components/dashboard/KPICard.jsx
touch src/components/dashboard/ChartGrid.jsx
touch src/components/charts/BarChart.jsx
touch src/components/charts/LineChart.jsx
touch src/components/charts/PieChart.jsx
touch src/components/filters/FilterBar.jsx
touch src/components/filters/FilterChip.jsx

echo ""
echo "✅ All folders and files created!"
echo ""
echo "📂 Final src/ structure:"
find src -type f | sort

echo ""
echo "─────────────────────────────────────────────"
echo "🧩 FINAL STEP — Run shadcn init manually:"
echo "─────────────────────────────────────────────"
echo ""
echo "   npx shadcn@latest init"
echo ""
echo "   When prompted, choose:"
echo "   • Style        → Default"
echo "   • Base color   → Slate"
echo "   • CSS vars     → Yes"
echo ""
echo "Then start the dev server:"
echo "   npm run dev"
echo "─────────────────────────────────────────────"