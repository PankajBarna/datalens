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
