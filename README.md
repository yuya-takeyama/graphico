Graphico
========

[![Build Status](https://travis-ci.org/yuya-takeyama/graphico.png?branch=master)](https://travis-ci.org/yuya-takeyama/graphico)
[![Coverage Status](https://coveralls.io/repos/yuya-takeyama/graphico/badge.png?branch=master)](https://coveralls.io/r/yuya-takeyama/graphico)

Visualize data, drive business.

What is Graphico?
-----------------

Graphico is web-based statistics visualizer.

Statistics data can be saved via RESTful Web API and your data will be displayed as chart immediately.

Installation
------------

### From GitHub

```
# Checkout
$ git clone https://github.com/yuya-takeyama/graphico.git
$ cd graphico

# Make your own settings
$ cp config/apps.example.rb config/apps.rb
$ cp config/database.example.rb config/database.rb

# Boot as rack application
```

Basic Usage
-----------

### Input data

Currenlty, only daily statistics is available.

```
$ curl -X PUT -i -d 'count=1200' 'http://graphico.dev/api/v0/stats/:service_name/:section_name/:chart_name/daily/2013-01-03'
```

Author
------

Yuya Takeyama
