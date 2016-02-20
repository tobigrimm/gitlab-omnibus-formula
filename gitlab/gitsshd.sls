{% from "gitlab/map.jinja" import gitlab with context %}
{% set is_selinux_enabled = salt.cmd.retcode('selinuxenabled') == 0 %}

gitsshd:
  file.managed:
    - name: /etc/systemd/system/gitsshd.service
    - source: salt://gitlab/files/gitsshd.service

  module.wait:
    - name: service.systemctl_reload
    - watch:
      - file: gitsshd

  service.running:
    - name: gitsshd
    - enable: True
    - require:
      - file: gitsshd
      - file: gitsshd-config

gitsshd-config:
  file.managed:
    - name: /etc/ssh/gitsshd_config
    - template: jinja
    - source: salt://gitlab/files/gitsshd_config
    - user: root
    - group: root
    - mode: 600
    - defaults:
        config: {{ gitlab.gitsshd }}

{% if is_selinux_enabled %}
policycoreutils-python:
  pkg.installed:
    - name: policycoreutils-python

gitsshd-selinux-pid:
  cmd.run:
    - name: semanage fcontext -a -t sshd_var_run_t '{{ gitlab.gitsshd.pidfile }}'
    - unless: semanage fcontext --list | grep '{{ gitlab.gitsshd.pidfile }}' | grep sshd_var_run_t
    - require:
      - pkg: policycoreutils-python
    - require_in:
      - service: gitsshd

gitsshd-selinux-port:
  cmd.run:
    - name: semanage port -a -t ssh_port_t -p tcp {{ gitlab.gitsshd.port }}
    - unless: semanage port --list | grep ssh_port_t | grep {{ gitlab.gitsshd.port }}
    - require:
      - pkg: policycoreutils-python
    - require_in:
      - service: gitsshd

gitsshd-selinux-restorecon:
  module.wait:
    - name: file.restorecon
    - path: {{ gitlab.gitsshd.pidfile }}
    - watch:
      - cmd: gitsshd-selinux-pid
{% endif %}
