```ruby
class BasePresenter
  def initialize(object)
    @object = object
  end

  private

  attr_reader :object
end
```