{% from "gitlab-omnibus/map.jinja" import gitlab with context %}

{%- if grains.os_family == 'RedHat' %}
gitlab-repo-key:
  cmd.run:
    - name: rpm --import {{ gitlab.gpgkey_url }}
    - unless: rpm -qi gpg-pubkey-e15e78f4
{%- endif %}
