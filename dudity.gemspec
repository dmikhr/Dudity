# frozen_string_literal: true

Gem::Specification.new do |s|
  s.name = 'dudity'
  s.version = '0.1.0'
  s.authors = ['Dmitry Khramtsov']
  s.email = ["dp@khramtsov.net"]
  s.summary = 'Analyze Rails code with stick dudes'
  s.description = 'Try DudeGL code visualization in your Rails projects'
  s.homepage = 'https://github.com/dmikhr/DudeGL/wiki'
  s.license = 'MIT'
  s.files = Dir['lib/**/*'].keep_if { |file| File.file?(file) }
end
