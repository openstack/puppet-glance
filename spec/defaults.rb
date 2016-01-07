# This file contains a module to return a default set of facts and supported
# operating systems for the tests in this module.
module OSDefaults
    def self.get_facts(extra_facts={})
      { :os_service_default => '<SERVICE DEFAULT>' }.merge(extra_facts)
    end

    def self.get_supported_os
      [
        {
          "operatingsystem" => "CentOS",
          "operatingsystemrelease" =>  [
            "6.0",
            "7.0"
          ]
        },
        {
          "operatingsystem" => "RedHat",
          "operatingsystemrelease" =>  [
            "6.0",
            "7.0"
          ]
        },
        {
          "operatingsystem" =>  "Ubuntu",
          "operatingsystemrelease" =>  [
            "12.04",
            "14.04"
         ]
        },
        {
          "operatingsystem" =>  "Debian",
          "operatingsystemrelease" =>  [
            "7",
            "8"
         ]
        }
      ]
    end
end
