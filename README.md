# WIP: tmux-healthchecks
Monitor your [Healthchecks](https://healthchecks.io) project from within tmux!
> [!WARNING]
> This repository is a work in progress, and variable names, option names etc. are likely to change any moment. Feel free to try it out though! What isn't in the TODO section has already been implemented and should work.

<details>
<summary><h2>Installing</h2></summary>

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
</details>

## Usage
Among most plugin components there are three possible statuses to determine icons, text, styles etc.:
- **Up**: when all checks of the project are up
- **Down**: when at least one check is down
- **Unknown**: when the network is not reachable, the API key is missing or any error occurs

After setting at least your API key (see Configuration and customization), this is what the plugin provides:
### Status bar variables
- `#{healthchecks_down_count}`: the number of checks that are currently down
- `#{healthchecks_status_icon}`: an icon representing the status
- `#{healthchecks_status_short}`: a static message, by default "UP" or "DOWN"
- `#{healthchecks_status_details}`: lets you know which check is down and how many are down in total
- `#{healthchecks_icon_style}`
- `#{healthchecks_text_style}`

you can use these in your config, for example, by appending them to your `status-right`:
```
set -ag status-right "#{healthchecks_icon_style}#{healthchecks_status_icon} #{healthchecks_text_style}#{healthchecks_status_details}"
```

### Keybinds
- `prefix + H` to force the refresh (see Cache)
- `prefix + D` to show the list of all checks that are currently down.

## Configuration and customization
For this plugin to work, you must create a read-only API key from your project settings page, and put it in the `@healthchecks_api_key` variable:
```
set -g @healthchecks_api_key "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
```
### Cache
Since refreshing the project status every 15 seconds (or whatever is set in your `status-interval` option) is kinda useless and would probably get you a *429 too many requests* pretty quickly, this plugin caches the API response and allows setting an independent update interval:
```
set -g @healthchecks_update_interval [seconds]
```
Please note that this value can't be lower than `status-interval`, because the actual UI updates depend on that. The default value is 300 seconds (or 5 minutes).

With `@healthchecks_cache_file` you can customize where the cache is stored:
```
set -g @healthchecks_cache_file "/tmp/my/path"
```
By default, it is saved to `/tmp/tmux-healthchecks-` followed by the first 6 chars of your API key, which allows different sessions to monitor different projects.

### Changing keybinds
Status updates can be forced: the default keybind is `prefix + H`, but it can be changed with the following option:
```
set -g @healthchecks_update_key H
```

### Customization
These are the options (along with their defaults) that you can set to customize the output.
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
Styles all default to `status-style` and can be set to something like `"#[fg=green,bg=default,bold]"`. The `down_details` text can't be changed and contains the name of the latest check to go off and the number of other checks currently down (e.g. *office-backup & 2 others*).

---

## TODO:
```
@healthchecks_api_endpoint
@healchchecks_display_down
@healthchecks_bell_down
@healthchecks_list_key
```

- check escaping
- make the check shown in details the latest one to go off
- implement down list (and related keybind) (make it one per line, with nice formatting and colors) (maybe list all checks, not just down ones)
- implement endpoint stuff
- sane defaults
- add a bell/message whenever anything goes down
- add some kind of persistence such that when you log into tmux you get notified of checks that went down while you were offline
- test it with tpm installation
- make a catppuccin/etc. plugin compat script
- add a xdg-open healthchecks.io keybind
- how can one disable keybinds?
- add screenshots
