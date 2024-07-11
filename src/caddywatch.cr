require "inotify"

module Caddywatch
  VERSION = "0.1.0"

  @@current_sites = [] of String

  def self.update_config(event)
    Log.info { "Reloading: #{event}" }
    sites = [] of String
    Dir.glob("/srv/*").each do |path|
      next unless File.directory? path
      sites << Path[path].basename
    end
    sites.sort!
    if sites != @@current_sites
      File.open("/srv/sites", "w") do |outf|
        sites.each do |path|
          outf << %(
http://#{path}:8888 {
root * /srv/#{path}
file_server browse
}
        )
        end
      end
      Log.info { "Sites: #{sites}" }
      Process.run(command: "caddy", args: ["reload", "--config", " /srv/Caddyfile"])
      @@current_sites = sites
    end
  end

  def self.watch
    update_config("Initial config")
    Log.info { "Watching for changes..." }

    watcher = Inotify::Watcher.new

    watcher.watch("/srv", mask: LibInotify::IN_CREATE | LibInotify::IN_DELETE)
    watcher.on_event do |event|
      update_config(event)
    end

    sleep
  end
end

Caddywatch.watch
