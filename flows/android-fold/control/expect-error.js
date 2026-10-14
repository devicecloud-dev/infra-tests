// Like dcd.js, but the step passes only when the server refuses the request
// with the expected HTTP status (EXPECT_STATUS). Used by the trial's error flow.
var response = http.post(DCD_CONTROL_URL + '/' + CMD, {
  headers: { 'Content-Type': 'application/json' },
  body: typeof ARGS === 'string' && ARGS ? ARGS : '{}',
});
var expected = parseInt(EXPECT_STATUS, 10);
if (response.status !== expected) {
  throw new Error('dcd ' + CMD + ': expected HTTP ' + expected + ', got ' + response.status + ' ' + response.body);
}
console.log('dcd ' + CMD + ' refused as expected: ' + response.status + ' ' + response.body);
