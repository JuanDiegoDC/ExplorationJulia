### Strang Matrix Problem

function StrangMatrix(n)
    if n <= 0
        println("n must be a positive integer.")
        return
    end
    m = zeros(Int8, n, n)
    for i=1:n
        m[i,i] = -2
        if i != n
            m[i, i+1] = 1
            m[i+1, i] = 1
        end
    end
    println(m)
end

# Factorial Problem

function my_factorial(n)
    c = one(n)
    for i=1:n
        c *= i
    end
    println(c)
    println(typeof(c))
end

# Binomial Problem

function binomial_rv(n, p)
    s = 0
    v = rand(n)
    for i=1:n
        if v[i] <= p
            s += 1
        end
    end
    println(s)
end

# Monte Carlo Pi Estimate
using Distributions

function monte_carlo_pi(n)
    c = 0
    for i=1:n
        x, y = rand(Uniform(-1, 1)), rand(Uniform(-1, 1))
        if (x^2+y^2) <= 1
            c+=1
        end
    end
    area = c/n
    return(4 * area)
end

function repeat_mc_pi(num_trials, n)
    v = Array{Float64}(undef, num_trials)
    for i=1:num_trials
        v[i]=monte_carlo_pi(n)
    end
    println(mean(v))
end

# TimeSeries Generation Problem

using Plots

function ar_1(x_0, T, αs)
    p = plot()
    for α in αs
        vals = Array{Float64}(undef, T+1)
        vals[1] = x_0
        for t=1:T
            ϵ = rand(Normal(0,1))
            vals[t+1] = α*vals[t] + ϵ
        end
        plot!(p, vals, label= "alpha = $α")
    end
    p
end

ar_1(0.0, 200, [0, 0.5, 0.9])

# Logistic Map Problem

function logistic_map(b_0, iters)
    ys = []
    rs = []
    for r=2.9:0.001:4.0
        b_old = b_0
        # transient
        for i=1:iters
            b_new = r * (b_old - b_old^2)
            b_old = b_new
        end
        b_xx = b_old
        for i=1:150
            b_new = r * (b_old - b_old^2)
            b_old = b_new
            push!(ys, b_old)
            push!(rs, r)
            if (abs(b_new - b_xx) < 0.001)
                break
            end
        end
    end
    scatter(rs, ys, ms=1e-8, title="Logistic Eq. Bifurcation", xguide="r", yguide="x")
end


#logistic_map(0.25, 400)

# Naive broadcast multiplication:
function broadcast_mult(x, y)
    output = similar(x)
    for i in eachindex(x)
        output[i] = x[i] * y[i]
    end
    output
end

using LinearAlgebra
A = Tridiagonal(2:5, 1:5, 1:4)

## Project: Regression Plot
