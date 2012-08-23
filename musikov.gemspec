lib = File.expand_path('../lib/', __FILE__)
$:.unshift lib unless $:.include?(lib)

Gem::Specification.new do |s|
  s.name = 'musikov'
  s.version = '0.15'
  s.has_rdoc = true
  s.date = Time.now.utc.strftime("%Y-%m-%d")
  s.extra_rdoc_files = ['README.md', 'LICENSE']
  s.summary = 'Musikov - Random song generator based on Markov Chains'
  s.description = s.summary
  s.author = 'Andre Fonseca'
  s.email = 'andre.amorimfonseca@gmail.com'
  s.executables = ['musikov']
  s.files = %w(LICENSE README.md) + Dir.glob("{bin,lib,spec}/**/*")
  s.require_path = "lib"
  s.bindir = "bin"

  s.add_runtime_dependency "midilib"
  s.add_runtime_dependency "thor"
  
end
