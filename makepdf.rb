# encoding: UTF-8
 
require 'rubygems'
require 'rmagick'
require "prawn"

def makePDF(path)
  copy_path = "/Users/takeshita/Box Sync"

  Dir::glob('*') { |f|
    if File::ftype(f) == "directory"

      new_path = path + "/" + f
      Dir.chdir(new_path)
      puts "PDF作成中・・・　　" = Dir.pwd
      Prawn::Document.generate(copy_path + "/" + f + ".pdf") do
        Dir.glob(["*.jpg", "*.JPG", "*.png", "*.PNG"]).each do |name|
          unless File.directory?( name )

            image name, :at => [-1*bounds.absolute_left, bounds.absolute_top],
                        :fit => [bounds.absolute_right+bounds.absolute_left, bounds.absolute_top+bounds.absolute_bottom]
            start_new_page
          end
        end
      end

      puts "作成完了"
      Dir.chdir(path)
    end
  }
end

def traverse( path )
  Dir.glob(["#{path}/**/*.jpg", "#{path}/**/*.JPG", "#{path}/**/*.png", "#{path}/**/*.PNG"]).each do |name|
    unless File.directory?( name )
      process_file( name )
    end
  end
end

def process_file( fname )
  scale = 0.5	    # 元サイズを1.0として、変換後の画像サイズをパーセントで指定
  
  img = Magick::Image.read( fname ).first
  img.resize!( scale )
  img.write( "#{fname}" )
  puts fname + " 変換しました。"
end

traverse( Dir.pwd )
makePDF( Dir.pwd )
