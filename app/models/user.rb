class User 
  include Neo4j::ActiveNode
  property :number, type: Integer, constraint: :unique

  validates :number, numericality: { only_integer: true }
  
  has_many :both, :friends, model_class: :User, unique: true, type: :HAS_FRIENDS
  
  def make_friends(user)
    # since Neo4j does not support undirected relationships
    # We will sort user number to always make friends in the direction of smaller number user -> bigger number user
    # has_many unique constrain will stop friends being made twice
    
    users = [self, user].sort! {|a, b| a.number <=> b.number }
    users.first.friends << users.last
  end
  
  def make_friends!(user)
    # this will throw exception if friendship already exist
    users = [self, user].sort! {|a, b| a.number <=> b.number }
    if users.first.friends.include? users.last
      raise "Friendship already exist"
    else
      users.first.friends << users.last
    end
  end
  
  def self.first_or_create(number)
    # ActiveNode does not have this method like ActiveRecord
    user = User.find_by number: number
    user ? user : User.create!(number: number)
  end
  
  def self.import
    
    if User.count == 0
      path =  Rails.root.join('db', 'import_log.txt')
      File.write(path, "") #clear old log
      log = File.open(path, 'a')
      CSV.read(Rails.root.join('db', 'data.csv')).each do |row|
        
        begin
          user_a = User.first_or_create(row[0])
          user_b = User.first_or_create(row[1])
          user_a.make_friends!(user_b)
          log.puts "User #{row[0]} befriended User #{row[1]}"
        rescue => e
          log.puts "Error: #{e}, User #{row[0]}, User #{row[1]}"
        end
        
      end
  
    end
    
  end
end
