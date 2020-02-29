class Dog 
  
  attr_accessor :name, :breed
  attr_reader :id 
  
  def initialize(id: nil, name:, breed:)
    @id = id
    @name = name 
    @breed = breed 
  end 
  
  def self.create_table
    sql = <<-SQL
      CREATE TABLE IF NOT EXISTS dogs (
        id INTEGER PRIMARY KEY,
        name TEXT,
        breed TEXT
      )
    SQL
    
    DB[:conn].execute(sql)
  end 
  
  def self.drop_table
    DB[:conn].execute("DROP TABLE IF EXISTS dogs;")
  end 
  
  def save 
    if self.id 
      self.update
    else 
      sql = <<-SQL
        INSERT INTO dogs (name, breed)
        VALUES (?, ?)
      SQL
    end 
    
    DB[:conn].execute(sql, name, breed)
    @id = DB[:conn].execute("SELECT last_insert_rowid() FROM dogs")[0][0]
    self 
  end 
  
  def self.create(hash)
    new_dog = self.new(hash)
    new_dog.save 
    new_dog 
  end 
  
  def self.new_from_db(row)
    id = row[0]
    name = row[1]
    breed = row[2]
    new_dog = self.new(id: id, name: name, breed: breed)
    new_dog
  end 
  
  def self.find_by_id(id_num)
    sql = <<-SQL
      SELECT * 
      FROM dogs
      WHERE id = ?
    SQL
    
    DB[:conn].execute(sql, id_num).map do |row|
      self.new_from_db(row)
    end.first 
  end 
  
  def self.find_or_create_by(name:, breed:)
    dog = DB[:conn].execute("SELECT * FROM dogs WHERE name = ? AND breed = ?;", name, breed)
    
  end 
  
end 