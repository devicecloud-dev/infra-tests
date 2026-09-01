// Deliberately trivial. The point is that `runScript` runs at all and that
// `${output.result}` interpolates — the JS bridge is one of the surfaces an upstream
// Maestro release can change without saying so.
output.result = 'Bristol';
