require "open-uri"


module Download

    def self.download_file(url, path)
        
        File.new(path, "w") unless File.exist?(path)

        # from: https://stackoverflow.com/a/33746205

        case io = URI.open(url)
        when StringIO then File.open(path, 'w') { |f| f.write(io.read) }
        when Tempfile then io.close; FileUtils.mv(io.path, path)
        end
    end

end