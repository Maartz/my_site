---
title: Some Elixir katas - Part II
date: 2020-04-30 11:29:53
tags: functional, elixi
---


In my previous post, I've talked about Josephus Permutation kata on [Codewars](http://codewars.com).

After taking a short break, it's time to tackle this exercise.

So what's the gist of this?

> This problem takes its name by arguably the most important event in the life of the ancient historian Josephus: according to his tale, he and his 40 soldiers were trapped in a cave by the Romans during a siege.

> Refusing to surrender to the enemy, they instead opted for mass suicide, with a twist: they formed a circle and proceeded to kill one man every three, until one last man was left (and that it was supposed to kill himself to end the act).

Not so funny for a kata though.

> Well, Josephus and another man were the last two and, as we now know every detail of the story, you may have correctly guessed that they didn't exactly follow through the original idea.

Oh great.

> You are now to create a function that returns a Josephus permutation, taking as parameters the initial array/list of items to be permuted as if they were in a circle and counted out every k places until none remained.

So here it starts.
Let's get the function definition.

> Tips and notes: it helps to start counting from 1 up to n, instead of the usual range 0..n-1; k will always be >=1.
For example, with n=7 and k=3 `josephus(7,3)` should act this way.

```shell
[1,2,3,4,5,6,7] - initial sequence
[1,2,4,5,6,7] => 3 is counted out and goes into the result [3]
[1,2,4,5,7] => 6 is counted out and goes into the result [3,6]
[1,4,5,7] => 2 is counted out and goes into the result [3,6,2]
[1,4,5] => 7 is counted out and goes into the result [3,6,2,7]
[1,4] => 5 is counted out and goes into the result [3,6,2,7,5]
[4] => 1 is counted out and goes into the result [3,6,2,7,5,1]
[] => 4 is counted out and goes into the result [3,6,2,7,5,1,4]
```

And so the final result is:

```shell
josephus([1,2,3,4,5,6,7],3)==[3,6,2,7,5,1,4]
```

Rather than going step by step like I did in the previous one. I'm going to write the full code and then commenting the reasons. Furthermore, we'll go through a solution which is much more idiomatic than mine... and very elegant.

```elixir
defmodule Josephus do
  def permutation(items, k) do
    doperm(items, k - 1, k, [])
  end

  defp doperm([], _i, _k, r), do: Enum.reverse(r) # Get the list back reversed

  defp doperm(items, i, k, r) do
    j = rem(i, length(items)) # Get the new index
    {p, items} = List.pop_at(items, j) # pop the item at the given index
    # Call the function with the new tail and populate the accumulator list with the popped num
    doperm(items, j + k - 1, k, [p | r])
  end
end
```

Here, we've 3 functions in the `Josephus` module, `permutation` and two `doperm`.

The `defp` is a keyword to declare a private function, like in a Ruby file under `private` keyword or in a Java class.

So `permutation` is somehow the public access to our module and it makes a call to `doperm` function, but which one?

Since `Elixir` supports multiclauses function like multiples languages, commonly called `overcharging`, we can leverage the pattern matching and, compared to the function argument, infer which one will be called.

So the last `doperm` function is getting called right now, because all the parameters are needed, and especially, the first one is not an empty list.
Check this out:

```elixir
defp doperm([], _i, _k, r) # first arg is empty list, _i _k are ignored and r is needed
defp doperm(items, i, k, r) # first is called items thus a list, and the rest is used too
```

Well, `Elixir` is a functional language, so we need to find a way to get a new list with our items popped out of the primary list, ***mutate*** it and get the index/key of where we are in this one.

That's a lot of work but recursion is here. So this is going to be smooth.

In fact, that's the responsibility of `doperm` function, until it gets an empty list.
How this works?

```elixir
defp doperm(items, i, k, r) do
  j = rem(i, length(items)) # Get the new index
  {p, items} = List.pop_at(items, j) # pop the item at the given index
  # Call the function with the new tail and populate the accumulator list with the popped num
  doperm(items, j + k - 1, k, [p | r])
end
```

This function waits for 4 arguments, a list, an index, a key and the rest.

NB : excuse my poor naming for variables but ... I've got no excuse 🤷‍♂️

So I declare a variable `j` which is equal to the remainder of the passed index divide by the length of the passed list. This will be where I'll pop the item from the list.

The `List.pop_at()` function returns a tuple if we refer to the doc, it looks like this:

```shell
iex> List.pop_at([1, 2, 3], 0)
{1, [2, 3]}
iex> List.pop_at([1, 2, 3], 5)
{nil, [1, 2, 3]}
```

So I can grab the poped out value, and the updated list. Great.

```elixir
{p, items} = List.pop_at(items, j)
# pop the item at the given index
# returns a new items list modified
```

Unfortunately, it's done. I mean, literally, the last line is just calling our `doperm` function with the arguments correctly placed.

Oh we can check this still !

```elixir
doperm(items, j + k - 1, k, [p | r])
```

Here, I pass the freshly created items list, based on the return value of the `List.pop_at` function. Then, I add `j` which was the index where I popped the value at, to `k` which is the key, or maybe should have been call it the step, minus 1 because in real life we start counting from 1. Then I still pass the `k` or step, and then I update `r` or rest with my `p`. With the help of the `cons` operator `|`.

Et voila.

And to be efficient, we need to know how Elixir works under the hood, especially with lists.

When manipulating a list, is easier to add the value at the beginning and reverse it rather than go through each element and place the item popped to the end. Elixir let us do this easily with this piece of syntax `[p|r]`, where `p` is the `head` and `r` is the `tail`.

```shell
iex> a = [1,2,3,4,5,6,7]
[1,2,3,4,5,6,7]
iex> b = [-2,-1,0 | a]
[-2,-1,0,1,2,3,4,5,6,7]
```

I've already talked of this feature of Elixir [in a previous post](https://www.maartz.tech/posts/2020-04-16-ex-js.html).

Still, we got a list but, reversed... That's the job of `doperm`. Hooray.

## What ??

Yes.

First `doperm` function clause was:

```elixir
defp doperm([], _i, _k, r)
```

We wait for an empty list as the first argument. We do not care of the index and the key OR step and we expect the rest. And when we get `r` we just pass it through the `Enum.reverse` function to ... reverse it.

So we've constructed our list idiomatically without losing performance and we go through it once to reverse it. So far so good. Our mission is over.

This was a tricky exercise for a newcomer like me in the Elixir world, in the functional programming paradigm, but it was challenging and that's what we love, don't we ?

And for the more elegant and idiomatic code, see:

```elixir
defmodule Josephus do
  def permutation(items, k) do
    Stream.unfold({items, length(items) - 1}, fn
      {[], _} ->
        nil
      
      {it, index} ->
        index = rem(k + index, length(it))
        {val, it_prime} = List.pop_at(it, index)
        
        {val, {it_prime, index - 1}}
        
    end)
    |> Enum.to_list()
  end
end
```

This is a beautiful piece of Elixir code.
Which for performance sake use the lazy version of `Enum.unfold`, `Stream.unfold`.
Streams are very powerful to manipulate undetermined potentially gigantic computation. 

They probably worth a post.
