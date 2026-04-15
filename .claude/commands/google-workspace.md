# Google Workspace Integration

Automate Gmail, Google Sheets, Docs, Drive, Calendar, and Chat via the Google Workspace APIs.

## Authentication Setup

```bash
# Install Google client library
npm install googleapis

# Set up service account credentials
export GOOGLE_APPLICATION_CREDENTIALS=/path/to/service-account.json

# Or OAuth2 for user-delegated access
export GOOGLE_CLIENT_ID=...
export GOOGLE_CLIENT_SECRET=...
export GOOGLE_REFRESH_TOKEN=...
```

## Gmail

### Search & Read Emails
```ts
import { google } from 'googleapis'
const gmail = google.gmail({ version: 'v1', auth })

// Search messages
const res = await gmail.users.messages.list({
  userId: 'me',
  q: 'from:support@example.com is:unread',
  maxResults: 10,
})

// Read a message
const msg = await gmail.users.messages.get({
  userId: 'me',
  id: messageId,
  format: 'full',
})
```

### Send Email
```ts
const message = [
  'From: you@company.com',
  'To: recipient@example.com',
  'Subject: Subject line',
  '',
  'Email body here',
].join('\n')

await gmail.users.messages.send({
  userId: 'me',
  requestBody: {
    raw: Buffer.from(message).toString('base64url'),
  },
})
```

## Google Sheets

### Read Data
```ts
const sheets = google.sheets({ version: 'v4', auth })

const res = await sheets.spreadsheets.values.get({
  spreadsheetId: 'your-spreadsheet-id',
  range: 'Sheet1!A1:E100',
})
const rows = res.data.values
```

### Write Data
```ts
await sheets.spreadsheets.values.append({
  spreadsheetId: 'your-spreadsheet-id',
  range: 'Sheet1!A:E',
  valueInputOption: 'USER_ENTERED',
  requestBody: {
    values: [['Value1', 'Value2', new Date().toISOString()]],
  },
})
```

## Google Calendar

### Create Event
```ts
const calendar = google.calendar({ version: 'v3', auth })

await calendar.events.insert({
  calendarId: 'primary',
  requestBody: {
    summary: 'Meeting title',
    start: { dateTime: '2026-04-20T10:00:00-07:00', timeZone: 'America/Los_Angeles' },
    end: { dateTime: '2026-04-20T11:00:00-07:00', timeZone: 'America/Los_Angeles' },
    attendees: [{ email: 'attendee@example.com' }],
    conferenceData: { createRequest: { requestId: crypto.randomUUID() } },
  },
  conferenceDataVersion: 1,
})
```

## Google Drive

### Upload File
```ts
const drive = google.drive({ version: 'v3', auth })

await drive.files.create({
  requestBody: {
    name: 'report.pdf',
    parents: ['folder-id'],
    mimeType: 'application/pdf',
  },
  media: {
    mimeType: 'application/pdf',
    body: fs.createReadStream('./report.pdf'),
  },
})
```

## Common Automation Patterns

- **Support ticket routing:** Read Gmail → parse → create Linear issue
- **Weekly report:** Fetch metrics → write to Sheets → email summary
- **Meeting prep:** Read Calendar events → fetch attendee context → prep agenda doc
- **Expense sync:** Read expense emails → extract data → append to Sheets tracker

## Source

[VoltAgent/awesome-agent-skills — Google Workspace](https://github.com/VoltAgent/awesome-agent-skills)
