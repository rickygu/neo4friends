class User 
  include Neo4j::ActiveNode
  property :number, type: Integer, constraint: :unique

  validates :number, numericality: { only_integer: true }
  
  has_many :both, :friends, model_class: :User, unique: true, type: :HAS_FRIENDS

end
