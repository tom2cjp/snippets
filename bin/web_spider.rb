#! /usr/bin/env ruby
require 'uri'
require 'optparse'

puts "http://www.riaidea.com/html5/runner/"

options = {}
opts = OptionParser.new do |opts|
  opts.on_tail("-h", "--help", "get help for this CMD") { print(opts); exit() }
  opts.on("-u", "--url String", "url") { |v| p v; options[:url] = v }
  opts.on("-o", "--output String","output path") { |v| options[:o_path] = v }
end
opts.parse(ARGV.size == 0 ? ['-h'] : ARGV)

class WebSpider
  attr_accessor :url, :o_path

  def initialize( options )
    @url = options[:url]
    @o_path = options[:o_path] || ENV["PWD"]
  end

  def run
    r_cmd([ "cd #{prj_path}", "wget #{url}" ]) unless File.exists?(File.join(prj_path, 'index.html'))
    parse_all
    system "tree #{prj_path}"
  end

  def parse_all
    [ 'sounds', 'js', 'images' ].each do |media_path|
      parse(media_path)
    end
  end

  def parse( media_path )
    r_cmd([ "cd #{prj_path}", "mkdir #{media_path}" ])

    [ 'index.html', "js/*.js" ].each do |rel_path|
      cont(rel_path).scan(/\"#{media_path}\/(.+?)\"/) do |matches|
        matches.each do |m_file|
          r_cmd(["cd #{File.join(prj_path, media_path)}", "wget -nc #{[url, media_path, m_file].join('/')}"])
        end
      end
    end
  end

  private

    def prj_path
      @prj_path ||= begin
        path = File.join(o_path, URI.parse(url).request_uri.split('/').last.to_s)
        r_cmd(["mkdir -p #{path}"]) unless File.exists?(path)
        path
      end
    end

    def cont( rel_path )
      res = []
      Dir.glob(File.join(prj_path, rel_path)) do |f|
        res << File.read(f)
      end
      res.join("\n")
    end

    def r_cmd( c_arr )
      cmd = c_arr.join(' && ')

      p cmd
      `#{cmd}`
    end
end

WebSpider.new(options).run
