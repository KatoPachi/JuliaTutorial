# Chapter 1

#import Pkg
#Pkg.add("Plots")
#Pkg.add("Optim")
#Pkg.add("StatsKit")
#Pkg.add("GLM")
#Pkg.add("DataFrames")

using Random
using Statistics
using Plots
using Optim
using StatsKit
using CSV
using GLM
using DataFrames

rng = MersenneTwister(123456789)

# 1.1
# 1.2
# 1.2.1
# 1.2.2
# 1.2.3

N = 100
a = fill(2, N)
b = 3
x = rand!(rng, zeros(N))
υ = randn!(rng, zeros(N))
y = a + x.*b + υ
ȳ = a + x.*b



# 1.2.4
mean(y[x .> 0.95]) - mean(y[x .< 0.05])
scatter(x, y)
scatter!(x, ȳ)

# 1.2.5
# 1.3
# 1.3.1
# 1.3.2

b̂ = (mean(y) .- 2)./mean(x)

# 1.3.3
# 1.3.4
x1 = x[1:5]
X1 = [ones(5) x1]
X1*[2; 3]
y[1:5]

# 1.3.5
# 1.3.6
X = [ones(N) x]

A = [1:3 4:6]
A'
A'A
X'X
inv(X'X)

# \beta\hat
β̂ = inv(X'X)X'y

inv(X'X)X'u

# 1.4
# 1.4.1
# 1.4.2
# 1.4.3

function ls(b)

   sum((y .- 2 - x.*b).^2)

end

optimize(ls, -10, 10).minimizer
(mean(x.*y) - mean(x).*2)./mean(x.*x)

# 1.4.4
lm(X, y)
inv(X'X)X'y
x_df = DataFrame(x = x, y = y)
lm1 = lm(@formula(y ~ x), x_df)

# 1.5
# 1.5.1

Random.seed!(123456789)

K = 1000
sim_res = Array{Union{Missing,Float64}}(missing, K, 2)
N = 100
a = fill(2, N)
b = 3

for k in 1:K
   x = rand(N)
   υ = randn(N)
   y = a + x.*b + υ
   x_df = DataFrame(x = x, y = y)
   lm1 = lm(@formula(y ~ x), x_df)
   sim_res[k,1:2] = coef(lm1)
   print(k)
end

mean(sim_res[1:end,1])
std(sim_res[1:end,1])
mean(sim_res[1:end,2])
std(sim_res[1:end,2])

# 1.5.2
# 1.5.3

Random.seed!(123456789)

K = 1000
bs_mat = Array{Union{Missing,Float64}}(missing, K, 2)
N = 100

for k in 1:K
    
    index_k = rand(1:N, N)
    x_df_k = x_df[index_k,1:end]
    lm1_k = lm(@formula(y ~ x), x_df_k)
    bs_mat[k,1:2] = coef(lm1_k)
    print(k)

end

tab_res = Array{Union{Missing,Float64,String}}(missing,3,5)
tab_res[1,2:end] = ["Mean" "SD" "2.5%" "97.5%"]
tab_res[2:3,1] = ["Est of a" "Est of b"]

for i in 1:2

    tab_res[i+1,2] = mean(bs_mat[1:end,i])
    tab_res[i+1,3] = std(bs_mat[1:end,i])
    tab_res[i+1,4:5] = quantile(bs_mat[1:end,i],[0.025,0.975])

end

tab_res

# 1.5.4
lm(@formula(y ~ x), x_df)

# 1.6
# 1.6.1
# 1.6.2

path = "ENTER PATH HERE"

x = CSV.read(string(path,"/nls.csv"))
lwage76_temp = Vector{Union{Missing, Float64}}(missing,length(x.lwage76))
wage76_temp = Vector{Union{Missing, Float64}}(missing,length(x.wage76))

for i in 1:length(lwage76_temp)

    if length(x.lwage76[i]) > 1

        lwage76_temp[i] = parse(Float64, x.lwage76[i])
        wage76_temp[i] = parse(Float64, x.wage76[i])

    end

end

x.lwage76 = lwage76_temp
x.wage76 = wage76_temp

x1 = DataFrame(x)
x1 = dropmissing(x1)

# 1.6.3
X1 = [ones(3010) x1.ed76]
y1 = x1.lwage76

scatter(x1.ed76, x1.lwage76)
scatter!(x1.ed76, X1*inv(X1'X1)X1'y1)

# 1.6.4
lm2 = lm(@formula(lwage76 ~ ed76), x1)
exp(log(mean(x1.wage76)) + coef(lm2)[2])/mean(x1.wage76)