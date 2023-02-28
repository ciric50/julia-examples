#=
problem-015.jl

Date: February 18, 2023
Author: W. Maier

Project Euler problem 015.
https://projecteuler.net/problem=15

This is an improved algorithm for solving the problem.
=#

function grid_counts(N::Int64)
    grid = ones(Int64, N, N)
    for i ∈ N-1:-1:1, j ∈ N-1:-1:1
        grid[i,j] = grid[i+1,j] + grid[i,j+1]
    end
    return grid[1,1]
end

#----------------------------------------------------------------------------

if !isempty(ARGS)
    count = grid_counts(parse(Int64, ARGS[1]))
    println("Count is $count")
else
    println("Usage: julia problem-015.jl grid_size")
end

