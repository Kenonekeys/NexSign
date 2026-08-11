#!/usr/bin/env ruby
require 'sinatra'
require 'json'
require 'fileutils'

post '/generate' do
  content_type :json
  payload = JSON.parse(request.body.read)
  bundle = payload['bundleId']
  common_name = payload['commonName'] || "NexSign"

  # Environment variables expected:
  # APP_STORE_CONNECT_ISSUER_ID, APP_STORE_CONNECT_KEY_ID, PRIVATE_KEY_BASE64
  issuer = ENV['APP_STORE_CONNECT_ISSUER_ID']
  key_id = ENV['APP_STORE_CONNECT_KEY_ID']
  key_b64 = ENV['PRIVATE_KEY_BASE64']

  unless issuer && key_id && key_b64
    status 400
    return { status: 'error', message: 'Missing App Store Connect API key environment variables' }.to_json
  end

  # Decode private p8
  FileUtils = FileUtils unless defined?(FileUtils)
  FileUtils.mkdir_p('/tmp/keys')
  p8path = "/tmp/keys/AuthKey_#{key_id}.p8"
  File.open(p8path, 'wb') do |f|
    f.write(Base64.decode64(key_b64))
  end

  # Generate a temporary fastlane api key JSON
  api_key_path = "/tmp/keys/api_key_#{key_id}.json"
  api_key = {
    'key_id' => key_id,
    'issuer_id' => issuer,
    'key' => File.read(p8path)
  }
  File.open(api_key_path, 'w') { |f| f.write(api_key.to_json) }

  # Run fastlane cert to generate a development certificate
  # This assumes fastlane is installed in the image
  cert_dir = "/tmp/certs/#{bundle}"
  FileUtils.mkdir_p(cert_dir)

  cmd = %Q(fastlane run create_cert api_key_path:\"#{api_key_path}\" app_identifier:\"#{bundle}\" output_path:\"#{cert_dir}\" development:true)

  puts "Running: #{cmd}"
  system(cmd)

  # Look for generated files
  files = Dir.glob("#{cert_dir}/*")
  if files.empty?
    status 500
    return { status: 'error', message: 'No certificate produced' }.to_json
  end

  # In a real deployment you'd upload to secure storage and return a signed URL
  # For this scaffold we return the path inside the container (NOT suitable for prod)
  download = files.sort_by { |f| File.mtime(f) }.last

  { status: 'ok', message: 'certificate generated', downloadUrl: download }.to_json
end
