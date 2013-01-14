guard 'spork', rspec_env: { 'PADRINO_ENV' => 'test' } do
  watch('config/apps.rb')
  watch('config/boot.rb')
  watch('config/database.rb')
  watch('Gemfile')
  watch('Gemfile.lock')
  watch('spec/spec_helper.rb') { :rspec }
end
 
guard 'rspec', :version => 2, :cli => '--color' do
  watch(%r{^spec/.+_spec\.rb$})
  watch(%r{^app/(.+)\.rb$})                           { |m| "spec/app/#{m[1]}_spec.rb" }
  watch(%r{^models/(.+)\.rb$})                        { |m| "spec/models/#{m[1]}_spec.rb" }
  watch(%r{^lib/(.+)\.rb$})                        { |m| "spec/lib/#{m[1]}_spec.rb" }
  watch(%r{^spec/support/(.+)\.rb$})                  { "spec" }
  watch('spec/spec_helper.rb')                        { "spec" }
end
