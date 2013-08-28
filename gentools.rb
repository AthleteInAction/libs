require 'rubygems'
require 'json'



def valid_json? json_  
  begin  
    JSON.parse(json_)  
    return true  
  rescue Exception => e  
    return false  
  end  
end
def JP val
  
  if val.instance_of?(Array) || val.instance_of?(Hash) || valid_json?(val)
    
    puts JSON.pretty_generate val
    
  else
    
    puts val
    
  end
  
end
class String
  def is_number?
    true if Float(self) rescue false
  end
end


# End Time
#-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:
def ET time

  diff = ((Time.now.to_f-time)*1000).round.to_f/1000

end
#-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:


# Get File Contents
#-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:
def GetFile path

  if File.exists? path

    file = File.open(path)
    contents = file.read
    file.close

  else

    contents = false

  end

  contents

end
#-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:


# Make Directory
#-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:
def MakeDir path,output = false
  
  if !File.exists?(path)
    
    if Dir::mkdir(path,0777)

      puts %{#{File.expand_path(path)} was created!} if output

    end
    
  end

end
#-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:



# Write File
#-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:
def Write path,data

  File.open(path,'w') do |f|

    f.puts data

  end
  
  true

end
#-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:



# NON Word
#-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:
def NW val,replacement = '_'
  
  val = val.to_s.downcase.gsub(/\W/,replacement)
  
  val
  
end
#-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:



# Up
#-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:
def Up params = {}
  
  query = ''
  
  i = 0
  params.each do |key,val|
    
    query += '?' if i == 0
    query += '&' if i > 0
    query += key.to_s+'='+val.to_s
    i += 1
    
  end
  
  query
  
end
#-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:

module Tools
  
  def self.insert q = {}

    table = q[:table]
    q.delete(:table)

    es = Mysql2::Client.new

    fields = []
    values = []

    q.each do |key,val|

      val = es.escape(val) if val.is_a? String
      fields << key
      val = 'true' if val.to_s == 'true'
      val = 'false' if val.to_s == 'false'
      if val
        values << %{'#{val}'}
      else
        values << %{NULL}
      end

    end

    es.close

    "INSERT INTO #{table} (#{fields.join(',')}) VALUES (#{values.join(',')})"

  end
  
  def self.update q = {}

    table = q[:table]
    q.delete(:table)
    
    conditions = q[:conditions]
    q.delete(:conditions)
    
    es = Mysql2::Client.new

    sets = []
    q.each do |key,val|
      val = es.escape(val) if val.is_a? String
      sets << "#{key} = '#{val}'"
    end
    
    cons = []
    conditions.each do |key,val|
      val = es.escape(val) if val.is_a? String
      cons << "#{key} = '#{val}'"
    end
    
    es.close
    
    "UPDATE #{table} SET #{sets.join(',')} WHERE #{cons.join(',')}"

  end
  
end