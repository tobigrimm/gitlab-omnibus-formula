include:
  - .repo

gitlab-runner-repo:
  pkgrepo.managed:
    - humanname: runner_gitlab-ci-multi-runner
    - baseurl: https://packages.gitlab.com/runner/gitlab-ci-multi-runner/el/7/$basearch
    - gpgcheck: 0
    - gpgkey: https://packages.gitlab.com/gpg.key
    - require:
      - cmd: gitlab-repo-key

gitlab-runner:
  pkg.installed:
    - name: gitlab-ci-multi-runner
