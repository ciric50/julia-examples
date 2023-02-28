#=
brute.jl

Date: February 18, 2023
Author: W. Maier

Project Euler problem 015.
https://projecteuler.net/problem=15

This project takes a brute force approach to solving the problem.
=#

mutable struct GridPoint
    # Coordinates of this grid point
    row::Int64
    col::Int64
    # Coordinates of previous grid point
    prev_row::Int64
    prev_col::Int64

    right_taken::Bool
    down_taken::Bool
end

function count_paths(N::Int64)
    # Create a Matrix of GridPoints
    grid = Matrix{GridPoint}(undef,N,N)
    for i = 1:N, j = 1:N
        if i == N
            if j == N
                grid[i,j] = GridPoint(i, j, 0, 0, true, true)
            else
                grid[i,j] = GridPoint(i, j, 0, 0, false, true)
            end
        elseif j == N
            grid[i,j] = GridPoint(i, j, 0, 0, true, false)
        else
            grid[i,j] = GridPoint(i, j, 0, 0, false, false)
        end
    end

    # Traverse the paths and count each one
    count = convert(BigInt,0)
    point = grid[1,1]
    done = false
    while !done
        #println("Top $(point)")
        # See if we're done
        if point.row == 1 && point.col == 1 && point.right_taken && point.down_taken
            done = true
            continue
        end

        # Are we at the end of the grid?
        if point.row == N && point.col == N
            #println("At end of grid")
            count += 1

            # Move up to either the previous available branch or [1,1]
            found_next = false
            while !found_next
                next_point = grid[point.prev_row, point.prev_col]
                point.right_taken = (point.col == N)
                point.down_taken = (point.row == N)
                if next_point.row == 1 && next_point.col == 1
                    found_next = true
                elseif !next_point.right_taken || !next_point.down_taken
                    found_next = true
                end
                point = next_point
            end
            #println("Continuing from $(point.row), $(point.col)")
            continue
        end

        # Move right or down to the next grid point
        if point.col != N && !point.right_taken
            point.right_taken = true
            next_point = grid[point.row, point.col+1]
            next_point.prev_row = point.row
            next_point.prev_col = point.col
            point = next_point
        elseif point.row != N && !point.down_taken
            point.down_taken = true
            next_point = grid[point.row+1, point.col]
            next_point.prev_row = point.row
            next_point.prev_col = point.col
            point = next_point
        else
            println("Error at $(point)")
            done = true
        end
        #println("Loop $(point.row), $(point.col)")
    end

    return count
end

#----------------------------------------------------------------------------
#=
Results:
    N=16 --> real = 0m27.940s
    N=17 --> real = 1m46.321s
    N=18 --> real = 6m53.511s
=#

if !isempty(ARGS)
    count = count_paths(parse(Int64, ARGS[1]))
    println("Count is $count")
else
    println("Usage: julia brute.jl grid_size")
end

