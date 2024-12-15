module FileUtils
  def self.valid_image?(file)
    return false unless file.respond_to?(:content_type)
    
    valid_types = ['image/jpeg', 'image/png', 'image/gif']
    valid_types.include?(file.content_type)
  end

  def self.valid_document?(file)
    return false unless file.respond_to?(:content_type)
    
    valid_types = ['application/pdf', 'application/msword', 
                  'application/vnd.openxmlformats-officedocument.wordprocessingml.document']
    valid_types.include?(file.content_type)
  end

  def self.file_size_within_limit?(file, max_size_mb)
    return false unless file.respond_to?(:size)
    
    max_size_bytes = max_size_mb * 1024 * 1024
    file.size <= max_size_bytes
  end

  def self.generate_unique_filename(original_filename)
    extension = File.extname(original_filename)
    basename = File.basename(original_filename, extension)
    timestamp = Time.current.strftime('%Y%m%d%H%M%S')
    "#{basename}_#{timestamp}#{extension}"
  end
end