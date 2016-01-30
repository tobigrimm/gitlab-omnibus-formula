require "serverspec"

set :backend, :exec

describe service("gitlab-runner") do
  it { should be_enabled }
  it { should be_running }
end
