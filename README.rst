======================
gitlab-omnibus-formula
======================

.. image:: https://travis-ci.org/corux/gitlab-omnibus-formula.svg?branch=master
    :target: https://travis-ci.org/corux/gitlab-omnibus-formula

Installs the GitLab CE server from the Omnibus package.

Available states
================

.. contents::
    :local:

``gitlab-omnibus``
------------------

Installs the GitLab CE server from the Omnibus packages.

``gitlab-omnibus.gitsshd``
--------------------------

Sets up a SSH Server configuration, which allows only the git user to connect.

``gitlab-omnibus.runner``
-------------------------

Setup the GitLab CI runner.


Configuration
=============

Configuration happens via a pillar, see example.pillar for basic usage.
You can add additional key/value configuration items for gitlab.rb into the pillar, for example 
to configure letsencrypt:
::
       letsencrypt:
         enable: True
         contact_emails: "email@domain"
                   

