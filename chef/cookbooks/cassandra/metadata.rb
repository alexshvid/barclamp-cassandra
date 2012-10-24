maintainer       "Mirantis, Inc"
maintainer_email "aschwid@mirantis.com"
license          "Apache 2.0 License, Copyright (c) 2012 Mirantis, Inc - http://www.apache.org/licenses/LICENSE-2.0"
description      "High-performance key-value storage."
long_description IO.read(File.join(File.dirname(__FILE__), 'README.rdoc'))
version          "1.0"
recipe           "cassandra::server", "Installs and configures the cassandra server."
