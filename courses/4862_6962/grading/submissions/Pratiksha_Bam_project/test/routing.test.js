// HTTP integration tests for real routes, images, and sendFile error handling.
const { test } = require('node:test');
const assert = require('node:assert/strict');
const fs = require('node:fs');
const path = require('node:path');
const app = require('../app');

test('assignment routes and file error responses', async () => {
  const server = app.listen(0, '127.0.0.1');
  await new Promise(resolve => server.once('listening', resolve));
  const base = `http://127.0.0.1:${server.address().port}`;
  const originalSendFile = app.response.sendFile;
  try {
    let response = await fetch(base + '/');
    assert.equal(response.status, 200);
    const index = await response.text();
    const books = [
      ['9780593440872', 'Book Lovers', '17.00'],
      ['9780593441190', 'Happy Place', '19.00'],
      ['9780593441213', 'Funny Story', '19.00']
    ];
    for (const [isbn, title, price] of books) {
      assert.ok(index.includes(`http://localhost:3000/select/${isbn}`));
      response = await fetch(base + '/select/' + isbn);
      assert.equal(response.status, 200);
      const body = await response.text();
      for (const text of [title, `Price: $${price}`, 'Pratikshya Bam', `/images/${isbn}.jpg`]) {
        assert.ok(body.includes(text), `Book page contains ${text}`);
      }
      response = await fetch(base + `/images/${isbn}.jpg`);
      assert.equal(response.status, 200);
      assert.ok(response.headers.get('content-type').includes('image/jpeg'));
      const local = fs.readFileSync(path.resolve(__dirname, '../Pages/images', `${isbn}.jpg`));
      assert.deepEqual(Buffer.from(await response.arrayBuffer()), local);
    }
    for (const url of ['/select/0000000000000', '/unknown', '/9780593440872.html', '/select/index', '/images/missing.jpg', '/select/%2e%2e%2fapp.js']) {
      response = await fetch(base + url);
      assert.equal(response.status, 404, url);
      assert.equal(await response.text(), 'File Not Found', url);
    }
    // Inject file-system errors into the sendFile callback without changing files.
    for (const [code, status, text] of [['ENOENT', 404, 'File Not Found'], ['EIO', 500, 'Server Error']]) {
      app.response.sendFile = function(file, options, callback) {
        const error = new Error('Simulated file error');
        error.code = code;
        callback(error);
        return this;
      };
      response = await fetch(base + '/select/9780593440872');
      assert.equal(response.status, status);
      assert.equal(await response.text(), text);
    }
  } finally {
    app.response.sendFile = originalSendFile;
    await new Promise(resolve => server.close(resolve));
  }
});
