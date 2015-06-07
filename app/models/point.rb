class Point
  include Mongoid::Document
  include Mongoid::Timestamps

  field :coordinates, :type => Array
  field :accuracy, type: Float
  field :time, type: DateTime

end