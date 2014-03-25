require 'zip'

module Zippable
  extend ActiveSupport::Concern
  
  def zip(name, updated = nil, &block)
    path = File.join(Rails.public_path, "system", "archives")
    FileUtils.mkdir_p(path)
    path = File.join(path, "#{name}.zip")
    
    if !File.exists?(path) || (updated.present? && File.mtime(path) < updated)
      FileUtils.rm(path) if File.exists?(path)

      Zip::File.open(path, Zip::File::CREATE) do |zip|
        block.call(zip)
      end
      
      FileUtils.chmod("a+r", path)
    end
    
    headers['Content-Length'] = File.size(path).to_s
    send_file path
  end
  
  def zip_attachments(name, records, proc, &block)
    zip(name, records.maximum(:updated_at) || Time.new(0)) do |zip|
      i = 0
      records.each do |record|
        attachment = proc.call(record)
        zip.add(block.call(record, attachment, i), attachment.path)
        i = i.next
      end
    end 
  end
end