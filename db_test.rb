require 'rubygems'
require 'sqlite3'

$db = SQLite3::Database.new('dbfile')
$db.results_as_hash = true

def disconnect_and_quit
  $db.close
  puts 'Do widzenia!'
  exit
end

def create_table
  puts 'Tworzenie tabeli people'
  $db.execute %q{
    CREATE TABLE people (
      id integer primary key,
      name varchar(50),
      job varchar(50),
      gender varchar(6),
      age integer
    )
  }
end

def add_person
  puts 'Podaj imię i nazwisko:'
  name = gets.chomp
  puts 'Podaj zawód:'
  job = gets.chomp
  puts 'Podaj płeć:'
  gender = gets.chomp
  puts 'Podaj wiek:'
  age = gets.chomp
  $db.execute("INSERT INTO people (name, job, gender, age) VALUES (?, ?, ? , ?)", name, job, gender, age)
end

def find_person
  puts 'Podaj imię i nazwisko albo identyfikator poszukiwanej osoby:'
  id = gets.chomp

  person = $db.execute("SELECT * FROM people WHERE name = ? OR id = ?", id, id.to_i).first

  unless person
    puts 'Nie znaleziono osoby'
    return
  end

  puts %Q{Imię i nazwisko: #{person['name']}
          Zawód: #{person['job']}
          Płeć: #{person['gender']}
          Wiek: #{person['age']}}
end

loop do
  puts %q{Wybierz jedną z opcji

    1. Utworzenie tabeli people
    2. Dodanie nowej osoby
    3. Odszukanie osoby
    4. Wyjście
  }

  case gets.chomp
    when '1'
      create_table
    when '2'
      add_person
    when '3'
      find_person
    when '4'
      disconnect_and_quit
  end
end
