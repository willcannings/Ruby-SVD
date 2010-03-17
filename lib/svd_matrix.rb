require 'mathn'
require 'svd'

class SVDMatrix < Matrix
  public_class_method :new
  def initialize(m, n)
    @rows = Array.new(m)
    m.times {|i| @rows[i] = Array.new(n)}
  end
  
  def []=(i, j, val)
    @rows[i][j] = val
  end
  
  def []=(i, row)
    @rows[i] = row
  end
  
  def inspect
    @rows.collect {|row| "#{row.inspect}\n"}
  end
  
  def lsa
    input_array = []
    @rows.each {|row| input_array += row}
    u_array, w_array, v_array = SVD.decompose(input_array, row_size, column_size)
    
    u = SVDMatrix.new(row_size, column_size)
    row_size.times {|i| u[i] = u_array.slice!(0,column_size)}
    
    v = SVDMatrix.new(column_size, column_size)
    column_size.times {|i| v[i] = v_array.slice!(0,column_size)}
    v = v.transpose
    
    w_array = w_array[0...2] + Array.new(w_array.size - 2).collect {|i| 0}
    w = Matrix.diagonal(*w_array)
    
    r = (u * w * v)
  end
end

