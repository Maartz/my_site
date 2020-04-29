---
title: Some Elixir katas
date: 2020-04-21 19:15:04
tags: functional, elixir
---

During this quarantine I've decided to get some katas. Usually I tend to go on [Exercism](http://exercism.io) to grab some exercises.

But I've choose [CodeWars](http://codewars.com) to get fresher and community-driven exercises.

The plot is the following, you've 8 levels, called `kyus`, from 8 kyu to 1 kyu. Eight being the lowest or easiest level and one the tougher, much more a project than a real exercise.

I've made some 8, 7 and 6 level kyus, and last night I go my very first 5 kyu exercise. During this day I've passed a second one, and for the sake of explanation and writing, I want to go through the solving of both 5 kyu exercises in a series, maybe more.

## Let's go

### 5kyu -- RGB to Hex Conversion

Here's the details

> The rgb function is incomplete. Complete it so that passing in RGB decimal values will result in a hexadecimal representation being returned. Valid decimal values for RGB are 0 - 255. Any values that fall out of that range must be rounded to the closest valid value. Note: Your answer should always be 6 characters long, the shorthand with 3 will not work here. The following are examples of expected output values:

So we expect this:

```elixir
Kata.rgb(255, 255, 255) # returns FFFFFF
Kata.rgb(255, 255, 300) # returns FFFFFF | It's false on purpose
Kata.rgb(0,0,0)         # returns 000000
Kata.rgb(148, 0, 211)   # returns 9400D3 | This is purple
```

So first thing first, we need to grab the value passed in the function and put them in a list

```elixir
def rgb(r,g,b) do
    [r,g,b]
end
```

In an `iex` session, we can check this out:

```shell
iex(1)> Kata.rgb(255,255,255)
[255, 255, 255]
```

Then, we should worry about this `Kata.rgb(255, 255, 300)` call. As I said before, it's false on purpose and we should take care of this. There's many ways to do so, like pattern matching, guard clauses etc. But I've decided to leverage the huge Elixir's standard library.

There's in fact two interesting functions in the `Kernel` module, `min` and `max`.

Let's map through each element of the list.

```elixir
def rgb(r,g,b) do
    [r,g,b]
    |> Enum.map(fn x -> x |> max(0) |> min(255) end)
end
```

Presto, we give constraints to our inputs.

```shell
iex(2)> RGB.rgb(255,255,300)
[255, 255, 255]
```

That's great, so

After this, we need to somehow transform our `255` to `FF`.
Elixir's `Integer` module gives us a very good function: `to_string`.

If I refer to this function documentation, here's what it can do:

```
@spec to_string(integer(), 2..36) :: String.t()

Returns a binary which corresponds to the text representation of integer in the given base.

base can be an integer between 2 and 36.

Inlined by the compiler.

## Examples

    iex> Integer.to_string(100, 16)
    "64"

    iex> Integer.to_string(-100, 16)
    "-64"

    iex> Integer.to_string(882_681_651, 36)
    "ELIXIR"
```

That's sweet because it totally fits our needs. We need a base `16` since it's hexadecimal.

Let's do this.

```elixir
def rgb(r,g,b) do
    [r,g,b]
    |> Enum.map(fn x -> x |> max(0) |> min(255) end)
    |> Enum.map(fn x -> Integer.to_string(x, 16) end)
end
```

And still in `iex`

```shell
iex(3)> Kata.rgb(255,255,300)
["FF", "FF", "FF"]
```

Recall the `Kata.rgb(0,0,0)` call in the katas detail?

```shell
iex(4)> Kata.rgb(0,0,0)
["0", "0", "0"] # 000
```

Ughh... not really what we expect though.

```shell
Kata.rgb(0,0,0) # We expect this output: 000000
```

So we need to find a way to add those missings zeros.
Once again, the Elixir standard library come in handy!

This time, it's the `String` module with the `pad_leading` function.

> Returns a new string padded with a leading filler which is made of elements from the padding.

Here's what we can read about it in the documentation.
Great, let's do this.

```elixir
def rgb(r,g,b) do
    [r,g,b]
    |> Enum.map(fn x -> x |> max(0) |> min(255) end)
    |> Enum.map(fn x -> Integer.to_string(x, 16) end)
    |> Enum.map(fn x -> String.pad_leading(x, 2, "0") end)
end
```

We want to pad our input with `0` to get a string with a length of two
Still in `iex`

```shell
iex(5)> Kata.rgb(255,255,300)
["FF", "FF", "FF"]
iex(6)> Kata.rgb(0,0,0)
["00", "00", "00"]
```

At this point, we've almost finished the kata. We just need to join our list to be a single string. The `Enum.join()` will do the job.
Here what the full code looks like:

```elixir
defmodule Kata do
    def rgb(r,g,b) do
        [r,g,b]
        |> Enum.map(fn x -> x |> max(0) |> min(255) end)
        |> Enum.map(fn x -> Integer.to_string(x, 16) end)
        |> Enum.map(fn x -> String.pad_leading(x, 2, "00") end)
        |> Enum.join()
    end
end
```

And in `iex` it runs this way.

```shell
iex(7)> RGB.rgb(0,0,0)
"000000"
iex(8)> RGB.rgb(255,255,300)
"FFFFFF"
```

So far so good, this 5 kyu kata is complete.
The pipe operator `|>` is very helpful in this scenario. Indeed, it let us think in function composition and also let the data flow through the functions. Each function gives us back a new list based on the passed one. We just need to pass a list and it give us back a list. Pretty neat!

In the next post, we will do `Josephus Permutation`.
