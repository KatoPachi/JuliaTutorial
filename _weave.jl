
using Weave
pwd()

# weaving: from jmd to output
weave("markdown/ch1.jmd", out_path = "report/ch1.html")

# tangle: from jmd to jl
tangle("markdown/ch1.jmd", out_path = "script/ch1.jl")