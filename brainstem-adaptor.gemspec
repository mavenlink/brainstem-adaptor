# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{brainstem-adaptor}
  s.version = "0.0.4"

  s.date = %q{2014-03-10}
  s.authors = ["Mavenlink", "Sergei Zinin (einzige)"]
  s.email = ["opensource@mavenlink.com", "szinin@gmail.com"]
  s.homepage = %q{https://github.com/mavenlink/brainstem-adaptor}

  s.licenses = ["MIT"]

  s.files = `git ls-files`.split("\n")
  s.require_paths = ["lib"]
  s.extra_rdoc_files = ["README.md"]

  s.description = %q{Parses Brainstem responses, makes it convenient to organize access to your data.}
  s.summary = %q{Brainstem API Adaptor}

  s.add_development_dependency 'rspec'
  s.add_runtime_dependency 'activesupport', ">= 3.0.0"
end


