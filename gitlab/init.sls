{% from "gitlab/map.jinja" import gitlab with context %}

include:
  - .repo

gitlab-deps:
  pkg.installed:
    - pkgs:
      - crontabs
      - policycoreutils-python

gitlab-repo:
  pkgrepo.managed:
    - humanname: gitlab_gitlab-ce
    - baseurl: https://packages.gitlab.com/gitlab/gitlab-ce/el/$releasever/$basearch
    - gpgcheck: 0
    - gpgkey: https://packages.gitlab.com/gpg.key
    - require:
      - cmd: gitlab-repo-key

gitlab:
  pkg.installed:
    - name: gitlab-ce
    - require:
      - pkgrepo: gitlab-repo
      - pkg: gitlab-deps

  service.running:
    - name: gitlab-runsvdir
    - require:
      - pkg: gitlab
      - cmd: gitlab-upgrade
      - cmd: gitlab-reconfigure

gitlab-url:
  file.replace:
    - name: {{ gitlab.config_file }}
    - pattern: ^#?\s*external_url\s.*$
    - repl: external_url {{ gitlab.url|yaml_dquote }}
    - append_if_not_found: True
    - require:
      - pkg: gitlab

{% if 'registry_external_url' in gitlab %}
docker-registry-url:
  file.replace:
    - name: {{ gitlab.config_file }}
    - pattern: ^#?\s*registry_external_url\s.*$
    - repl: registry_external_url {{ gitlab.registry_external_url|yaml_dquote }}
    - append_if_not_found: True
    - require:
      - pkg: gitlab
{% endif %}

{% if 'mattermost_url' in gitlab %}
mattermost-url:
  file.replace:
    - name: {{ gitlab.config_file }}
    - pattern: ^#?\s*mattermost_external_url\s.*$
    - repl: external_url {{ gitlab.mattermost_url|yaml_dquote }}
    - append_if_not_found: True
    - require:
      - pkg: gitlab
{% endif %}

gitlab-config:
  file.blockreplace:
    - name: {{ gitlab.config_file }}
    - prepend_if_not_found: True

{% for section, val in gitlab.config|dictsort %}
{% for key, value in val|dictsort %}
gitlab-config-{{ section }}-{{ key }}:
  file.accumulated:
    - name: gitlab-config-accumulator
    - filename: {{ gitlab.config_file }}
    - text: |
        {{ section }}['{{ key }}'] = {% if value is string -%}
        {{ value|indent(8) }}
        {%- else -%}
        {{ value|yaml_encode }}
        {%- endif %}
    - require_in:
      - file: gitlab-config
{% endfor %}
{% endfor %}

gitlab-upgrade:
  cmd.run:
    - name: gitlab-ctl upgrade
    - onchanges:
      - pkg: gitlab

# gitlab does not initialize the service, if a docker-environment is detected
gitlab-reconfigure:
  cmd.run:
    - name: rm -f /.dockerenv && gitlab-ctl reconfigure
    - require:
      - pkg: gitlab
    - onchanges:
      - file: gitlab-config
      - file: gitlab-url
