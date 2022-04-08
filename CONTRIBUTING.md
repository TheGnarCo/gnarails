# How to contribute to Gnarails

Thank you for your interest in contributing to the project! All contributors
are expected to adhere to our [Code of Conduct](CODE_OF_CONDUCT.md).

## Find a bug?

* Create an issue explaining succinctly, but clearly, the problem encountered.
  Include details such as:
  * Steps to reproduce.
  * Example output or behavior that shows the bug reported.
  * Gem version.
  * Ruby version.
  * Rails version.
  * A failing test.

## Interested in a new feature?

* Create an issue explaining the feature. Include information such as:
  * Use case(s) for the feature.
  * Benefits of the feature.
  * Alternatives to the feature, if aware of any.
  * Implementation information, if aware of any.

## Submitting a change?

1. Fork the repository.
2. Create a feature branch.
   * `git checkout -b feature-branch-name`
3. Implement the change.
4. Include tests to verify the change performs as expected.
5. Run the test suite locally to ensure the change doesn't affect other
   functionality.
   * `bin/rspec`
6. Commit progress in [atomic commits](https://en.wikipedia.org/wiki/Atomic_commit).
   * `git commit -am "A message with an informative title, and detailed description
in subsequent paragraphs"`
7. Push the change to the remote.
   * `git push origin feature-branch-name`
8. Submit a pull request.

If you're not sure how to test the change being proposed, submit a PR and
include a comment saying you need help with the test.

This repository strives to adhere to the style guidelines derived from
[gnar-style](https://github.com/TheGnarCo/gnar-style). Please run rubocop
against your changes to check for style deviations: `bundle exec rubocop
<file.rb>`.
