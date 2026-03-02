# AbiPlaner – Setup-Anleitung

## Was ist drin?

- **Frontend:** React + Vite (dein AbiPlaner UI)
- **Backend:** Cloudflare Workers (API für Login, Aufgaben, etc.)
- **Datenbank:** Cloudflare D1 (SQLite, kostenlos, persistent)
- **Hosting:** Cloudflare Pages (kostenlos)

Alles 100% kostenlos. Cloudflare Free Tier reicht locker für 120 Schüler.

---

## Schritt 1: Voraussetzungen

Du brauchst auf deinem PC:
- **Node.js** (https://nodejs.org → LTS Version runterladen & installieren)
- **Git** (https://git-scm.com)

Prüfe ob es geht:
```bash
node --version    # sollte v18+ zeigen
npm --version     # sollte 9+ zeigen
```

---

## Schritt 2: Cloudflare Account

1. Geh zu https://dash.cloudflare.com/sign-up
2. Kostenlosen Account erstellen (nur E-Mail nötig)
3. Danach: https://dash.cloudflare.com → Workers & Pages

---

## Schritt 3: Wrangler installieren & einloggen

```bash
npm install -g wrangler
wrangler login
```

Das öffnet den Browser → Cloudflare autorisieren.

---

## Schritt 4: Projekt einrichten

Entpacke die ZIP und navigiere in den Ordner:

```bash
cd abiplaner
npm install
```

---

## Schritt 5: Datenbank erstellen

```bash
wrangler d1 create abiplaner-db
```

Das gibt dir eine **database_id** aus, z.B.:
```
✅ Successfully created DB 'abiplaner-db'
database_id = "abc123-def456-..."
```

Öffne `wrangler.toml` und trage die ID ein:
```toml
[[d1_databases]]
binding = "DB"
database_name = "abiplaner-db"
database_id = "HIER-DEINE-ID-EINTRAGEN"
```

---

## Schritt 6: Datenbank-Schema anlegen

**Lokal (zum Testen):**
```bash
npm run db:schema
npm run db:seed
```

**Remote (für Produktion):**
```bash
npm run db:schema:prod
npm run db:seed:prod
```

---

## Schritt 7: Lokal testen

In zwei Terminals:

**Terminal 1 – Frontend:**
```bash
npm run dev
```

**Terminal 2 – Backend:**
```bash
npm run pages:dev
```

Öffne http://localhost:8788 im Browser.
Login-Code für Admin: **HDRC2026X**

---

## Schritt 8: Deployen (live schalten)

```bash
npm run build
wrangler pages deploy dist
```

Beim ersten Mal fragt Wrangler nach dem Projektnamen → gib `abiplaner` ein.

Danach musst du die D1-Datenbank mit dem Pages-Projekt verbinden:

1. Geh zu https://dash.cloudflare.com → Workers & Pages → abiplaner
2. Settings → Functions → D1 database bindings
3. Variable name: `DB` → Database: `abiplaner-db`
4. "Save"

Dann nochmal deployen:
```bash
npm run deploy
```

Deine Seite ist jetzt live unter: `https://abiplaner.pages.dev`

---

## Schritt 9: Eigene Domain (optional)

In Cloudflare Dashboard:
1. Workers & Pages → abiplaner → Custom domains
2. Domain hinzufügen (z.B. abiplaner.de)

---

## Whitelist befüllen

Bevor sich Schüler registrieren können, müssen sie auf der Whitelist stehen.

**Option A: Über die App**
Login als Admin → Einstellungen → Whitelist → Namen einzeln hinzufügen

**Option B: Per SQL (schneller für viele)**
Erstelle eine Datei `students.sql`:
```sql
INSERT OR IGNORE INTO whitelist (id, name) VALUES ('s1', 'Max Mustermann');
INSERT OR IGNORE INTO whitelist (id, name) VALUES ('s2', 'Lena Müller');
INSERT OR IGNORE INTO whitelist (id, name) VALUES ('s3', 'Tom Schmidt');
-- ... für alle 120 Schüler
```

Dann:
```bash
wrangler d1 execute abiplaner-db --remote --file=./students.sql
```

---

## Ablauf für Schüler

1. Schüler öffnet die Website
2. Klickt "Registrieren"
3. Gibt seinen vollen Namen ein (muss auf Whitelist stehen)
4. Bekommt einen 6-stelligen Code → muss er sich merken!
5. Ab jetzt: Login mit dem Code

---

## Rollen

| Rolle | Kann |
|-------|------|
| **Admin** | Alles: Aufgaben, Bestätigungen, Whitelist, Rechte, Codes, Log |
| **Orga** | Aufgaben erstellen/bearbeiten, Bestätigungen, Whitelist |
| **Schüler** | Aufgaben ansehen, eintragen, eigene Punkte sehen |

---

## Backup

Cloudflare D1 hat automatische Backups. Du kannst auch manuell exportieren:

```bash
wrangler d1 export abiplaner-db --remote --output=backup.sql
```

---

## Probleme?

- **"Ungültiger Code":** Prüfe ob der Schüler registriert ist (Admin → Codes)
- **"Name nicht auf der Whitelist":** Name muss exakt übereinstimmen
- **Seite lädt nicht:** Prüfe ob D1 binding in Cloudflare Dashboard gesetzt ist
- **API-Fehler:** Prüfe `wrangler pages deploy` Logs im Dashboard
