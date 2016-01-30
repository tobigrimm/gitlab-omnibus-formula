gitlab-repo-key:
  cmd.run:
    - name:  rpm --import https://packages.gitlab.com/gpg.key
    - unless: rpm -qi gpg-pubkey-e15e78f4
