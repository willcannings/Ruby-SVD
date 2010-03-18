require 'svd_matrix'

class LSA
  attr_accessor :u, :s, :v

  def initialize(matrix)
    @u, @s, @v = matrix.decompose(2)
  end
  
  # Return a distance (cosine similarity) between a new vector,
  # and all the clusters (columns) used in the original matrix.
  # Returns a sorted list of indexes and distances,
  def classify_vector(values)
    raise "Unsupported vector length" unless values.size == @u.row_size
    vector = Matrix.row_vector(values)
    position = vector * @u * @s.inverse
    puts position
    x = position[0,0]
    y = position[0,1]
    results = []
    
    @v.row_size.times do |index|
      results << [index, cosine_similarity(x, y, @v[index, 0], @v[index, 1])]
    end
    
    results.sort {|a, b| b[1] <=> a[1]}
  end
  
  # Determines the cosine similarity between two 2D points
  def cosine_similarity(x1, y1, x2, y2)
    dp = (x1 * x2) + (y1 * y2)
    mag1 = Math.sqrt((x1 ** 2) + (y1 ** 2))
    mag2 = Math.sqrt((x2 ** 2) + (y2 ** 2))
    return 0 if mag1 == 0 || mag2 == 0
    return (dp / (mag1 * mag2))
  end
end
