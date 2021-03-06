require File.dirname(__FILE__) + '/lib/omniauth-expressov3/version'

Gem::Specification.new do |gem|
    gem.add_runtime_dependency 'omniauth', '~> 1.0'

    gem.add_development_dependency 'maruku', '~> 0.6'
    gem.add_development_dependency 'simplecov', '~> 0.4'
    gem.add_development_dependency 'rack-test', '~> 0.5'
    gem.add_development_dependency 'rake', '~> 0.8'
    gem.add_development_dependency 'rspec', '~> 2.7'

    gem.name = 'omniauth-expressov3'
    gem.version = OmniAuth::ExpressoV3::VERSION
    gem.description = %q{Internal authentication handlers for OmniAuth.}
    gem.summary = gem.description
    gem.email = ['abner.silva@gmail.com']
    gem.homepage = 'http://github.com/abner/omniauth-expressov3'
    gem.authors = ['Abner Oliveira']
    gem.executables = `git ls-files -- bin/*`.split("\n").map{|f| File.basename(f)}
    gem.files = `git ls-files`.split("\n")
    gem.test_files = `git ls-files -- {test,spec,features}/*`.split("\n")
    gem.require_paths = ['lib']
    gem.required_rubygems_version = Gem::Requirement.new('>= 1.3.6') if gem.respond_to? :required_rubygems_version=
end
