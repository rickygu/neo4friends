class User 
  include Neo4j::ActiveNode
  property :number, type: Integer, constraint: :unique

  validates :number, numericality: { only_integer: true }
  
  has_many :both, :friends, model_class: :User, unique: true, type: :HAS_FRIENDS
  
  def make_friends(user)
    # since Neo4j does not support undirected relationships
    # We will sort user number to always make friends in the direction of smaller number user -> bigger number user
    users = [self, user].sort! {|a, b| a.number <=> b.number }
    users.first.friends << users.last
  end
end
