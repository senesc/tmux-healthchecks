# WIP: tmux-healthchecks
what's this...
## Installation
install with TPM and stuff
or
manual install
## Usage/configuration
set this and that, api key
```
@healthchecks_api_key
@healthchecks_api_endpoint
@healchchecks_display_down
@healthchecks_bell_down
```
this plugin provides the following variables:
```
#{healthchecks_status_icon}
#{healthchecks_status_color}
#{healthchecks_down_number}

#{healthchecks_status_shorttext}
#{healthchecks_status_detailstext} ("all good" if everything's up, name of at least 1 down and total number of checks down otherwise)
```


### Customization
```
@healthchecks_up_text UP
@healthchecks_up_icon 󰗶
@healthchecks_up_style

@healthchecks_down_text DOWN
@healthchecks_down_icon 
@healthchecks_down_style

@healthchecks_unknown_text unknown
@healthchecks_unknown_icon ?
@healthchecks_unknown_style
```

# TODO:
- check escaping
- rename shorttext and detailstext
- rename color to style
