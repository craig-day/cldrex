# CLDRex

:warning: This is still a WIP.  Many of the features are not implemented yet, but are being actively developed.

CLDRex uses Unicode's Common Locale Data Repository (CLDR) to localize text.

This project takes many hints and guidance from [TwitterCldr](https://github.com/twitter/twitter-cldr-rb)

## Installation

  1. Add cldrex to your list of dependencies in `mix.exs`:

        def deps do
          [{:cldrex, "~> 0.0.1-dev.3"}]
        end

  2. Ensure cldrex is started before your application:

        def application do
          [applications: [:cldrex]]
        end

## Support

The following data from the CLDR is supported.

| Key                | Meaning           |
| -------------      | -------------     |
| :white_check_mark: | Supported         |
| :warning:          | In Progress       |
| :no_entry_sign:    | Not Yet Supported |

  - Languages Names :white_check_mark:
  - Calendar
      - Months :white_check_mark:
      - Days :warning:
      - Quarters :no_entry_sign:
      - Day Periods :no_entry_sign:
  - Dates :no_entry_sign:
  - Times :no_entry_sign:
  - Numbers
      - Basic :no_entry_sign:
      - Currency :no_entry_sign:
      - Percent :no_entry_sign:
      - Decimal :no_entry_sign:

## Usage

For now, view the documentation on [hexdocs](https://hexdocs.pm/cldrex/0.0.1-dev.3/CLDRex.Calendar.html).

## Contribute

PRs welcome.

- Fork the project.
- Make your feature addition or bug fix.
- Add tests for it.
- Commit, do not mess with version, or history. (If you want to have your own version, that is fine but bump version in a commit by itself I can ignore when I pull.)
- Submit a pull request.
