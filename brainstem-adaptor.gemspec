# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{brainstem-adaptor}
  s.version = "0.0.2"

  s.date = %q{2014-03-10}
  s.authors = ["Sergei Zinin (einzige)"]
  s.email = %q{szinin@gmail.com}
  s.homepage = %q{http://github.com/einzige/brainstem-adaptor}

  s.licenses = ["MIT"]

  s.files = `git ls-files`.split("\n")
  s.require_paths = ["lib"]
  s.extra_rdoc_files = ["README.md"]

  s.description = %q{Parses Brainstem responses, makes it convenient to organize access to your data.}
  s.summary = %q{Brainstem API wrapper}

  s.add_development_dependency 'rspec'
  s.add_runtime_dependency 'activesupport', ">= 3.0.0"
end


