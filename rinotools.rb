module Rino
  
  require 'mysql2'
  
  module_function
  # Write File
  #-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:
  def Write path,data,output = false

    File.open(path,'w') do |f|

      f.puts data

    end

    true

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
  
  
  # MySQL INSERT
  #-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:
  def SQLIN q = {}

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
  #-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:
  
  
  # MySQL UPDATE
  #-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:
  def SQLUP q = {}

    table = q[:table]
    q.delete(:table)
    
    conditions = q[:conditions] if q[:conditions]
    q.delete(:conditions)
    
    es = Mysql2::Client.new

    sets = []
    q.each do |key,val|
      val = es.escape(val) if val.is_a? String
      sets << "#{key} = '#{val}'"
    end
    
    cons = []
    if conditions
      conditions.each do |key,val|
        val = es.escape(val) if val.is_a? String
        cons << "#{key} = '#{val}'"
      end
    end
    
    es.close
    
    final = "UPDATE #{table} SET #{sets.join(',')}"
    final << " WHERE #{cons.join(',')}" if conditions
    
    final

  end
  #-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:
  
end
# Special Output
#-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:
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
#-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-: