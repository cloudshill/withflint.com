namespace withflint.com.backend

module Memoization =
    open System.Collections.Generic
    // This modified text is an extract of the original Stack Overflow Documentation (https://archive.org/details/documentation-dump.7z) created by following contributors (https://sodocumentation.net/contributor?topicId=2698) and released under CC BY-SA 3.0(https://creativecommons.org/licenses/by-sa/3.0/)
    let memoization f =
        // The dictionary is used to store values for every parameter that has been seen
        let cache = Dictionary<_, _>()

        fun c ->
            let exist, value = cache.TryGetValue(c)

            match exist with
            | true ->
                // Return the cached result directly, no method call
                printfn "%O -> In cache" c
                value
            | _ ->
                // Function call is required first followed by caching the result for next call with the same parameters
                printfn "%O -> Not in cache, calling function..." c
                let value = f c
                cache.Add(c, value)
                value
