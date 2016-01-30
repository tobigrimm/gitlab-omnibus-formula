==============
gitlab-formula
==============

.. image:: https://travis-ci.org/corux/gitlab-formula.svg?branch=master
    :target: https://travis-ci.org/corux/gitlab-formula

Installs the GitLab CE server.

Available states
================

.. contents::
    :local:

``gitlab``
------------

Installs the GitLab CE server from the Omnibus packages.

``gitlab.gitsshd``
------------

Sets up a SSH Server configuration, which allows only the git user to connect.

``gitlab.runner``
------------

Setup the GitLab CI runner.
