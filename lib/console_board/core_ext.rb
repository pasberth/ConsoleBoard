class Array

  alias defarray_original_at []
  alias defarray_original_initialize initialize

  def initialize *args, &blk
    return defarray_original_initialize(*args, &blk) unless args.empty?
    @default_handler = blk
  end

  def [] number
    defarray_original_at(number) || (@default_handler && @default_handler.call(self, number))
  end

end
