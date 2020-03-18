class Student

  # Remember, you can access your database connection anywhere in this class
  #  with DB[:conn]
  attr_accessor :name, :grade
  attr_reader :id

  def initialize(name, grade, id=nil)
    @name = name
    @grade = grade
    @id = id
  end

  def self.create_table
    sql = <<-EOF
      CREATE TABLE IF NOT EXISTS students (
        id INTEGER PRIMARY KEY,
        name TEXT,
        grade INTEGER
      )
      EOF
    DB[:conn].execute(sql)
  end

  def self.drop_table
    sql = <<-EOF
    DROP TABLE students
    EOF
    DB[:conn].execute(sql)
  end

  def save
    sql = <<-EOF
      INSERT INTO students (name, grade)
      VALUES (?, ?)
      EOF
      DB[:conn].execute(sql, self.name, self.grade)
      @id = DB[:conn].execute("SELECT last_insert_rowid() FROM students")[0][0]
  end

  def self.create(name:, grade:)
    student = Student.new(name, grade)
    student.save
    student
  end
  
end
