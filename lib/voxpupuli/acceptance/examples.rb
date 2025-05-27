# frozen_string_literal: true

shared_examples 'an idempotent resource' do |host|
  host ||= default

  it 'applies with no errors' do
    apply_manifest_on(host, manifest, catch_failures: true)
  end

  it 'applies a second time without changes' do
    apply_manifest_on(host, manifest, catch_changes: true)
  end
end

shared_examples 'an idempotent resource with debug' do |host|
  host ||= default

  it 'applies with no errors' do
    apply_manifest_on(host, manifest, catch_failures: true, debug: true)
  end

  it 'applies a second time without changes' do
    apply_manifest_on(host, manifest, catch_changes: true, debug: true)
  end
end

shared_examples 'the example' do |name, host|
  include_examples 'an idempotent resource', host do
    let(:manifest) do
      path = File.join(Dir.pwd, 'examples', name)
      raise Exception, "Example '#{path}' does not exist" unless File.exist?(path)

      File.read(path)
    end
  end
end
