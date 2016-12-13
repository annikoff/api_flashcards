# frozen_string_literal: true
$LOAD_PATH.push File.expand_path('../lib', __FILE__)

# Maintain your gem's version:
require 'api_flashcards/version'

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = 'api_flashcards'
  s.version     = ApiFlashcards::VERSION
  s.authors     = ['annikoff']
  s.email       = ['annikoff@ya.ru']
  s.homepage    = 'https://github.com/annikoff/api_flashcards'
  s.summary     = 'An API gem for Flashcards application'
  s.description = 'An API gem for Flashcards application'
  s.license     = 'MIT'

  s.files = Dir['{app,config,lib}/**/*', 'MIT-LICENSE', 'Rakefile', 'README.md']

  s.add_dependency 'rails', '~> 5.0.0', '>= 5.0.0.1'
end
