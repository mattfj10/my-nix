---
name: north-american-anglican
description: Retrieves the latest article from The North American Anglican homepage and summarizes selected articles. Use when the user asks for the latest North American Anglican article, requests article parsing, or asks for a summary from northamanglican.com.
---

# North American Anglican Parser

## Purpose

Fetch the latest article from `https://northamanglican.com/`, and when requested, fetch and summarize a selected article.

## Triggers

Apply this skill when the user asks for:

- the latest North American Anglican article
- a specific article from northamanglican.com
- a summary of an article from The North American Anglican

## Workflow

1. Fetch the homepage at `https://northamanglican.com/`.
2. Identify the homepage "latest articles feed" by structure, not by a specific post title.
3. Extract only article cards from that feed in display order.
4. For "latest article" requests, pick the first article card in that ordered feed.
5. For "latest articles" requests, return all cards currently visible in that feed.
6. Return:
   - article title
   - author (if available)
   - publication date (if available)
   - direct article URL
   - formatted as a markdown table with columns: `Title | Author | Date | URL`
7. If the user asks to parse/summarize a specific article, fetch that article URL and extract the main body text.
8. If the user did not specify a summary type, ask which they want: `short`, `medium`, or `detailed`.

## Strict Mode (Homepage + Sitemap Cross-Check)

When the user asks for strict verification (for example "strict mode", "double-check", or "cross-check with sitemap"), do this:

1. Extract the latest feed from the homepage using the structure-based method above.
2. Fetch `https://northamanglican.com/sitemap_index.xml`.
3. From the index, fetch post sitemaps (typically `post-sitemap.xml`, `post-sitemap2.xml`, etc.).
4. Build a candidate URL set from post sitemap entries.
5. Cross-check each homepage article URL against that set.
6. Return homepage order as primary output, plus a verification status for each item:
   - `verified` (present in post sitemap data)
   - `unverified` (missing from current sitemap fetch)
7. If any are unverified, include a short note explaining likely causes (cache delay, publication lag, or parser mismatch) and keep homepage results as source of truth for "latest visible on homepage."

Strict mode rules:

- Do not reorder homepage articles based on sitemap timestamps.
- Use sitemap only as a consistency check, not as the display-order source.
- If sitemap fetch fails, report strict-mode degradation and return homepage-only results.

## Full Display Mode (Top 10 Digest)

When the user asks for a full display (for example "full display mode", "digest mode", "show all ten with summaries"), do this:

1. Extract the latest homepage feed using the structure-based method.
2. Select the first 10 articles in homepage order.
3. For each article:
   - fetch the article page
   - extract title
   - extract author (or `not listed`)
   - produce a brief summary paragraph (2-4 sentences, neutral tone)
4. Return a clean markdown digest using this format:

```markdown
# North American Anglican Latest 10 Digest

1. ## [Article Title](article-url)
   **Author:** Name
   **Summary:** Brief paragraph...

2. ## [Article Title](article-url)
   **Author:** Name
   **Summary:** Brief paragraph...
```

Full display rules:

- Keep article order exactly as shown on the homepage.
- Keep each summary concise and faithful to the article text.
- Do not invent metadata; use `not listed` when missing.
- If one article fails to parse, include a short failure note for that item and continue with the rest.

## Extraction Strategy (Structure-Based)

Use generic page structure to isolate the latest feed:

- Prefer repeated article-card patterns (title + excerpt + link) in a shared container.
- Use heading/link repetition (`h2`/`h3` post titles linked to same-domain post URLs) to identify cards.
- Exclude nav menus, category lists, featured widgets, "you may also like" blocks, and footer links.
- Do not use any fixed title text (for example, do not anchor on one known article name).
- Preserve homepage order exactly as displayed.

Fallback logic:

1. If container classes/ids are unavailable, infer the feed from contiguous repeated post-card headings with same-domain links.
2. Validate extracted URLs as post-like paths on `northamanglican.com`.
3. If ambiguity remains, return candidate list and ask the user to confirm scope.

## Summary Modes

Use exactly one mode per response:

- `short`: 3-5 bullets with core claims only.
- `medium`: 1 concise paragraph plus 3 bullets of key points.
- `detailed`: sections for Thesis, Key Points, Notable Quotes, and Takeaways.

## Output Rules

- Always include the article URL in the response.
- Default output format for article lists is a markdown table using exactly these columns in this order: `Title | Author | Date | URL`.
- Distinguish clearly between extracted facts and interpretation.
- If metadata is missing, say "not listed" instead of guessing.
- Keep wording neutral and faithful to the article.
- If parsing fails due to site structure, report the failure and provide next-best available metadata from the homepage.

## Example Requests

- "Get me the latest North American Anglican article."
- "Get the latest articles in strict mode and verify with sitemap."
- "Use full display mode for the latest ten articles."
- "Parse this North American Anglican article and summarize it: <url>"
- "Summarize the latest article in detailed mode."
