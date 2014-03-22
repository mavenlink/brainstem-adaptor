# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{brainstem-adaptor}
  s.version = "0.0.1"

  s.date = %q{2014-03-10}
  s.authors = ["Sergei Zinin (einzige)"]
  s.email = %q{szinin@gmail.com}
  s.homepage = %q{http://github.com/einzige/brainstem-adaptor}

  s.licenses = ["MIT"]

  s.files = `git ls-files`.split("\n")
  s.require_paths = ["lib"]
  s.extra_rdoc_files = ["README.md"]

  s.description = %q{Simple Ruby adator for Branstem}
  s.summary = %q{Plays with Brainstem}

  s.add_development_dependency 'rspec'
end


