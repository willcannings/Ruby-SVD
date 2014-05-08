require 'mathn'
require 'svd'

class SVDMatrix < Matrix
  public_class_method :new
  
  # Create a new SVD Matrix with m rows, n columns
  def initialize(m, n)
    @rows = Array.new(m)
    @column_size = n
    m.times {|i| @rows[i] = Array.new(n)}
  end
  
  # Set the value of the cell i, j
  def []=(i, j, val)
    @rows[i][j] = val
  end
  
  # Set the value of a row to an array
  def set_row(i, row)
    @rows[i] = row
  end
  
  # Nicely formatted inspect string for the matrix
  def inspect
    @rows.collect {|row| row.inspect}.join("\n")
  end

  # Perform SVD and decompose the matrix into three matrices:
  # U, W, and V. You can choose to reduce the dimensionality of
  # the data by setting a number of diagonal cells to 0. For
  # example,  reduce_dimentions_to = 2 will set a 4x4 W
  # matrix into:
  # [NUM, 0, 0, 0]
  # [0, NUM, 0, 0]
  # [ 0, 0, 0, 0 ]
  # [ 0, 0, 0, 0 ]
  def decompose(reduce_dimensions_to = nil)
    input_array = []
    # @rows.each {|row| input_array += row}
    c_count = 0
    @rows.each do |row| 
      input_array += row
      c_count += 1
    end
    puts "input array"
    puts input_array.length
    puts "row size"
    puts row_size
    puts "column size"
    puts c_count
    u_array, w_array, v_array = SVD.decompose(input_array, row_size, c_count)
    
    # recompose U matrix
    u = SVDMatrix.new(row_size, reduce_dimensions_to || c_count)
    row_size.times {|i| u.set_row(i, u_array.slice!(0, c_count)[0...(reduce_dimensions_to || c_count)])}
    
    # recompose V matrix
    v = SVDMatrix.new(c_count, reduce_dimensions_to || c_count)
    c_count.times {|i| v.set_row(i, v_array.slice!(0, c_count)[0...(reduce_dimensions_to || c_count)])}
    
    # diagonalise W array as a matrix
    if reduce_dimensions_to
      w_array = w_array[0...reduce_dimensions_to]
    end
    w = Matrix.diagonal(*w_array)
    
    [u, w, v]
  end

  # Reduce the number of dimensions of the data to dimensions.
  # Returns a back a recombined matrix (conceptually the original
  # matrix dimensionally reduced). For example Latent Semantic
  # Analysis uses 2 dimensions, and commonly tf-idf cell data.
  # The recombined matrix, and the 3 decomposed matrices are
  # returned.
  def reduce_dimensions(dimensions = 2)
    u, w, v = self.decompose(dimensions)
    [(u * w * v.transpose), u, w, v]
  end
end
