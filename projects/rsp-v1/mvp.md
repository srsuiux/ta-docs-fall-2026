# RSP v1: phone remote for slides (MVP plan)

Date: 2026-11-12. Based on `idea.md`.

## One line
Upload a deck, present it from our web page, and control it from any phone browser by scanning a QR code. No app, no extension.

## The core idea (clarified 2026-11-12)
One universal reader plus one universal control. The user uploads any file. They never need PowerPoint, a PDF reader, or Keynote on the presenting machine, and the phone control is the same for every file type.

How we get "universal": every file is converted on upload into the same internal thing, an ordered list of **pages** (images), plus optional media. The viewer only knows how to show page N. The control only knows how to say next, prev, go to N, blackout. Format support then becomes a conversion problem, not a viewer problem.

| File type | Converted by | Becomes |
|---|---|---|
| PDF | pdf.js or server rasterize | pages |
| PPTX, PPT, ODP, KEY (KEY is weak) | LibreOffice, then PDF, then pages | slides as pages, no animations |
| DOCX, ODT | LibreOffice, then PDF, then pages | pages |
| XLSX, ODS | LibreOffice, then PDF, then pages | print pages (ugly for wide sheets) |
| PNG, JPG, GIF | none | one page each, many files make a deck |
| Video, audio | none | one item, control adds play, pause, seek |
| Google Slides link | export to PDF (needs shared link) | pages, v2 |

**Known cost of this design:** converted decks are flat images. No animations, no embedded video playback inside slides, no live fonts. Fidelity depends on LibreOffice. Say this upfront to users.

## Verdict on the idea
Worth building as an MVP. Not a new category.

- **Exists already:** phone-as-clicker is common. Browser extensions (Clikr, Copresent, Remote for Slides), a small desktop app (mobslide), and Google's own Slides cast-and-swipe from the phone app.
- **What they all do:** control a deck that lives somewhere else (Google Slides, PowerPoint Online). They need an extension or desktop helper on the presenting computer.
- **Our difference:** we render the deck ourselves. The slide state lives on our server, so "next" is just a message. No extension, no key injection, no helper app, any file type we can convert.
- **Universal viewers also exist, but as developer SDKs, not presenter tools:** Apryse WebViewer (PDF plus 30+ formats, per its marketing), Nutrient Web SDK (about 15 types, client-side), GroupDocs.Viewer, DocuVieware (claims 100+ formats, .NET server-side). They are paid, embed in other apps, and have no phone remote. Open source for the conversion step: Gotenberg and unoserver, both wrapping LibreOffice.
- **Gap we fill:** nobody I found combines "upload anything, one viewer, one phone remote, no install" in one product. That gap is real but small, and my search was one pass, not a full market scan.
- **Honest risk:** it is a feature, not a moat. Free tools cover the basic case. Our edge is "no install on either side, works with any file" plus custom control layouts.

## How it works
1. Host opens the web app, uploads a PDF or PPTX.
2. Server converts it to page images (PDF direct, PPTX via LibreOffice headless to PDF).
3. Host clicks "Publish". Server creates a session with a random key and shows a QR code (URL with the key).
4. Phone scans with its normal camera, opens the URL in its browser, and gets a control page.
5. Phone sends commands over WebSocket: `next`, `prev`, `goto n`, `blackout`, `laser x,y`.
6. Server checks the key, then forwards the command to the presenter page, which changes the slide.

## What the idea gets wrong (and the fix)
- **"Same IP / same network":** not needed. The phone and laptop both connect out to the server, so it works over cellular too. Many venue Wi-Fi networks isolate devices from each other, so a pure LAN design would fail there. Same-network can be an optional offline mode later.
- **Controlling other apps:** a web page cannot press keys in PowerPoint or Keynote. That is why rendering the deck in our own page is the right design. Do not try to control external apps.
- **Google Slides:** only works if the link is shared or we add Google sign-in. Leave it out of v1. Tell users to export to PDF.
- **MongoDB:** fine, but sessions are short-lived. Use it for decks and session records with a TTL index. No Redis needed for one server.

## Stack
- Frontend: Next.js (React), pdf.js for rendering.
- Backend: Python, FastAPI with WebSockets.
- DB: MongoDB (decks, sessions with expiry).
- Conversion: Gotenberg (REST API around LibreOffice, Docker) or unoserver. Gotenberg is the easier start.
- Rasterize pages: pdf.js in the browser or PyMuPDF on the server.
- Storage: local disk for v1, S3 later.

## MVP scope (v1)
In:
- Upload PDF, PPTX, DOCX, and images through one convert pipeline (Gotenberg or unoserver in Docker). XLSX, video, and audio come right after.
- Show a clear "converted, animations not included" note after upload.
- Presenter view (full-screen slides).
- Publish creates a session, key, and QR.
- Phone control page: big next/prev, slide counter, blackout, current slide thumbnail.
- Fixed control set, user turns buttons on or off before publishing.
- Auto-reconnect, screen wake lock on the phone.
- Session expires after a set time, and the host can revoke it.

Out for v1: Google Slides link, speaker notes, custom drag-and-drop control builder, accounts, multiple controllers, laser pointer, analytics.

## Security basics (must have)
- Key: 128-bit random, in the QR URL, never guessable. A short 6-digit code only as a fallback, rate-limited.
- Controller role can only send navigation commands, nothing else.
- Sessions expire and can be killed by the host.
- Upload limits: file size, type check, convert in a sandbox.
- HTTPS required (wake lock needs it).

## Build order
1. FastAPI WebSocket relay: host and controller join a session by key, `next`/`prev` pass through. Test with two browser tabs.
2. PDF upload and presenter page with pdf.js.
3. Phone control page and QR code.
4. PPTX conversion.
5. Reconnect, wake lock, expiry, revoke.
6. Control toggles at publish time.
7. Try it on real phones (iPhone Safari and Android Chrome) and on a venue Wi-Fi.

## Things to test early
- Latency of next/prev over the relay (target under 200 ms).
- Phone screen locking drops the socket (iOS Safari is the worst).
- PPTX fonts and animations: LibreOffice will not match PowerPoint exactly. Animations will not play.

## Open questions for you
1. Who is it for: you teaching, or a public product? That decides accounts and hosting.
2. Is PDF-only acceptable for the first demo, with PPTX second?
3. Where will it run: your laptop only, or deployed?

## Sources (from web search; I have not opened each page myself)
- Clikr: https://chromewebstore.google.com/detail/oalndbmcbpchbbognlpkdafainaimhdk
- Copresent: https://chatgate.ai/post/copresent
- mobslide: https://www.github.com/thewh1teagle/mobslide
- Remote for Slides: https://thenextweb.com/apps/2017/12/04/turn-your-phone-into-a-google-slides-remote-control-with-this-chrome-extension
- Google Slides cast controls: https://www.pcworld.com/article/428009/google-slides-adds-remote-phone-controls-with-chromecast-and-airplay.html
