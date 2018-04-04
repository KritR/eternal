# [eternal] (//github.com/kritr/eternal)

[![Build Status](https://travis-ci.org/KritR/eternal.svg?branch=master)](https://travis-ci.org/KritR/eternal)
[![Coverage Status](https://coveralls.io/repos/github/KritR/eternal/badge.svg?branch=master)](https://coveralls.io/github/KritR/eternal?branch=master)
[![Maintainability](https://api.codeclimate.com/v1/badges/7a13b8b52ff3263a2626/maintainability)](https://codeclimate.com/github/KritR/eternal/maintainability)

A parser for event timings and occurrences

## Usage

````Eternal.parse('I have dance practice every friday at 5 pm')````
will return an ````ice_cube```` object with the rule to repeat weeekly on fridays at 5pm.

Additional context can then be inputted into this object to complete the rule.
