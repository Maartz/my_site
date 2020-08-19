---
title: Some Elixir Katas - Part III
date: 2020-08-18 19:53:19
tags: functionnal, elixir
---

It's been a while since my last post.
I've started a new job last week as a software engineer on the server side 😎
That's not really the subject of this post by after 3 years doing Java and a bit of Ruby, I do TS/JS all day long, that's a big change.

Anyway, I still do not work for a company which use Elixir but I do not discourage and keep looking for 🙏 position as an Elixir developer 🙏

So let's get started for this 6kyu kata -- I hope I'll do a 5kyu next time.

The gist of this Kata is pretty simple, we've got a list of numbers, and we have to find which one appears an odd number of times.

```elixir
    FindOdd.find([20,1,-1,2,-2,3,3,5,5,1,2,4,20,4,-1,-2,5]) # 5
    FindOdd.find([1,1,2,-2,5,2,4,4,-1,-2,5]) # -1
    FindOdd.find([10]) # 10
```

That's pretty straight forward and when I've read it I knew I was going to use `Enum.reduce`, it's not the only way to achieve it obviously but that's what comes in my mind.

As usual I'll also share another solution at the end of this post.

```elixir
defmodule FindOdd do
    def find([]), do: []
    def find([x]), do: x
    def find(list), do: list
end
```

So I've choose to use function clauses over multiples private function being called by the `find` one.

With these 3 clauses all cases are covered.

I want to create a `Map` where the key is the number in the list and the value is the number of times we encounter it, like this `%{10: 1}`.

Hence the `Map` I want to use, the shape of my data will looks like this `{x, y}`, and because I do not really care of the number of times at the end, it's going to be much like this `{x, _}`.

```elixir
def find(list) do
    {x, _} = 
        list
        |> Enum.reduce(%{}, fn x, acc -> Map.update(acc, x, 1, &(&1 + 1))end)
        |> Enum.find(fn {_,y} -> rem(y, 2) == 1 end)
    x
end
```

Let's analyze this bit by bit.

I take the list and pass it to the `Enum.reduce/3` function.
The first argument is the list itself, the second is where I want to accumulate the data and the third is the lambda.

If `x` is present in map with value of `1`, `&(&1 + 1)` is invoked with argument `1` and its result is used as the new value of `x` in my `acc` which is a `Map`.

I could have decoupled it but for the sake of simplicity and because it's not really the topic of this post I'll keep it like this.

So once I've got my reduced `Map` I still need to find where it's odd, and as I said earlier, it's explicitly told that there's only one odd value.
I just need to find in my `Map` -- a map implements the protocol Enumerable so I can call `Enum` module functions on my `Map` -- with the help of `Enum.find`, which takes the `Enum` and a lambda.

Here I just pass `y` because it's the value I want to get the reminder of.
The `Kernel.rem/2` or just `rem` function gives us back the reminder of the division, also named the modulo, and I want to it to equal to 1 when `x` is divided by 2.

After this, I just need to return `x` et voila.

It was a really simple problem, and because it is simple there's a tons of way to solve it.

My favorite is this *almost* one liner function.

```elixir
defmodule FindOdd do
  import Bitwise
  def find(list), do: Enum.reduce(list, &Bitwise.bxor/2)
end
```

The usage of `bitwise` operators is a field where I do not really perform so well, I recall having used it for solving a problem on Codewars too in a JS kata.
It will maybe be part of a future blog post!

Thanks for reading and happy coding.