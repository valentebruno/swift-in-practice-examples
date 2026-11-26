# EditorialKernels

Run `swift test` in this directory with Swift 6 or later. The seven tests exercise four decisions from Swift in Practice. Each test starts with an input that could otherwise leave the app in the wrong state.

| What goes wrong | What the example checks | Read the edition |
| --- | --- | --- |
| An older flight response arrives last | Only eligible revisions for the current account and flight can replace the accepted snapshot. | [18 · State freshness](https://swiftinpractice.com/editions/18-state-freshness-and-causal-order/) |
| An upload completion arrives after cancellation or retry | The attempt and the remote object must match before verification can complete. | [23 · State machines](https://swiftinpractice.com/editions/23-state-machines-invariants-and-effects/) |
| An old or imprecise coordinate reaches a decision | The policy checks the age, accuracy, and validity of the observation. | [36 · Location quality](https://swiftinpractice.com/editions/36-coordinates-evidence-and-location-quality/) |
| An earlier spatial request finishes after a new selection | A late completion cannot replace the current presentation. | [40 · Spatial experiences](https://swiftinpractice.com/editions/40-location-intelligence-4-spatial-experiences/) |

The numbered edition folders at the repository root contain the snippets as printed. This package collects standalone teaching examples so the decisions can also be tested together.
