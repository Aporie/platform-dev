# NextEuropa

## Requirements

* Composer
* PHP Phar extension
* PhantomJS (in order to run JavaScript during Behat tests)
* PHP 7.3 or higher

## Install build system

Before we can build the NextEuropa platform we need to install the build system
itself. This can be done using [composer](https://getcomposer.org/):


```
$ composer install
```

## Customize build properties

Create a new file in the root of the project named `build.properties.local`
using your favourite text editor:

```
$ vim build.properties.local
```

This file will contain configuration which is unique to your development
machine. This is mainly useful for specifying your database credentials and the
username and password of the Drupal admin user so they can be used during the
installation.

Because these settings are personal they should not be shared with the rest of
the team. Make sure you never commit this file!

All options you can use can be found in the `build.properties.dist` file. Just
copy the lines you want to override and change their values. For example:

```
# The location of the Composer binary.
composer.bin = /usr/bin/composer

# The install profile to use.
platform.profile.name = multisite_drupal_standard

# Database settings.
drupal.db.name = my_database
drupal.db.user = root
drupal.db.password = hunter2

# Admin user.
drupal.admin.username = admin
drupal.admin.password = admin

# The base URL to use in Behat tests.
behat.base_url = http://nexteuropa.local
```

## Listing the available build commands

You can get a list of all the available Phing build commands ("targets") with a
short description of each target with the following command:

```
$ ./bin/phing
```

## Building a local development environment

```
$ ./bin/phing build-platform-dev
$ ./bin/phing install-platform
```

### From the release 2.4.x following configuration variables are available:

  - The default theme to enable, set to either "ec_resp" (default) or "ec_europa".

> platform.site.theme_default = ec_resp

  - The default Europa Component Library release which is used to build the EC Europa theme.

> ecl.version = v0.10.0
  
  - The default EC Europa theme release version.

> ec_europa.version = 0.0.2

  - The default Atomium theme build properties. Used only if default theme is set to "ec_europa".
  You can find default values of those variables below. 
  
>platform.theme.atomium.repo.url = https://github.com/ec-europa/atomium.git
>platform.theme.atomium.repo.branch = 7.x-1.x


## Building a local development environment for the EC Europa theme

There is a specific Phing target which is setting up the development environment
for the EC Europa theme needs. It helps developers to perform code reviews and
contribute code to the repositories.
It clones the repository of the Atomium and EC Europa themes. It will also
fetch the release package of the Europa Components Library and regenerate theme assets.

**To run this target you must have node.js and npm installed on your local machine.**
You need also configure additional configuration variables which are described in the
section above. The most important is to set the `platform.site.theme_default` variable
to `ec_europa`.

You can use this Phing target in the following way:
```
$ ./bin/phing build-europa-dev
```
This Phing target is meant to be used only for the local development purposes.

## Generic users.
After install, generic users are created. Login using drush user-login command.
```
$  cd ./build
$  drush uli
```
And setup a new password for these users.

## Running Behat tests

The Behat test suite is located in the `tests/` folder. When the development
version is installed (by running `./bin/phing build-platform-dev`) the Behat
configuration files (`behat*.yml`) will be generated automatically using the
base URL that is defined in `build.properties.local`.

If you are not using the development build but one of the other builds
(`build-platform-dist` or `build-multisite-dist`) and you want to run the tests
then you'll need to set up the Behat configuration manually:

```
$ ./bin/phing setup-behat
```

In order to run JavaScript in your Behat tests, you must launch a PhantomJS
instance before. Use the `--debug` parameter to get more information. Please
be sure that the webdriver's port you specify corresponds to the one in your
Behat configuration (`behat.wd_host.url: "http://localhost:8643/wd/hub"`).

```
$ phantomjs --debug=true --webdriver=8643
```

If you prefer to use an actual browser with Selenium instead of PhantomJS, you
need to define the Selenium server URL and browser to use, for instance:

```
behat.wd_host.url = http://localhost:4444/wd/hub
behat.browser.name = chrome
```

The tests can also be run from the root of the repository (or any other folder)
by calling the behat executable directly and specifying the location of the
`behat.yml` configuration file.

Behat tests can be executed from the repository root by running:

```
$ ./bin/behat -c tests/behat.yml
```

The platform can run 4 different behat profiles:
* default: it runs behat tests against a multisite_drupal_standard build using 
the "Europa" theme;
* communities: it runs behat tests against a multisite_drupal_communities build 
using the "Europa" theme;
* standard_ec_resp: it runs behat tests against a multisite_drupal_standard build using
the "ec_resp" theme;
* communities_ec_resp: it runs behat tests against a multisite_drupal_communities build
using the "ec_resp" theme;

The behat execution command mentioned above runs the tests only with the default profile. <br />
The tests will fail with it if the platform is built with the "ec_resp" theme.

To run a profile other than the default one , the following command must be executed:

```
$ ./bin/behat -c tests/behat.yml -p [profile]
```

`[profile]` stands for the profile name as written in the list above; I.E: communities,
standard_ec_resp, communities_ec_resp.

If you want to execute a single test, just provide the path to the test as an argument. 
 The tests are located in `tests/features/`. For example:

```
$ ./bin/behat -c tests/behat.yml tests/features/content_editing.feature
```

Some tests need to mimic external services that listen on particular ports, e.g.
the central server of the Integration Layer. If you already have services running
on the same ports, they will conflict. You will need to change the ports used in
build.properties.local.

Remember to specify the right configuration file before running the tests.

## Running PHPUnit tests

Custom modules and features can be tested against a running platform installation
by using PHPUnit. When the development version is installed (by running
`./bin/phing build-platform-dev`) the PHPUnit configuration file `phpunit.xml`
will be generated automatically using configuration properties defined in
`build.properties.local`.

If you are not using the development build but one of the other builds
(`build-platform-dist` or `build-multisite-dist`) and you want to run PHPUnit tests
then you'll need to set up the PHPUnit configuration manually by running:

```
$ ./bin/phing setup-phpunit
```

Each custom module or feature can expose unit tests by executing the following steps:

- Add `registry_autoload[] = PSR-4` to `YOUR_MODULE.info`
- Create the following directory: `YOUR_MODULE/src/Tests`
- Add your test classes in the directory above

In order for test classes to be autoloaded they must follow the naming convention below:

- File name must end with `Test.php`
- Class name and file name must be identical
- Class namespace must be set to `namespace Drupal\YOUR_MODULE\Tests;`
- Class must extend `Drupal\nexteuropa\Unit\AbstractUnitTest`

The following is a good example of a valid unit test class:

```php
<?php

/**
 * @file
 * Contains \Drupal\nexteuropa_core\Tests\ExampleTest.
 */

namespace Drupal\nexteuropa_core\Tests;

use Drupal\nexteuropa\Unit\AbstractUnitTest;

/**
 * Class ExampleTest.
 *
 * @package Drupal\nexteuropa_core\Tests
 */
class ExampleTest extends AbstractUnitTest {
  ...
}
```

PHPUnit tests can be executed from the repository root by running:

```
$ ./bin/phpunit -c tests/phpunit.xml
```

## Running Drupal Simpletests on the platform

Check the documentation [here](https://webgate.ec.europa.eu/fpfis/wikis/x/NJUQE)

## Checking for coding standards violations

After executing the 'setup-php-codesniffer' Phing target,
PHP CodeSniffer will be set up and can be run with the following command:

```
# Scan all files for coding standards violations.
$ ./bin/phpcs

# Scan only a single folder.
$ ./bin/phpcs profiles/common/modules/custom/ecas
```

# Docker-compose.yml file

Our developement environment already provides a docker-compose.yml file.
It can be found on https://github.com/ec-europa/cloud9/blob/master/salt/docker/files/docker-compose/docker-compose-all.yml

# Patches

## Make file patches

Make file patches are added to drupal.org contributed modules while building the platform, just after the contributed modules
gets downloaded.

## Composer patches

Composer patches are added via cweagans/composer-patches to projects via composer.json.

### rych/random

Add PHP 7 compatibility.
```
"https://github.com/rchouinard/rych-random/pull/5": "https://patch-diff.githubusercontent.com/raw/rchouinard/rych-random/pull/5.patch"
```

Provide new generator that works with PHP version >= 7.1
```
"https://github.com/rchouinard/rych-random/pull/7": "https://patch-diff.githubusercontent.com/raw/rchouinard/rych-random/pull/7.patch
```

### apereo/phpcas

Prevent infinite loops, see https://webgate.ec.europa.eu/CITnet/jira/browse/NEPT-2160
To better handle XML parsing for attributes (modification of http://www.akchauhan.com/convert-xml-to-array-using-dom-extension-in-php5/),
see https://webgate.ec.europa.eu/CITnet/jira/browse/NEPT-1278, https://webgate.ec.europa.eu/CITnet/jira/browse/NEXTEUROPA-11605
```
"phpCAS-1.4.0_handle_XML_parsing_ECAS_attributes.patch": "../resources/patches/phpCAS-1.4.0_handle_XML_parsing_ECAS_attributes.patch"
```

