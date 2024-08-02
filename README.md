# work in progress: tmux-healthchecks
what's this...
## Installation
This requires `jq`.
install with TPM in the standard way and stuff
or
manual install
## Usage/configuration
set this and that, api key
```
@healthchecks_api_key
@healthchecks_update_interval (in seconds, defaults to 5min, can't be lower than tmux's status-interval)
@healthchecks_cache_file (defaults to /tmp/tmux-healthchecks-(first 6 chars of your api_key))
TODO: @healthchecks_api_endpoint
TODO: @healchchecks_display_down
TODO: @healthchecks_bell_down
```
this plugin provides the following status variables:
```
#{healthchecks_down_number}
#{healthchecks_status_icon}
TODO: #{healthchecks_status_color}
TODO: #{healthchecks_status_shorttext}
TODO: #{healthchecks_status_detailstext} ("all good" if everything's up, name of at least 1 down and total number of checks down otherwise)
```


### Customization
```
TODO: @healthchecks_up_text UP
@healthchecks_up_icon 󰗶
TODO: @healthchecks_up_style

TODO: @healthchecks_down_text DOWN
@healthchecks_down_icon 
TODO: @healthchecks_down_style

TODO: @healthchecks_unknown_text unknown
@healthchecks_unknown_icon ?
TODO: @healthchecks_unknown_style
```

# TODO:
- check escaping
- rename shorttext and detailstext
- rename color to style or at least be consistent
- implement endpoint stuff
- sane defaults
- add a bell/message whenever anything goes down
- be polite and set the old IFS whenever it's changed
- add some kind of persistence such that when you log into tmux you get notified of checks that went down while you were offline
- make it work with a separate tpm environment
- make a catppuccin plugin compat script
- actually make the cache work
