// Calls the run's device-control server (DCD_CONTROL_URL, set by DeviceCloud
// for foldable runs and for flows that opt in). Use from a flow as:
//
//   - runScript: { file: dcd.js, env: { CMD: posture, ARGS: '{"posture":"open"}' } }
//
// CMD is the route (state, posture, tap, longPress, swipe, screenshot) and
// ARGS its JSON body. A non-2xx answer fails the step with the server's
// message; the parsed response is left in output.dcd.
var route = CMD;
var method = route === 'state' ? 'get' : 'post';
var response = method === 'get'
  ? http.get(DCD_CONTROL_URL + '/' + route)
  : http.post(DCD_CONTROL_URL + '/' + route, {
      headers: { 'Content-Type': 'application/json' },
      body: typeof ARGS === 'string' && ARGS ? ARGS : '{}',
    });
if (!response.ok) {
  throw new Error('dcd ' + route + ' failed: HTTP ' + response.status + ' ' + response.body);
}
output.dcd = json(response.body);
console.log('dcd ' + route + ' -> ' + response.body);
