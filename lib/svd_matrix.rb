require 'mathn'
require 'svd'

class SVDMatrix < Matrix
  public_class_method :new
  
  # Create a new SVD Matrix with m rows, n columns
  def initialize(m, n)
    @rows = Array.new(m)
    m.times {|i| @rows[i] = Array.new(n)}
  end
  
  # Set the value of the cell i, j
  def []=(i, j, val)
    @rows[i][j] = val
  end
  
  # Set the value of a row to an array
  def []=(i, row)
    @rows[i] = row
  end
  
  # Nicely formatted inspect string for the matrix
  def inspect
    @rows.collect {|row| "#{row.inspect}\n"}
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
    @rows.each {|row| input_array += row}
    u_array, w_array, v_array = SVD.decompose(input_array, row_size, column_size)
    
    # recompose U matrix
    u = SVDMatrix.new(row_size, column_size)
    row_size.times {|i| u[i] = u_array.slice!(0,column_size)}
    
    # recompose V matric
    v = SVDMatrix.new(column_size, column_size)
    column_size.times {|i| v[i] = v_array.slice!(0,column_size)}
    v = v.transpose
    
    # diagonalise W array as a matrix
    if reduce_dimensions_to
      (reduce_dimensions_to...w.size).each {|index| w[index] = 0.0}
    else
      w = Matrix.diagonal(*w_array)
    end
    
    u, w, v
  end
  
  # Reduce the number of dimensions of the data to dimensions.
  # Returns a back a recombined matrix (conceptually the original
  # matrix dimensionally reduced). For example Latent Semantic
  # Analysis uses 2 dimensions, and commonly tf-idf cell data.
  def reduce_dimensions(dimensions)
    u, w, v = self.decompose(dimensions)
    (u * w * v)
  end
end
