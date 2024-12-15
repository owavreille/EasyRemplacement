
class BaseService
  def self.call(*args)
    new(*args).call
  end

  private

  def success(data = {})
    OpenStruct.new(success?: true, data: data, error: nil)
  end

  def failure(error)
    OpenStruct.new(success?: false, data: nil, error: error)
  end
end
