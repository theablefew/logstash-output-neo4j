Gem::Specification.new do |s|
<<<<<<< HEAD:logstash-output-neo4j.gemspec
  s.name = 'logstash-output-neo4j'
  s.version         = "0.0.1"
  s.licenses = ["Apache License (2.0)"]
  s.summary = "Neo4j output for graph databases"
  s.description = "This gem is a logstash plugin required to be installed on top of the Logstash core pipeline using $LS_HOME/bin/plugin install gemname. This gem is not a stand-alone program"
  s.authors = ["Iouri Kostine", "The Able Few"]
  s.email = "iouri@theablefew.com"
  s.homepage = "http://www.theablefew.com"
=======
  s.name = 'logstash-output-example'
  s.version         = "2.0.0"
  s.licenses = ["Apache License (2.0)"]
  s.summary = "This example output does nothing."
  s.description     = "This gem is a Logstash plugin required to be installed on top of the Logstash core pipeline using $LS_HOME/bin/logstash-plugin install gemname. This gem is not a stand-alone program"
  s.authors = ["Elastic"]
  s.email = "info@elastic.co"
  s.homepage = "http://www.elastic.co/guide/en/logstash/current/index.html"
>>>>>>> a3905f34d20e1c6df65d0c875b936ac10ebeda73:logstash-output-example.gemspec
  s.require_paths = ["lib"]

  # Files
  s.files = Dir['lib/**/*','spec/**/*','vendor/**/*','*.gemspec','*.md','CONTRIBUTORS','Gemfile','LICENSE','NOTICE.TXT']
   # Tests
  s.test_files = s.files.grep(%r{^(test|spec|features)/})

  # Special flag to let us know this is actually a logstash plugin
  s.metadata = { "logstash_plugin" => "true", "logstash_group" => "output" }

  # Gem dependencies
<<<<<<< HEAD:logstash-output-neo4j.gemspec
  s.add_runtime_dependency "logstash-core", "~> 1.5.4"
=======
  s.add_runtime_dependency "logstash-core", ">= 2.0.0", "< 3.0.0"
>>>>>>> a3905f34d20e1c6df65d0c875b936ac10ebeda73:logstash-output-example.gemspec
  s.add_runtime_dependency "logstash-codec-plain"
  s.add_runtime_dependency "neography"

  s.add_development_dependency "logstash-devutils"
end
