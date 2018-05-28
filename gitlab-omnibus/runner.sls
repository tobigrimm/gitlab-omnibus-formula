{% from "gitlab-omnibus/map.jinja" import gitlab with context %}

{%- if grains.os_family == 'RedHat' %}
include:
  - .repo
{%- endif %}

gitlab-runner-deps:
  pkg.installed:
    - pkgs:
      {%- if grains.os_family == 'Debian' %}
      - python-apt
      - apt-transport-https
      {%- elif grains.os_family == 'RedHat' %}
      - crontabs
      - policycoreutils-python
      {%- endif %}

{%- if grains.os_family == 'Debian' %}
gitlab-runner-preference:
  file.managed:
    - name: /etc/apt/preferences.d/90_gitlab_runner
    - contents: |
        Explanation: Prefer GitLab provided packages over the Debian native ones
        Package: gitlab-runner
        Pin: origin packages.gitlab.com
        Pin-Priority: 1001
{%- endif %}

gitlab-runner-repo:
  pkgrepo.managed:
    - humanname: Gitlab CI Repository
    {%- if grains.os_family == 'Debian' %}
    - name: deb https://packages.gitlab.com/runner/gitlab-runner/{{ grains.os|lower }} {{ grains.oscodename }}
    - file: /etc/apt/sources.list.d/gitlab_runner.list
    - key_url: {{ gitlab.gpgkey_url }}
    - require:
      - file: gitlab-runner-preference
    {%- elif grains.os_family == 'RedHat' %}
    - baseurl: https://packages.gitlab.com/runner/gitlab-runner/el/$releasever/$basearch
    - gpgcheck: 0
    - gpgkey: {{ gitlab.gpgkey_url }}
    - require:
      - cmd: gitlab-repo-key
    {%- endif %}

gitlab-runner:
  pkg.installed:
    - name: gitlab-runner
    - require:
      - pkgrepo: gitlab-runner-repo
      - pkg: gitlab-runner-deps
