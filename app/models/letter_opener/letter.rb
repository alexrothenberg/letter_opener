module LetterOpener
  class Letter
    attr_accessor :name, :updated_at, :style

    def initialize(attributes)
      @name = attributes[:name]
      @updated_at = attributes[:updated_at]
      @style = detect_style()
    end

    def self.all
      LetterOpener.on_file_system do
        letters = Dir.glob("#{LetterOpener.letters_location}/*").map do |folder|
          new :name => File.basename(folder), :updated_at => File.mtime(folder)
        end
        letters.sort_by(&:updated_at).reverse
      end
    end

    def self.find_by_name(name)
      new(:name => name)
    end

    def filepath(style = :plain)
      "#{LetterOpener.letters_location}/#{name}/#{style}.html"
    end

    def contents(style = :plain)
      LetterOpener.on_file_system do
        File.read(filepath(style))
      end
    end

    def detect_style()
      LetterOpener.on_file_system do
        return :rich if File.exist?(filepath(:rich))
        return :plain if File.exist?(filepath(:plain))
        return :unknown
      end
    end
  end
end
