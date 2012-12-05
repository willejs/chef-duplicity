maintainer        "Hector Castro"
maintainer_email  "hectcastro@gmail.com"
license           "Apache 2.0"
description       "Installs and configures duplicity."
version           "0.1.0"
recipe            "duplicity", "Installs and configures duplicity"

%w{ build-essential python yum }.each do |d|
  depends d
end

%w{ amazon centos }.each do |os|
  supports os
end
