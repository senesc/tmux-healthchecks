# WIP: tmux-healthchecks
Monitor your [Healthchecks](https://healthchecks.io) project from within tmux!
> [!WARNING]
> This repository is a work in progress, so option names etc. are likely to change any moment. Feel free to try it out though! What isn't in the TODO section has already been implemented and should work.

## Features
- Responses are cached to make fewer requests
- 

## Installing

This plugin requires `jq`.
### Installing with TPM (recommended)
1. [Install TPM](https://github.com/tmux-plugins/tpm?tab=readme-ov-file#installation)
2. Add this plugin to your tmux config:
    ```
    set -g @plugin "senesc/tmux-healthchecks"
    ```
3. Reload your config and install with `prefix + I`
### Manual install
1. Clone this repo to the desired location;
2. Add the following line to the bottom of your config file:
   ```
   run-shell "~/path/to/repo/healthchecks.tmux"
   ```
3. Reload your config or restart tmux

## Usage and customization
For this plugin to work, you must create a read-only API key from your project settings page, and put it in the <code>@healthchecks_api_key</code> variable:
```
set -g @healthchecks_api_key "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
```

There are three possible statuses to determine icons, text, styles etc.:
- **Up**: when all checks of the project are up
- **Down**: when at least one check is down
- **Unknown**: when the network is not reachable, the API key is missing or any error occurs.

### Status bar variables
<h4><code>#{healthchecks_down_count}</code></h4>
The number of checks that are currently down.

<h4><code>#{healthchecks_status_icon}</code></h4>
An icon representing the status, by default "&lt;3", "&lt;/3" and "?" respectively for <i>up</i>, <i>down</i> and <i>unknown</i>. Can be changed by setting the <code>@healthchecks_up_icon</code>, <code>@healthchecks_down_icon</code> and <code>@healthchecks_unknown_icon</code> options.

<h4><code>#{healthchecks_status_short}</code></h4>
A static message, by default "UP", "DOWN" or "unknown". Can be changed by setting <code>@healthchecks_up_short</code>, <code>@healthchecks_down_short</code> and <code>@healthchecks_unknown_short</code>.
<h4><code>#{healthchecks_status_details}</code></h4>
If at least one check is down shows its slug and how many are down in total (e.g. <i>office-backup & 2 others</i>). Otherwise, defaults are "all UP" and "unknown". While the <i>down</i> text is fixed, the latter two can be changed by setting <code>@healthchecks_up_details</code> and <code>@healthchecks_unknown_details</code>.

<h4><code>#{healthchecks_icon_style}</code></h4>
Style that should be associated with the icon, depends on current status. Defaults to the value of <code>status-style</code> and can be changed by setting <code>@healthchecks_up_icon_style</code>, <code>@healthchecks_down_icon_style</code> and <code>@healthchecks_unknown_icon_style</code> to something like <code>"#[fg=green,bg=default,bold]"</code>.

<h4><code>#{healthchecks_text_style}</code></h4>
The same as above, except this is intended to be used with short/details text. Style options are <code>@healthchecks_up_text_style</code>, <code>@healthchecks_down_text_style</code> and <code>@healthchecks_unknown_text_style</code>.

<hr>

You can use these in your config, for example, by appending them to your `status-right`:
```
set -ag status-right "#{healthchecks_icon_style}#{healthchecks_status_icon} #{healthchecks_text_style}#{healthchecks_status_details}"
```

### Keybindings
- `prefix + H` to show the list of all checks along with their statuses. Can be changed by setting `@healthchecks_list_key`
- `prefix + Alt-h` to force the refresh (see Cache). Key can be changed by setting `@healthchecks_update_key`

### Cache
Since refreshing the project status every 15 seconds (or whatever is set in your `status-interval` option) is kinda useless and would probably get you a *429 too many requests* pretty quickly, this plugin caches the API response and sets an independent update interval:
```
set -g @healthchecks_update_interval [seconds]
```
Please note that this value can't be lower than `status-interval`, because the actual UI updates depend on that. The default value is 300 seconds (or 5 minutes).

With <code>@healthchecks_cache_file</code> you can customize where the cache is stored:
```
set -g @healthchecks_cache_file "/tmp/my/path"
```
By default, it is saved to `/tmp/tmux-healthchecks-` followed by the first 6 characters of your API key, which allows different tmux sessions to monitor different projects.

---

## TODO:
```
@healthchecks_api_endpoint
@healchchecks_display_down
@healthchecks_bell_down
```

- make the check shown in details the latest one to go off
- implement endpoint stuff
- sane defaults
- add a bell/message whenever anything goes down
- add some kind of persistence such that when you log into tmux you get notified of checks that went down while you were offline
- test it with tpm installation
- make a catppuccin/etc. plugin compat script
- add a xdg-open healthchecks.io keybind
- how can one disable keybinds?
- add screenshots
- correct whatever bug creates the /tmp/tmux-healthchecks- file
