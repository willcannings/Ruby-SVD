Ruby SVD
========
Singular Value Decomposition for Ruby with no dependency on GSL or LAPACK.

About
-----
Ruby SVD provides an interface to the Numerical Recipies C implementation of an SVD matrix decomposer. It also includes an extension to the native Ruby Matrix class with a simple LSA
method (decomposes the matrix, transposes matrix V, diagonalises the S array into a matrix, then removes all but the two leading terms in S to compress the original matrix to two dimensions).

Sample Usage
------------
```ruby
require 'ruby-svd'

tdm = SVDMatrix.new(4, 2)
tdm.set_row(0, [1,0])
tdm.set_row(1, [1,0])
tdm.set_row(2, [0,1])
tdm.set_row(3, [0,1])

puts "== Term document matrix:"
p tdm

puts "\n== Decomposing matrix:"
lsa = LSA.new(tdm)
p lsa

puts "\n== Classifying new column vector: [1, 0.5, 0, 0.5]"
puts "Format is [column, similarity]"
ranks = lsa.classify_vector([1,0.5,0,0.5])
p ranks

sorted_ranks = ranks.sort_by(&:last).reverse
puts "\n== Vector most similar to column #{sorted_ranks.first[0]}"
p tdm.column(sorted_ranks.first[0])
```
