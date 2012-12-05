actions :backup, :restore, :verify

attribute :source,                    :kind_of => String,   :name_attribute => true, :required => true
attribute :destination,               :kind_of => String,   :required => true
attribute :archive_dir,               :kind_of => String,   :default => Chef::Config[:file_cache_path]
attribute :temp_dir,                  :kind_of => String,   :default => Chef::Config[:file_cache_path]
attribute :volsize,                   :kind_of => Integer,  :default => 25

attribute :file_to_restore,           :kind_of => String

attribute :includes,                  :kind_of => Array,    :default => [ ]
attribute :excludes,                  :kind_of => Array,    :default => [ ]

attribute :no_encryption,             :kind_of => [ TrueClass, FalseClass ],  :default => false
attribute :no_compression,            :kind_of => [ TrueClass, FalseClass ],  :default => false
attribute :asynchronous_upload,       :kind_of => [ TrueClass, FalseClass ],  :default => false

attribute :aws_access_key,            :kind_of => String
attribute :aws_secret_access_key,     :kind_of => String
attribute :s3_multipart_chunk_size,   :kind_of => Integer
attribute :s3_use_multiprocessing,    :kind_of => [ TrueClass, FalseClass ],  :default => false
attribute :s3_unencrypted_connection, :kind_of => [ TrueClass, FalseClass ],  :default => false

def initialize(*args)
  super
  @action = :backup
end
