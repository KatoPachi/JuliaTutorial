
using Weave
pwd()

# from script to jmd file 
convert_doc("script/ch1.jl", "markdown/ch1.jmd")

# weaving
weave("markdown/ch1.jmd", out_path = "report/ch1.html")