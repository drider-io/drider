class Device < ActiveRecord::Base
  belongs_to :user
  enum push_type: {
      GCM: 'GCM',
      APN: 'APN',
    }


end
