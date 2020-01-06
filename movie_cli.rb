require_relative './movie'

class String
  def titleize
    split.map(&:capitalize).join(' ')
  end
end

module MovieCLI
  class << self
    def menu
      puts
      puts 'What would you like to do?'
      puts '-- Type 1 to add a movie.'
      puts '-- Type 2 to update a rating.'
      puts "-- Type 3 to look up a movie's rating."
      puts '-- Type 4 to display all movies.'
      puts '-- Type 5 to delete a movie.'
      puts '-- Type 6 to see your rating statistics.'
      puts '-- Type 7 to exit.'
      choice = gets.chomp.to_i
      puts
      
      case choice
      when 1 then add_movie
      when 2 then update_rating
      when 3 then search_rating
      when 4 then display_all
      when 5 then delete_movie
      when 6 then rating_stats
      when 7 then leave
      else
        menu
      end
    end

    def add_movie
      puts "Title of film: "
      title = gets.chomp.titleize
      if movie = Movie.find(title)
        puts "You've already rated that one a #{movie.rating}."
        return
      end
      puts "Rating for \"#{title}:\" "
      rating = gets.chomp.to_i
      Movie.new(title, rating)
      Movie.save
      puts "Film added."
    end

    def update_rating
      puts "\nWhich movie's rating would you like to update?"
      title = gets.chomp.titleize
      if movie = Movie.find(title)
        puts "What would you like the new rating for \"#{title}\" to be?"
        movie.rating = gets.chomp.to_i
        Movie.save
      else
        puts 'Error--that movie cannot be found.'
      end
    end

    def search_rating
      puts "Which film's rating would you like to see?"
      title = gets.chomp.titleize
      if movie = Movie.find(title)
        puts "You rated #{movie.name} a #{movie.rating}"
      else
        puts 'Error--that movie cannot be found.'
      end
    end

    def display_all
      puts "Would you like the list to be sorted by rating, title, or date added?"
      puts '-- Type 1 to sort by rating.'
      puts '-- Type 2 to sort by title.'
      puts '-- Type 3 to sort by date added.'
      puts '-- Type 4 to return to main menu.'
      choice = gets.chomp.to_i
      puts

      case choice
      when 1 then display_all_by_rating
      when 2 then display_all_by_title
      when 3 then display_all_by_date_added
      when 4 then return
      else
        puts 'Error — choice not valid.'
        display_all
      end
    end

    def display_all_by_rating
      movie_count
      Movie.by_rating.each do |rating, movies|
        puts rating.to_s.center(20, '=')
        movies.map(&:name).each(&method(:puts))
        puts
      end
    end

    def display_all_by_title
      movie_count
      longest_name = Movie.all.map(&:name).map(&:length).max
      Movie.all.sort_by(&:name).each do |movie, rating|
        puts "#{movie.name.ljust(longest_name + 2)} #{movie.rating}" 
      end
    end
      

    def display_all_by_date_added
      movie_count
      longest_name = Movie.all.map(&:name).map(&:length).max
      Movie.all.each do |movie, rating|
        puts "#{movie.name.ljust(longest_name + 2)} #{movie.rating}" 
      end
    end

    def movie_count
      puts "You have rated a total of #{Movie.all.count} films.\n\n"
    end

    def delete_movie
      puts "Which film would you like to remove?"
      title = gets.chomp.titleize
      if movie = Movie.find(title)
        Movie.all.delete(movie)
        puts "Film deleted."
        Movie.save
      else
        puts 'Error — movie not found.'
      end
    end

    def rating_stats
      Movie.by_rating.each do |rating, movies|
        puts "You've given #{movies.count} films a #{rating}."
      end
    end

    def leave
      exit
    end
  end
end
