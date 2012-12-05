# duplicity [![Build Status](https://secure.travis-ci.org/hectcastro/chef-duplicity.png?branch=master)](http://travis-ci.org/hectcastro/chef-duplicity)

## Description

Installs and configures [duplicity](http://duplicity.nongnu.org/), along with
an LWRP for issuing backup, restore, and verification tasks.

## Requirements

### Platforms

* CentOS 6.3

### Cookbooks

* build-essential
* python
* yum

## Attributes

* `node["duplicity"]["version"]` - Version of duplicity to install.
* `node["duplicity"]["dir"]` - Directory to install into.
* `node["duplicity"]["url"]` - URL to the duplicity archive.
* `node["duplicity"]["checksum"]` - Checksum of the duplicity archive.

## Recipes

* `recipe[duplicity]` will install duplicity.

## Usage

This cookbook was created primarily to facilitate data migrations to and from
ephemeral volumes in EC2.  Thus, only the S3 related featuers of duplicity have
been well tested.  If you are interested in using these LWRPs for the FTP, SCP,
or Google Docs backends, please be cautious.  Also, pull requests are welcome!

``` ruby
duplicity "/home/vagrant/test" do
  source "/home/vagrant/test"
  destination "s3+http://duplicity-test"
  aws_access_key "<AWS_ACCESS_KEY_ID>"
  aws_secret_access_key "<AWS_SECRET_ACCESS_KEY>"
  action :backup
end

duplicity "/home/vagrant/test" do
  source "s3+http://duplicity-test"
  destination "/home/vagrant/test"
  aws_access_key "<AWS_ACCESS_KEY_ID>"
  aws_secret_access_key "<AWS_SECRET_ACCESS_KEY>"
  action :restore
end
```
