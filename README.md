# WIP: tmux-healthchecks
Monitor your [Healthchecks](https://healthchecks.io) project from within tmux!
> [!WARNING]
> This repository is a work in progress, and variable names, option names etc. are likely to change any moment. Feel free to try it out though! What you see in the top part of this README has already been implemented.

## Installing
This plugin requires `jq`.
### Installing with TPM
After installing TPM, add this plugin to your tmux config:
```
set -g @plugin "senesc/tmux-healthchecks"
```
then reload your config and install it with `prefix + I`
### Manual install
To install this manually, clone this repo to the desired location and add to the bottom of the config file:
```
run-shell "~/path/to/repo/healthchecks.tmux"
```

## Configuring
For this plugin to work, you must create a read-only API key from your project settings page, and put it in the `@healthchecks_api_key` variable:
```
set -g @healthchecks_api_key "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
```
Since refreshing the project status every 15 seconds (or whatever is set in your `status-interval` option) is kinda useless and would probably get you a *429 too many requests* pretty quickly, this plugin caches the API response and allows setting an independent update interval:
```
set -g @healthchecks_update_interval [seconds]
```
Please note that this value can't be lower than `status-interval`, because the actual UI updates depend on that. The default value is 300 seconds (or 5 minutes).

With `@healthchecks_cache_file` you can customize where the cache is stored:
```
set -g @healthchecks_cache_file "/tmp/my/path"
```
By default, it is saved to `/tmp/tmux-healthchecks-` followed by the first 6 chars of your API key, as to allow different sessions to monitor different projects.

### Usage
After configuring at least the API key, you can include one or more of the variables provided to your status bar config, e.g.:
```
set -ag status-right "#{healthchecks_status_icon} #{healthchecks_status_details}"
```
The provided variables are:
- `#{healthchecks_down_count}`: displays the number of checks that are down
- `#{healthchecks_status_icon}`
- `#{healthchecks_status_details}` when something's down shows something like "down-check-slug & 3 others"
- `#{healthchecks_status_short}`: "UP" or "DOWN"
- `#{healthchecks_icon_style}`
- `#{healthchecks_text_style}`

### Customization
These are the options (along with their defaults) that you can set to customize the output. "Up" means all checks are up. If any check is down, "Down" is displayed. If the network is not reachable or there's any error, the output is determined by "Unknown".
```
set -g @healthchecks_up_short "UP"
set -g @healthchecks_up_details "all UP"
set -g @healthchecks_up_icon "󰗶"
set -g @healthchecks_up_icon_style
set -g @healthchecks_up_text_style

set -g @healthchecks_down_short "DOWN"
set -g @healthchecks_down_icon ""
set -g @healthchecks_down_icon_style
set -g @healthchecks_down_text_style

set -g @healthchecks_unknown_short "unknown"
set -g @healthchecks_unknown_details "unknown"
set -g @healthchecks_unknown_icon "?"
set -g @healthchecks_unknown_icon_style
set -g @healthchecks_unknown_text_style
```
Styles all default to `status-style` and can be set to something like `"#[fg=green,bg=default,bold]"`


---

## TODO:
```
@healthchecks_api_endpoint
@healchchecks_display_down
@healthchecks_bell_down
```

- check escaping
- implement endpoint stuff
- sane defaults
- add a bell/message whenever anything goes down
- add some kind of persistence such that when you log into tmux you get notified of checks that went down while you were offline
- test it with tpm installation
- make a catppuccin/etc. plugin compat script
- add manual refresh keybind (and maybe a xdg-open healthchecks.io keybind)
- add screenshots
