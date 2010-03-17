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
    p input_array
    u_array, w_array, v_array = SVD.decompose(input_array, row_size, column_size)
    
    puts "\nU Array:"
    p u_array
    u = SVDMatrix.new(row_size, column_size)
    row_size.times {|i| u[i] = u_array.slice!(0,column_size)}
    puts "\nU Matrix:"
    puts u.inspect
    
    puts "\nV Array"
    p v_array
    v = SVDMatrix.new(column_size, column_size)
    column_size.times {|i| v[i] = v_array.slice!(0,column_size)}
    #v = v.transpose
    puts "\nV Matrix"
    v = v.transpose
    column_size.times {|i| puts "#{v.row(i).inspect}\n"}
    #puts v.inspect
    
    puts "\nW Matrix"
    w_array = w_array[0...2] + Array.new(w_array.size - 2).collect {|i| 0}
    w = Matrix.diagonal(*w_array)
    puts w.inspect
    
    puts "--------------------------------\n"
    r = (u * w * v)
    row_size.times {|i| puts "#{r.row(i).inspect}\n"}
  end
end

# m = SVDMatrix.new(6, 4)
# m[0] = [5,5,0,5]
# m[1] = [5,0,3,4]
# m[2] = [3,4,0,3]
# m[3] = [0,0,5,3]
# m[4] = [5,4,4,5]
# m[5] = [5,4,5,5]
# m.lsa

m = SVDMatrix.new(12, 9)
m[0] = [1,0,0,1,0,0,0,0,0]
m[1] = [1,0,1,0,0,0,0,0,0]
m[2] = [1,1,0,0,0,0,0,0,0]
m[3] = [0,1,1,0,1,0,0,0,0]
m[4] = [0,1,1,2,0,0,0,0,0]
m[5] = [0,1,0,0,1,0,0,0,0]
m[6] = [0,1,0,0,1,0,0,0,0]
m[7] = [0,0,1,1,0,0,0,0,0]
m[8] = [0,1,0,0,0,0,0,0,1]
m[9] = [0,0,0,0,0,1,1,1,0]
m[10] = [0,0,0,0,0,0,1,1,1]
m[11] = [0,0,0,0,0,0,0,1,1]
m.lsa

