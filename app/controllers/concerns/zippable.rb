require 'zip'

module Zippable
  extend ActiveSupport::Concern
  
  def zip_attachments(name, records, proc, &block)
    path = File.join(Rails.public_path, "system", "archives")
    FileUtils.mkdir_p(path)
    path = File.join(path, "#{name}.zip")

    if !File.exists?(path) || File.mtime(path) < (records.maximum(:updated_at) || Time.new(0))
      FileUtils.rm(path) if File.exists?(path)

      Zip::File.open(path, Zip::File::CREATE) do |zip|
        i = 0
        records.each do |record|
          attachment = proc.call(record)
          zip.add(block.call(record, attachment, i), attachment.path)
          i = i.next
        end
      end

      FileUtils.chmod("a+r", path)
    end

    headers['Content-Length'] = File.size(path).to_s
    send_file path
  end
end