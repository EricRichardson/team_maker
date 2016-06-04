require 'sinatra'
require 'sinatra/reloader'

enable :sessions

get '/' do
  @teams = session[:teams]
  erb :index, layout: :layout
end

post '/' do
  names = params[:names].split(',')
  teamsize = params[:teamsize].to_i
  method = params[:method]
  @teams = teams_by_size(names, teamsize) if method == "by_size"
  @teams = teams_by_number(names, teamsize) if method == "by_teams"
  @teams ||= "No method selected"
  session[:teams] = @teams
  erb :index, layout: :layout
end

def teams_by_size(names, teamsize, extras = 0)
  return "Not enough people" if names.size < teamsize
  teams = ''
  team_number = 1
    while names.size > 0 do
      teams << "<div class=\"team\"><h2>Team #{team_number}</h2>"
      teamsize.times do
        if names.size > 0
          teams << names.delete_at(rand(names.size)) + "<br>"
        end
      end
      if extras > 0
        teams << names.delete_at(rand(names.size)) + "<br>"
        extras -=1
      end
      teams << "</div>"
      team_number += 1
    end
  teams
end

def teams_by_number(names, number_of_teams)
  return "You have to choose a number of teams ;(" if number_of_teams == 0
  teamsize = names.size / number_of_teams
  extras = names.size % number_of_teams
  return teams_by_size(names, teamsize, extras)
end
