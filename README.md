Comparing OpenAI tokeniser (tiktoken) performance - stock Python/Rust vs JS/WASM. 

Running tests on M1 MacBook Pro

# Pyhton 3.11.6

## tiktoken 0.5.2

OpenAi implementation (using Rust behind the scenes)

```
File: 0_small.txt (2000 - 68) - Avg Time: 0.04ms, StdDev: 29.47%
File: 1_medium.txt (200 - 1068) - Avg Time: 0.54ms, StdDev: 3.07%
File: 2_large.txt (20 - 923942) - Avg Time: 359.49ms, StdDev: 0.85%
```

# JS, Node 21.2.0

```
npm install
npm start
```

Pure JS and Web Assembly versions

## tiktoken 1.0.11 (WASM)

```
File: 0_small.txt (2000 - 68) - Avg Time: 0.11ms, StdDev: 55.14%
File: 1_medium.txt (200 - 1068) - Avg Time: 0.78ms, StdDev: 6.84%
File: 2_large.txt (20 - 923942) - Avg Time: 451.92ms, StdDev: 0.75%
```

## js-tiktoken 1.0.8

```
File: 0_small.txt (2000 - 68) - Avg Time: 0.05ms, StdDev: 125.55%
File: 1_medium.txt (200 - 1068) - Avg Time: 0.96ms, StdDev: 29.51%
File: 2_large.txt (20 - 923942) - Avg Time: 1005.69ms, StdDev: 0.58%
```

## @dqbd/tiktoken 1.0.7 (WASM)

```
File: 0_small.txt (2000 - 68) - Avg Time: 0.18ms, StdDev: 48.96%
File: 1_medium.txt (200 - 1068) - Avg Time: 0.80ms, StdDev: 11.21%
File: 2_large.txt (20 - 923942) - Avg Time: 421.71ms, StdDev: 1.30%
```
