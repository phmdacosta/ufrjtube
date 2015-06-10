require 'rubygems'
require 'carrierwave'
require 'sinatra'
require 'pathname'
require 'carrierwave/ffmpeg'
require 'tilt/erb'

set :public_folder, File.dirname(__FILE__) + './'

configure do
  config.serve_static_assets = true
end

#Player

get '/play/:arq' do
  @arq = params['arq']
  erb :player
end

get '/lista' do
  dir = './'
  @arqs = Dir.glob("./arquivos/*.mp4").map{|f| f.split('/').last}
  erb :lista
end

#Upload

class VideoUploader < CarrierWave::Uploader::Base
  include CarrierWave::FFmpeg

  storage :file

  @file_name
  @ext_name
  @vd_resolution
  @file_format

  def store_dir
    File.join(File.dirname(__FILE__), 'arquivos')
  end

  def cache_dir
    File.join(File.dirname(__FILE__), 'arquivos', 'tmp')
  end

  def extension_white_list
    %w(mp4 avi wmv rmvb)
  end

  def move_to_store
    true
  end

  def current_path
    File.join(store_dir, full_current_name)
  end

  def current_file_name name
    @ext_name = File.extname(name)
    @file_name = File.basename(name, @ext_name)
  end

  def full_current_name
    @file_name + @ext_name
  end

  def file_format
    @file_format
  end

  def option format, file, opts = {}
    opts[:resolution]    = file.resolution unless opts[:resolution]
    opts[:video_bitrate] = file.bitrate unless opts[:video_bitrate]
    opts[:video_bitrate_tolerance] = (opts[:video_bitrate].to_i / 10).to_i
    opts[:threads] = 2 unless opts[:threads]
    opts.merge!(codec(format))
  end

  def encode_file_name
    @file_name
  end

  def full_encode_name
    @vd_resolution + "_" + encode_file_name + @file_format
  end

  def encode format, opts = {}
    @file_format = ".#{format}"
    tmp_path = File.join File.dirname(current_path), @vd_resolution + "_" + encode_file_name + ".#{format}"
    file = movie current_path
    file.transcode tmp_path, option(format, file, opts), transcoder_options
  end

  def codec format
    case format
      when :mp4
        { video_codec: 'libx264',
          audio_codec: 'aac -strict -2' }
      when :webm
        { video_codec: 'libvpx',
          audio_codec: 'libvorbis' }
      when :ogv
        { video_codec: 'libtheora',
          audio_codec: 'libvorbis' }
      else
        {}
    end
  end

  def video_resolution resolution
    @vd_resolution = resolution
  end

  def get_vd_resolution
    @vd_resolution
  end
end

get '/subir' do
  erb :video_upload
end

post '/fileupload' do

  file = params['myfile']
  filename = file[:filename]
  filehash = file[:tempfile]
  filetype = file[:type]
  filesize = env['CONTENT_LENGTH']

  uploader = VideoUploader.new
  #Efetuando upload do arquivo
  uploader.store!(filehash)

  #Efetuano encoding do arquivo
  uploader.current_file_name(uploader.filename)
  uploader.video_resolution("720")
  uploader.encode(:mp4, {resolution: '720', video_bitrate: '192k'})

  #Deletando arquivo original, não é necessário que ele exista
  FileUtils.remove(File.join(uploader.store_dir, uploader.filename))

  #Efetuando transcoding para duas resoluções mais baixas
  uploader.current_file_name(uploader.full_encode_name)
  uploader.video_resolution("480")
  uploader.encode('mp4', {resolution: '480', video_bitrate: '192k'})
  uploader.current_file_name(uploader.full_encode_name)
  uploader.video_resolution("360")
  uploader.encode('mp4', {resolution: '360', video_bitrate: '192k'})

end
