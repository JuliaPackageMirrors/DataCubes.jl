module TestNAArrayOperators

using FactCheck
using DataCubes
using DataCubes: AbstractArrayWrapper,FloatNAArray,wrap_array

facts("NAArrayOperators tests") do
  context("AbstractArrayWrapper tests") do
    @fact 1 .+ AbstractArrayWrapper(nalift([1,2,3])) --> AbstractArrayWrapper(nalift([2,3,4]))
    @fact AbstractArrayWrapper(nalift([1,2,3])) .- 1 --> AbstractArrayWrapper(nalift([0,1,2]))
    @fact AbstractArrayWrapper(nalift([1,2,3])) .*
            AbstractArrayWrapper(nalift([5.0,6.0,7.0])) --> AbstractArrayWrapper(nalift([5.0,12.0,21.0]))
    @fact map(x->Nullable(x.value*2), AbstractArrayWrapper(nalift([1,2,3]))) --> AbstractArrayWrapper(nalift([2,4,6]))
    @fact (x=AbstractArrayWrapper([5,1,3,2,4]);sort!(x);x) --> AbstractArrayWrapper([1,2,3,4,5])
    @fact sort(AbstractArrayWrapper([5 1 3 2 4]),2) --> AbstractArrayWrapper([1 2 3 4 5])
    @fact sort(AbstractArrayWrapper([5,1,3,2,4])) --> AbstractArrayWrapper([1,2,3,4,5])
    @fact map((x,y)->DataCubes.naop_plus(x,y), nalift([1,2,3,4,5]), @nalift([1,2,NA,4,5])) --> @nalift([2,4,NA,8,10])
    @fact @nalift([1,2,NA]) .> 1 --> @nalift([false, true, NA])
    @fact 1 .< @nalift([1,2,NA]) --> @nalift([false, true, NA])
    @fact @nalift([1,2,3,NA]) .< @nalift([NA,3,1,2]) --> @nalift([NA,true,false,NA])
    @fact @nalift([1.0,2.0,NA]) .- 1 --> @nalift([0.0,1.0,NA])
    @fact 1 .- @nalift([1.0,2.0,NA]) --> @nalift([0.0,-1.0,NA])
    @fact @nalift([1.0,2.0,NA]) .* @nalift([NA,2.0,3.0]) --> @nalift([NA,4.0,NA])
    @fact -@nalift([1.0,2.0,NA]) --> @nalift([-1.0,-2.0,NA])
    @fact ~@nalift([1,2,NA]) --> @nalift([~1,~2,NA])
    @fact AbstractArrayWrapper([1,2,3]) .> 1 --> AbstractArrayWrapper([false,true,true])
    @fact AbstractArrayWrapper([1,2,3]) .> 1.5 --> AbstractArrayWrapper([false,true,true])
    @fact 1 .< AbstractArrayWrapper([1,2,3]) --> AbstractArrayWrapper([false,true,true])
    @fact AbstractArrayWrapper([1,2,3]) .> Nullable(1) --> nalift([false,true,true])
    @fact AbstractArrayWrapper([1,2,3]) + 1.0 --> AbstractArrayWrapper([2.0,3.0,4.0])
    @fact AbstractArrayWrapper([1,2,3]) + Nullable(1.0) --> nalift([2.0,3.0,4.0])
    @fact Nullable(1) .< AbstractArrayWrapper([1,2,3]) --> nalift([false,true,true])
    @fact AbstractArrayWrapper([3.0,2.0,1.0]) .< AbstractArrayWrapper([1.0,2.0,3.0]) --> AbstractArrayWrapper([false,false,true])
    @fact AbstractArrayWrapper([3,2,1]) .< nalift([1,2,3]) --> nalift([false,false,true])
    @fact @nalift([3,NA,1]) .< AbstractArrayWrapper([1.0,2.0,3.0]) --> @nalift([false,NA,true])
    @fact nalift([3,2,1]) .< nalift([1.0,2.0,3.0]) --> nalift([false,false,true])
    @fact @nalift([NA,2,1]) + @nalift([1.0,NA,3.0]) --> @nalift([NA,NA,4.0])
    @fact nalift([3,2,1]) + AbstractArrayWrapper([1.0,2.0,3.0]) --> nalift([4.0,4.0,4.0])
    @fact AbstractArrayWrapper([3,2,1]) + AbstractArrayWrapper([1.0,2.0,3.0]) --> AbstractArrayWrapper([4.0,4.0,4.0])
    @fact AbstractArrayWrapper([3,2,1]) + 5.0 --> AbstractArrayWrapper([8.0,7.0,6.0])
    @fact AbstractArrayWrapper([3,2,1]) + Nullable(5.0) --> nalift([8.0,7.0,6.0])
    @fact -AbstractArrayWrapper([3,2,1]) --> AbstractArrayWrapper([-3,-2,-1])
    @fact -AbstractArrayWrapper([3.0,2.0,1.0]) --> AbstractArrayWrapper([-3.0,-2.0,-1.0])
    @fact -nalift([3.0,2.0,1.0]) --> nalift([-3.0,-2.0,-1.0])
    @fact -darr(a=[3.0,2.0,1.0]) --> darr(a=[-3.0,-2.0,-1.0])
    @fact -larr(a=[3.0,2.0,1.0], axis1=[:x,:y,:z]) --> larr(a=[-3.0,-2.0,-1.0], axis1=[:x,:y,:z])
    @fact nalift([1.0,2.0,3.0]) + nalift([1,2,3]) --> nalift([2.0,4.0,6.0])
    @fact nalift([1.0,2.0,3.0]) + nalift([1.0,2.0,3.0]) --> nalift([2.0,4.0,6.0])
    @fact AbstractArrayWrapper(map(Nullable, [1.0,2.0,3.0])) + nalift([1.0,2.0,3.0]) --> nalift([2.0,4.0,6.0])
    @fact AbstractArrayWrapper(map(Nullable, [1.0,2.0,3.0])) + @nalift([1.0,2.0,NA]) --> @nalift([2.0,4.0,NA])
    @fact @nalift([1.0,2.0,NA]) + AbstractArrayWrapper([Nullable(1.0),Nullable{Float64}(), Nullable(3.0)]) --> @nalift([2.0,NA,NA])
    @fact AbstractArrayWrapper(map(Nullable, [1.0,2.0,3.0])) + nalift([1,2,3]) --> nalift([2.0,4.0,6.0])
    @fact AbstractArrayWrapper([Nullable(1.0),Nullable(2.0),Nullable{Float64}()]) + AbstractArrayWrapper([1,2,3]) --> @nalift([2.0,4.0,NA])
    @fact AbstractArrayWrapper([Nullable(1), Nullable(2), Nullable{Int}()]) + AbstractArrayWrapper([1.0,2.0,3.0]) --> @nalift([2.0,4.0,NA])
    @fact AbstractArrayWrapper([1.0,2.0,3.0]) + AbstractArrayWrapper([Nullable(1), Nullable(2), Nullable{Int}()]) --> @nalift([2.0,4.0,NA])
    @fact AbstractArrayWrapper([1.0,2.0,3.0]) + AbstractArrayWrapper([1,2,3]) --> [2.0,4.0,6.0]
    @fact AbstractArrayWrapper([1,2,3]) ./ AbstractArrayWrapper([1,2,3]) --> [1.0,1.0,1.0]
    @fact (2+3im) * @nalift([1,2,NA]) --> @nalift([2+3im,4+6im,NA])
    @fact @nalift([1,2,NA]) * (2+3im)--> @nalift([2+3im,4+6im,NA])
    @fact Nullable(2+3im) * @nalift([1,2,NA]) --> @nalift([2+3im,4+6im,NA])
    @fact @nalift([1,2,NA]) * Nullable(2+3im)--> @nalift([2+3im,4+6im,NA])
    @fact Nullable(im) / @nalift([1,2,NA]) --> @nalift([im,0.5im,NA])
    @fact @nalift([1,2,NA]) / Nullable(im)--> @nalift([-im,-2im,NA])
    @fact Nullable(e) / @nalift([1,2,NA]) --> @nalift([convert(Float64,e),convert(Float64,e/2),NA])
    @fact @nalift([1,2,NA]) / Nullable(e)--> @nalift([convert(Float64,1/e),convert(Float64,2/e),NA])
    @fact e / @nalift([1,2,NA]) --> @nalift([convert(Float64,e),convert(Float64,e/2),NA])
    @fact @nalift([1,2,NA]) / e--> @nalift([convert(Float64,1/e),convert(Float64,2/e),NA])
    @fact nalift([1.0,2.0,3.0]) + 1.0 --> nalift([2.0,3.0,4.0])
    @fact 1.0 + nalift([1.0,2.0,3.0]) --> nalift([2.0,3.0,4.0])
    @fact nalift([1.0,2.0,3.0]) + 1 --> nalift([2.0,3.0,4.0])
    @fact 1 + nalift([1.0,2.0,3.0]) --> nalift([2.0,3.0,4.0])
    @fact 1.0 + nalift([1,2,3]) --> nalift([2.0,3.0,4.0])
    @fact nalift([1,2,3]) + 1.0 --> nalift([2.0,3.0,4.0])
    @fact nalift([1.0,2.0,3.0]) + Nullable(1.0) --> nalift([2.0,3.0,4.0])
    @fact Nullable(1.0) + nalift([1.0,2.0,3.0]) --> nalift([2.0,3.0,4.0])
    @fact nalift([1.0,2.0,3.0]) + Nullable(1) --> nalift([2.0,3.0,4.0])
    @fact Nullable(1) + nalift([1.0,2.0,3.0]) --> nalift([2.0,3.0,4.0])
    @fact Nullable(1.0) + nalift([1,2,3]) --> nalift([2.0,3.0,4.0])
    @fact nalift([1,2,3]) + Nullable(1.0) --> nalift([2.0,3.0,4.0])
    @fact nalift([1.0,2.0,3.0]) * 1.0 --> nalift([2.0,3.0,4.0]) - 1
    @fact 1.0 * nalift([1.0,2.0,3.0]) --> nalift([2.0,3.0,4.0]) - 1
    @fact nalift([1.0,2.0,3.0]) * 1 --> nalift([2.0,3.0,4.0]) - 1
    @fact 1 * nalift([1.0,2.0,3.0]) --> nalift([2.0,3.0,4.0]) - 1
    @fact 1.0 * nalift([1,2,3]) --> nalift([2.0,3.0,4.0]) - 1
    @fact nalift([1,2,3]) * 1.0 --> nalift([2.0,3.0,4.0]) - 1
    @fact nalift([1.0,2.0,3.0]) * Nullable(1.0) --> nalift([2.0,3.0,4.0]) - 1
    @fact Nullable(1.0) * nalift([1.0,2.0,3.0]) --> nalift([2.0,3.0,4.0]) - 1
    @fact @nalift([1.0,2.0,NA]) * Nullable(1) --> @nalift([2.0,3.0,NA]) - 1
    @fact Nullable(1) * nalift([1.0,2.0,3.0]) --> nalift([2.0,3.0,4.0]) - 1
    @fact Nullable(1.0) * @nalift([NA,2,3]) --> @nalift([NA,3.0,4.0]) - 1
    @fact nalift([1,2,3]) * Nullable(1.0) --> nalift([2.0,3.0,4.0]) - 1
    @fact nalift([1,2,3]) * Nullable{Int}() --> nalift([Nullable{Int}(), Nullable{Int}(), Nullable{Int}()])
    @fact @nalift([1,2,3,NA,NA,5]) ./ @nalift([2,1,2,3,NA,NA]) --> @nalift([0.5,2.0,1.5,NA,NA,NA])
    @fact @nalift([1,2,3,NA,NA,5]) ./ @nalift([2,1,2,3,NA,NA]) --> @nalift([0.5,2.0,1.5,NA,NA,NA])
    @fact @nalift([1,2,3,NA,NA,5]) ./ DataCubes.wrap_array([2,1,2,3,2,5]) --> @nalift([0.5,2.0,1.5,NA,NA,1.0])
    @fact DataCubes.wrap_array([1,2,3,4,5,6]) ./ @nalift([2,1,2,2,NA,NA]) --> @nalift([0.5,2.0,1.5,2.0,NA,NA])
    @fact @nalift([1,2,3,NA,NA,5]) ./ 2 --> @nalift([0.5,1.0,1.5,NA,NA,2.5])
    @fact @nalift([1,2,3,NA,NA,5]) ./ 2.0 --> @nalift([0.5,1.0,1.5,NA,NA,2.5])
    @fact @nalift([1,2,3,NA,NA,5]) / 2 --> @nalift([0.5,1.0,1.5,NA,NA,2.5])
    @fact @nalift([1,2,3,NA,NA,5]) / 2.0 --> @nalift([0.5,1.0,1.5,NA,NA,2.5])
    @fact 1/@nalift([1,2,NA]) --> @nalift([1.0,0.5,NA])
    @fact 1.0/@nalift([1,2,NA]) --> @nalift([1.0,0.5,NA])
    @fact 1 ./ @nalift([1,2,NA]) --> @nalift([1.0,0.5,NA])
    @fact 1.0 ./ @nalift([1,2,NA]) --> @nalift([1.0,0.5,NA])
    @fact e .^ @nalift([1,2,NA]) --> map(x->x.isnull ? Nullable{Float64}() : Nullable(e^x.value), @nalift([1,2,NA]))
    @fact e .^ DataCubes.wrap_array([1.0,2.0]) --> DataCubes.wrap_array(map(x->e^x, [1.0,2.0]))
    @fact e .^ DataCubes.wrap_array(Real[1.0,2]) --> DataCubes.wrap_array(map(x->e^x, Real[1.0,2]))
    @fact @nalift([1,3,NA]) == @nalift([1,NA,3]) --> false
    @fact @nalift([1,NA,3]) == @nalift([1,3,NA]) --> false
    @fact @nalift([1,NA,3]) == @nalift([1,NA,3]) --> true
    @fact @nalift([1,NA,3]) == @nalift([1,NA,2]) --> false
    @fact @nalift([1.0,3.0,NA]) == @nalift([1.0,NA,3.0]) --> false
    @fact @nalift([1.0,NA,3.0]) == @nalift([1.0,3.0,NA]) --> false
    @fact @nalift([1.0,NA,3.0]) == @nalift([1.0,NA,3.0]) --> true
    @fact @nalift([1.0,NA,3.0]) == @nalift([1.0,NA,2.0]) --> false
    @fact larr(a=[1,2,3]) + Nullable(1) --> larr(a=[2,3,4])
    @fact larr(a=1.0*[1,2,3]) + Nullable(1) --> larr(a=1.0*[2,3,4])
    @fact larr(a=1.0*[1,2,3]) + Nullable(1.0) --> larr(a=1.0*[2,3,4])
    @fact larr(a=1.0*[1,2,3]) .+ Nullable(1.0) --> larr(a=1.0*[2,3,4])
    @fact larr(a=1.0*[1,2,3]) .* Nullable(2.0) --> larr(a=2.0*[1,2,3])
    @fact larr(a=1.0*[1,2,3]) * Nullable(2.0) --> larr(a=2.0*[1,2,3])
    @fact Nullable(2.0) * larr(a=1.0*[1,2,3]) --> larr(a=2.0*[1,2,3])
    @fact Nullable(2) .* larr(a=1.0*[1,2,3]) --> larr(a=2.0*[1,2,3])
    @fact larr(a=[1,2,3]) + 1 --> larr(a=[2,3,4])
    @fact larr(a=1.0*[1,2,3]) + 1 --> larr(a=1.0*[2,3,4])
    @fact larr(a=1.0*[1,2,3]) * im --> larr(a=im*1.0*[1,2,3])
    @fact larr(a=1.0*[1,2,3]) / im --> larr(a=-im*1.0*[1,2,3])
    @fact larr(a=1.0*[1,2,3]) * Nullable(im) --> larr(a=1.0im*[1,2,3])
    @fact larr(a=1.0*[1,2,3]) / Nullable(im) --> larr(a=-1.0im*[1,2,3])
    @fact im * larr(a=1.0*[1,2,3]) --> larr(a=im*[1,2,3]*1.0)
    @fact im / larr(a=1.0*[1,2,3]) --> larr(a=im./(1.0*[1,2,3]))
    @fact Nullable(im) * larr(a=1.0*[1,2,3]) --> larr(a=im.*[1,2,3])
    @fact Nullable(im) / larr(a=1.0*[1,2,3]) --> larr(a=im./(1.0*[1,2,3]))
    @fact larr(a=1.0*[1,2,3]) + 1.0 --> larr(a=1.0*[2,3,4])
    @fact larr(a=1.0*[1,2,3]) .+ 1.0 --> larr(a=1.0*[2,3,4])
    @fact larr(a=1.0*[1,2,3]) .* 2.0 --> larr(a=2.0*[1,2,3])
    @fact larr(a=1.0*[1,2,3]) * 2.0 --> larr(a=2.0*[1,2,3])
    @fact 2.0 * larr(a=1.0*[1,2,3]) --> larr(a=2.0*[1,2,3])
    @fact 2 .* larr(a=1.0*[1,2,3]) --> larr(a=2.0*[1,2,3])
    @fact darr(a=[1,2,3]) + 1 --> darr(a=[2,3,4])
    @fact darr(a=1.0*[1,2,3]) + 1 --> darr(a=1.0*[2,3,4])
    @fact darr(a=1.0*[1,2,3]) + 1.0 --> darr(a=1.0*[2,3,4])
    @fact darr(a=1.0*[1,2,3]) .+ 1.0 --> darr(a=1.0*[2,3,4])
    @fact darr(a=1.0*[1,2,3]) .* 2.0 --> darr(a=2.0*[1,2,3])
    @fact darr(a=1.0*[1,2,3]) * 2.0 --> darr(a=2.0*[1,2,3])
    @fact 2.0 * darr(a=1.0*[1,2,3]) --> darr(a=2.0*[1,2,3])
    @fact 2 .* darr(a=1.0*[1,2,3]) --> darr(a=2.0*[1,2,3])
    @fact darr(a=[1,2,3]) / 1 --> darr(a=[1,2,3])
    @fact darr(a=1.0*[1,2,3]) / 2 --> darr(a=[1,2,3]/2.0)
    @fact darr(a=1.0*[1,2,3]) / 3.0 --> darr(a=[1,2,3]/3.0)
    @fact darr(a=1.0*[1,2,3]) ./ 3.0 --> darr(a=[1,2,3]/3.0)
    @fact darr(a=1.0*[1,2,3]) ./ 2.0 --> darr(a=[1,2,3]/2.0)
    @fact darr(a=1.0*[1,2,3]) / 2.0 --> darr(a=[1,2,3]/2.0)
    @fact darr(a=[1,2,3]) ./ darr(a=[3,2,1]) --> darr(a=[1,2,3]./[3,2,1])
    @fact 2.0 / darr(a=1.0*[1,2,3]) --> darr(a=2.0./[1,2,3])
    @fact 2.0 ./ darr(a=1.0*[1,2,3]) --> darr(a=2.0./[1,2,3])
    @fact darr(a=[1 2 3;4 5 6],b=1.0*[1 2 3;4 5 6])+darr(b=[1 2 3;4 5 6],a=[11 12 13;14 15 16]) --> larr(a=[12 14 16;18 20 22],b=2.0*[1 2 3;4 5 6])
    @fact darr(a=[1 2 3;4 5 6],b=1.0*[1 2 3;4 5 6])+larr(b=[1 2 3;4 5 6],a=[11 12 13;14 15 16],axis1=[:X,:Y]) --> larr(a=[12 14 16;18 20 22],b=2.0*[1 2 3;4 5 6],axis1=[:X,:Y])
    @fact darr(a=[1 2 3;4 5 6],b=1.0*[1 2 3;4 5 6])+larr(b=[1 2 3;4 5 6],a=[11 12 13;14 15 16],axis1=[:X,:Y]) --> larr(a=[12 14 16;18 20 22],b=2.0*[1 2 3;4 5 6],axis1=[:X,:Y])
    @fact larr(b=[1 2 3;4 5 6],a=[11 12 13;14 15 16],axis1=[:X,:Y]) + darr(a=[1 2 3;4 5 6],b=1.0*[1 2 3;4 5 6]) --> larr(b=2.0*[1 2 3;4 5 6],a=[12 14 16;18 20 22],axis1=[:X,:Y])
    @fact_throws larr(b=[1 2 3;4 5 6],a=[11 12 13;14 15 16],axis1=[:X,:Y]) + larr(a=[1 2 3;4 5 6],b=1.0*[1 2 3;4 5 6])
    @fact darr(a=[1.0 2.0]) * darr(a=[2.0,3.0]) --> darr(a=[8.0])
    @fact darr(a=[1.0 2.0;3.0 4.0]) / darr(a=[2.0 3.0]) --> darr(a=[1.0 2.0;3.0 4.0]/[2.0 3.0])
    @fact nalift([1.0 2.0]) * nalift([2.0,3.0]) --> nalift([8.0])
    @fact nalift([1.0 2.0;3.0 4.0]) / nalift([2.0 3.0]) --> nalift([1.0 2.0;3.0 4.0]/[2.0 3.0])
    @fact wrap_array(FloatNAArray([1.0 2.0]) * FloatNAArray([2.0,3.0])) --> wrap_array(FloatNAArray([8.0]))
    @fact wrap_array(FloatNAArray([1.0 2.0;3.0 4.0]) / FloatNAArray([2.0 3.0])) --> wrap_array(FloatNAArray([1.0 2.0;3.0 4.0]/[2.0 3.0]))
  end
end

end
