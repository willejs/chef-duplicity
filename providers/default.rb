require "find"
require "chef/mixin/command"

action :backup do
  base_command_options = [
    "--volsize #{new_resource.volsize}",
    "--archive-dir #{new_resource.archive_dir}",
    "--tempdir #{new_resource.temp_dir}"
  ]

  base_command_options << "--no-encryption" if new_resource.no_encryption
  base_command_options << "--no-compression" if new_resource.no_compression
  base_command_options << "--asynchronous-upload" if new_resource.asynchronous_upload

  base_command_options << "--include #{new_resource.includes.join(" ")}" if new_resource.includes && !new_resource.includes.empty?
  base_command_options << "--exclude #{new_resource.excludes.join(" ")}" if new_resource.excludes && !new_resource.excludes.empty?

  base_command_options << "--s3-multipart-chunk-size #{new_resource.s3_multipart_chunk_size}" if new_resource.s3_multipart_chunk_size
  base_command_options << "--s3-unencrypted-connection" if new_resource.s3_unencrypted_connection
  base_command_options << "--s3-use-multiprocessing" if new_resource.s3_use_multiprocessing

  run_duplicity("#{base_command_options.join(" ")} #{new_resource.source} #{new_resource.destination}", {
    "AWS_ACCESS_KEY_ID"     => new_resource.aws_access_key,
    "AWS_SECRET_ACCESS_KEY" => new_resource.aws_secret_access_key
  })
end

action :restore do
  base_command_options = [ "restore" ]

  base_command_options << "--no-encryption" if new_resource.no_encryption
  base_command_options << "--no-compression" if new_resource.no_compression

  base_command_options << "--file-to-restore #{new_resource.file_to_restore}" if new_resource.file_to_restore

  run_duplicity("#{base_command_options.join(" ")} #{new_resource.source} #{new_resource.destination}", {
    "AWS_ACCESS_KEY_ID"     => new_resource.aws_access_key,
    "AWS_SECRET_ACCESS_KEY" => new_resource.aws_secret_access_key
  })
end

action :verify do
  base_command_options = [ "verify" ]
  
  base_command_options << "--file-to-restore #{new_resource.file_to_restore}" if new_resource.file_to_restore

  run_duplicity("#{new_resource.base_command_options.join(" ")} #{new_resource.source} #{new_resource.destination}", {
    "AWS_ACCESS_KEY_ID"     => new_resource.aws_access_key,
    "AWS_SECRET_ACCESS_KEY" => new_resource.aws_secret_access_key
  })
end

private

def run_duplicity(sub_command, env)
  Chef::Mixin::Command.run_command(
    :command      => "#{::File.join(node["duplicity"]["dir"], "bin", "duplicity")} #{sub_command}",
    :environment  => { "PYTHONPATH" => "#{::Find.find(node["duplicity"]["dir"]).grep(/site-packages/).first}/" }.merge(env),
    :returns      => 0
  )
end
