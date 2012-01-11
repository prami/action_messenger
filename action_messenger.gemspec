# Provide a simple gemspec so you can easily use your
# project in your rails apps through git.
Gem::Specification.new do |s|
  s.name = "action_messenger"
  s.summary = "Send messages like mails"
  s.description = "Send messages like mails"
  s.files = Dir["lib/**/*", "MIT-LICENSE"]
  s.require_path = 'lib'
  s.requirements << 'none'

  s.add_dependency('actionpack',  '3.1.3')
  s.version = "0.0.1"
end
