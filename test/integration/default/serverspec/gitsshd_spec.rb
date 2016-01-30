require "serverspec"

set :backend, :exec

describe service("gitsshd") do
  it { should be_enabled }
  it { should be_running }
end

describe port("22448") do
  it { should be_listening }
end
