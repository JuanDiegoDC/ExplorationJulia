module MyModule

## Implementation of Travelling Salesman Problem
## and Simulated Annealing Algorithm 

using Plots

mutable struct TSP
    num_cities::Int64
    route::Array{Int64}
    x::Vector{Float64}
    y::Vector{Float64}
    dist::Matrix{Float64}
end

function create_TSP(num_cities::Int64)
    if num_cities <= 0
        error("num_cities must be a positive integer.")
    end
    route = collect(1:num_cities)
    x = rand(num_cities)
    y = rand(num_cities)
    dist = ((x .- reshape(x, (1, num_cities))).^2 + (y .- reshape(y, (1, num_cities))).^2).^(0.5)
    prob = TSP(num_cities, route, x, y, dist)
    prob
end

function cost(prob::TSP)
    route = prob.route
    dist = prob.dist
    num_cities = prob.num_cities
    c = 0.0
    for i=1:num_cities
        city1 = route[i]
        if i != num_cities
            city2 = route[i + 1]
        else
            city2 = route[1]
        end
        c+=dist[city1, city2]
    end
    c
end

function propose_move(prob::TSP)
    num_cities = prob.num_cities
    i, j = 0, 0
    while true
        i, j = rand(1:num_cities), rand(1:num_cities)
        if i > j
            j, i = i, j
        end
        if abs(i - j) > 1 && !(i == 1 && j == num_cities)
            i, j
            break
        end
    end
    (i, j)
end

function compute_delta_cost(prob::TSP, i::Int64, j::Int64)
    num_cities = prob.num_cities
    route = prob.route
    dist = prob.dist

    cityi1 = route[i]
    cityi2 = route[i + 1]
    cityj1 = route[j]
    if j != num_cities
        cityj2 = route[j + 1]
    else
        cityj2 = route[1]
    end

    old_dist = dist[cityi1, cityi2] + dist[cityj1, cityj2]
    new_dist = dist[cityi1, cityj1] + dist[cityi2, cityj2]

    delta_cost = new_dist - old_dist
    delta_cost
end

function accept_move(prob::TSP, i::Int64, j::Int64)
    route = prob.route
    if i > j
        error("i must be smaller than j.")
    end
    route[i+1:j] = route[j:-1:i+1]
    prob.route = route
end

function disp_prob(prob::TSP)
    x = prob.x
    y = prob.y
    route = prob.route
    num_cities = prob.num_cities
    p = plot(title="Travelling Salesman Problem")
    scatter!(p, x, y, c=:red, label="cities")
    plot_route = copy(route)
    append!(plot_route, 1)
    plot!(p, x[plot_route], y[plot_route], c=:blue, label="path")
    # Interesting Julia Plots automatically "closes" the plot
    # plot!(p, x[[num_cities, 1]], y[[num_cities, 1]], c=:blue)
    p
end

function acceptance_rule(delta_cost, T)
    if delta_cost <= 0
        true
    elseif T == 0
        false
    end
    p = exp(-delta_cost/T)
    rand() < p
end

function SimAnn(prob::TSP,
                beta0::Float64,
                beta1::Float64,
                anneal_steps::Int64,
                mcmc_steps::Int64,
                display_every::Int64)

    c = cost(prob)
    println("Initial cost is: $c")

    best_c = c
    # best_prob = copy(prob)

    beta_arr = collect(range(beta0, beta1, length=(anneal_steps-1)))
    append!(beta_arr, Inf)

    for beta in beta_arr
        T = 1/beta
        println("Current temperature: $T")
        accepted = 0
        for step=1:mcmc_steps
            i, j = propose_move(prob)
            delta_cost = compute_delta_cost(prob, i, j)
            if acceptance_rule(delta_cost, T)
                accept_move(prob, i, j)
                accepted+=1
                c+=delta_cost
                if c < best_c
                    best_c = c
                    # best_prob = copy(prob)
                end
            end
            if step % display_every == 0
                display(disp_prob(prob))
                sleep(1)
            end
        end
        println("acceptance rate = $(accepted/mcmc_steps), current cost = $c, best cost = $best_c")
    end
    println("Final Cost = $c, Best Cost = $best_c")

end

prob = create_TSP(20)
beta0 = 2.0
beta1 = 100.0
anneal_steps = 10
mcmc_steps = 1000
display_every = 500
SimAnn(prob, beta0, beta1, anneal_steps, mcmc_steps, display_every)

end
