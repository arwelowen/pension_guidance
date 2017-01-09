require_relative '../models/guide'
require_relative '../lib/front_matter_parser'

class GuideRepository
  GuideNotFound = Class.new(StandardError)

  attr_accessor :dir
  private :dir, :dir=

  def initialize(dir = Rails.root.join('content'))
    self.dir = dir
  end

  def find(id)
    dirname = id.tr('-', '_')
    path = glob_dir(dirname)&.first || raise(GuideNotFound)

    read_guide(id, path)
  end

  def find_all(*ids)
    ids.each_with_object([]) do |id, results|
      results << find(id)
    end
  end

  def all
    glob_dir('*').map do |path|
      id = path.match(%r{^#{dir}/(?<id>[^\.]*)\.(?<ext>.*)$})[:id]
      read_guide(id, path)
    end
  end

  private

  def read_guide(id, path)
    content_type = file_content_type(path)
    source = FrontMatterParser.new(File.read(path))

    Guide.new(id,
              content: source.content,
              content_type: content_type,
              metadata: source.front_matter)
  end

  def file_content_type(path)
    case File.extname(path)
    when '.md' then
      :govspeak
    when '.html' then
      :html
    end
  end

  def glob_dir(file_pattern)
    Dir["#{dir}/**/#{file_pattern}.{md,html}"]
  end
end
