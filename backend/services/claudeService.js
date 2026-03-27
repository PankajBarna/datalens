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
