source 'https://supermarket.chef.io'

metadata

cookbook 'kagent', github: 'karamelchef/kagent-chef'

group :integration do
  cookbook 'apt'
  cookbook 'zookeeper_tester', path: 'test/cookbooks/zookeeper_tester'
end
