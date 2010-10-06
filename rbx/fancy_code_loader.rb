require "set"

module Fancy
  class CodeLoader
    @@load_path = []
    @@compiled = {}
    @@loaded = {}
    @@current_dir = []

    def self.load_error(filename)
      raise "LoadError: Can't find file: #{filename}"
    end

    def self.find_file(filename)
      unless File.exists? filename
        if File.exists?(filename + ".fy")
          return filename + ".fy"
        end
      else
        return filename
      end
      return nil
    end

    def self.find_file_in_path(file, path)
      return find_file(path + "/" + file)
    end

    def self.filename_for(filename)
      if f = find_file(filename)
        return f
      else
        if f = find_file_in_path(filename, @@current_dir.last)
          return f
        end
        @@load_path.each do |p|
          begin
            if f = find_file_in_path(filename, p)
              return f
            end
          rescue
          end
        end
      end
      load_error filename
    end

    def self.compiled_filename_for(filename)
      if filename =~ /.fyc$/
        return filename
      end
      if filename =~ /\.fy$/
        return filename + "c"
      else
        return (filename + ".compiled.rbc")
      end
    end

    # optionally compile file, if not done yet
    def self.optionally_compile_file(f)
      filename = filename_for(f)
      compiled_file = compiled_filename_for(filename)

      unless @@compiled[filename]
        unless File.exists? compiled_file
          system("bin/fancy -c #{filename} > /dev/null")
        else
          @@compiled[filename] = true
        end
      end
      return compiled_file
    end

    def self.compile_file!(f)
      filename = filename_for(f)
      compiled_file = compiled_filename_for(filename)

      unless @@compiled[filename]
        system("bin/fancy -c #{filename} > /dev/null")
        @@compiled[filename] = true
      end
      return compiled_file
    end


    def self.load_compiled_file(filename, find_file = true)
      file = filename
      if find_file
        file = compiled_filename_for(filename_for(filename))
      end

      unless @@loaded[file]
        unless File.exists? file
          load_error file
        end

        dirname = File.dirname(file)
        @@load_path << dirname unless @@load_path.include? dirname
        @@current_dir.push dirname
        @@loaded[file] = true

        cl = Rubinius::CodeLoader.new(file)
        cm = cl.load_compiled_file(file, 0)

        script = cm.create_script(false)
        script.file_path = file

        MAIN.__send__ :__script__

        @@current_dir.pop
      end
    end
  end
end