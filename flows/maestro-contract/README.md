# Maestro artifact-contract flows

Used only by `maestro-version-validate.yml`. They exist to make a new Maestro version
produce a **full** artifact bundle, so the bundle can be checked, rather than to test
Wikipedia.

Each platform has a passing and a deliberately failing flow, and both go further than
the `*-simple` flows the nightly sweeps use:

- a **subflow**, so per-flow bundle directories are exercised — Maestro 2.7.0 moved
  those, and `commands.json` with them
- a **`runScript`** with `${output.…}` interpolation, so the JS bridge is exercised
- a **conditional `runFlow: when:`**, the construct customer workspaces use most and
  the one most likely to change parse behaviour
- for the failing flow, several passing steps **before** the failure, so the bundle
  has a real step history, a failure screenshot, and a `testResult.txt` with content.
  A flow that fails on its first command proves almost nothing about the contract.
- **named `takeScreenshot`s**: flat and nested on the passing flow, and one on the
  failing flow before it fails. Maestro 2.7.0 moved where these land, and the platform
  dropped every one for five releases without any check noticing.

`required-artifacts.txt` lists every file these flows must leave in the bundle, by
name, and `maestro-version-validate.yml` requires all of them in every bundle. Add a
line when a flow starts producing something a customer relies on.

The failing flow must fail on an assertion, not a syntax error: a parse error produces
an empty FAILED with no bundle at all, which is a different (also real) failure mode
and not what these are checking.
