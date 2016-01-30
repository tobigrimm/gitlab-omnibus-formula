require "serverspec"

set :backend, :exec

describe service("gitlab-runsvdir") do
  it { should be_enabled }
  it { should be_running }
end

describe port("80") do
  it { should be_listening }
end
