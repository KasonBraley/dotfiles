---
name: screenshot
description: >-
  Capture screenshots of web pages, local HTML, or rendered output using
  Bun.WebView — Bun's built-in headless browser (zero install on macOS,
  Bun >= 1.4). Use whenever the user asks for a screenshot, a visual check of a
  page or UI, or when a task would otherwise reach for Playwright, Puppeteer,
  headless Chrome, or Chromium.
---

Take every screenshot with `Bun.WebView`. It ships inside Bun 1.4+ — no npm install, no browser download, one script, done in seconds. On macOS it drives the system WebKit; on Linux/Windows it drives an installed Chrome/Chromium/Edge/Brave automatically.

Docs: https://bun.com/docs/runtime/webview

## Steps

1. Confirm `bun --version` is >= 1.4 (`Bun.WebView` landed there). If older, run `bun upgrade` or ask the user.
2. Write a throwaway script (temp file or `bun -e`) from the template below. Adjust viewport, URL, and output path.
3. Run it, then verify the output file exists and is non-empty (`ls -la`). Done when the image file is written and you have reported its path.

## Template

```ts
await using view = new Bun.WebView({ width: 1280, height: 800 });
await view.navigate("https://example.com"); // resolves on the page's load event
await Bun.write("screenshot.png", await view.screenshot());
```

`await using` closes the view automatically; Bun kills browser subprocesses at exit. `await` every call — a second concurrent operation on the same view throws.

## Reference

**Targets.** `navigate()` accepts `https://…`, `file:///abs/path.html`, and `data:text/html,…`. To screenshot an HTML snippet, use a data URL or write it to a temp file first. For an app that isn't running, start its dev server, screenshot, then stop it.

**Full page.** `screenshot()` captures the viewport only. For the whole page, resize to the document height first:

```ts
const h = await view.evaluate("document.documentElement.scrollHeight");
await view.resize(1280, Math.min(h, 16384));
```

**Late-rendering content.** `navigate()` resolves on `load`, before SPA hydration or web fonts. `evaluate()` awaits promises, so wait in-page:

```ts
await view.evaluate("document.fonts.ready.then(() => new Promise(r => setTimeout(r, 300)))");
// or wait for a specific element:
await view.scrollTo("#chart"); // waits for it to exist (30s default timeout)
```

**Element or state.** `click(selector)` waits for actionability and sends trusted native input; `type()`, `press()`, `scroll()` likewise — drive the page to the state you need, then screenshot. `evaluate()` takes a single expression (wrap statements in an IIFE).

**Formats.** PNG is the default. `screenshot({ format: "jpeg", quality: 80 })` for smaller files; `"webp"` needs `backend: "chrome"`. `{ encoding: "base64" }` returns a string for inline embedding.

**Linux/Windows.** Bun finds Chrome/Chromium/Edge/Brave on `$PATH`, standard install locations, or Playwright's cache; set `BUN_CHROME_PATH` to point at a specific binary. If the constructor throws that no browser was found, that is the one case a browser install is needed.

**Debugging a blank/failed capture.** Pass `console: globalThis.console` to the constructor to mirror page errors, and `backend: { type: "chrome", stderr: "inherit" }` to see browser stderr.
