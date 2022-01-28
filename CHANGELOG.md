# Changelog

## 25-1-2022

**BREAKING CHANGES**: This version drastically changes how configuration information is submitted to the module. Instead of complex variable types, the module now uses JSON for the entire organization configuration.

### Changes applied

* Changed inputs: Removed the `workspace` and `teams` variables and added the `config_file_path` variable. 
* Changed input type: Replaced complex variables with JSON-based input.
* Replaced `count` with `for_each`: Changed to deal with evaluation issues associated with `count` looping.

## 28-1-2022

### Changes applied

* Added data normalization for teams and workspaces to support more arguments
* Arguments can be omitted from JSON doc and defaults will be selected during normalization