require "open-uri"
require "fileutils"


module Download

    def self.download_file(url, path)

        if (not File.exist?(path))
            File.new(path, "w")
        end

        case io = URI.open(url)
        when StringIO then File.open(path, 'w') { |f| f.write(io.read) }
        when Tempfile then io.close; FileUtils.mv(io.path, path)
        end
    end

end