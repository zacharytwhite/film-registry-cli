require 'yaml'

class Movie

  DATABASE_PATH = File.expand_path('movies.yml', __dir__)

  class << self

    def all
      @all ||= []
    end

    def find(name)
      all.detect {|movie| movie.name == name }
    end

    def by_rating
      movies = all.group_by(&:rating).sort.reverse.to_h
      movies.values.each{|x| x.sort_by!(&:name) }
      movies
    end

    def save
      File.write(DATABASE_PATH, all.to_yaml)
      all
    end

    def load
      @all ||= YAML.load_file(DATABASE_PATH)
      all
    end

  end

  load

  attr_accessor :name, :rating

  def initialize(name, rating)
    @name = name
    @rating = rating
    self.class.all << self
  end

end
