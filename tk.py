import time
import math
import glob
import tiktoken


def benchmark_tokenization(file_path, iterations):
    times = []
    encoding = tiktoken.get_encoding("cl100k_base")

    # Read file content
    with open(file_path, 'r') as file:
        content = file.read()

    # Run tokenization multiple times and measure execution time
    for _ in range(iterations):
        start_time = time.time()
        tokens = len(encoding.encode(content))
        end_time = time.time()
        # print(tokens)
        times.append((end_time - start_time) * 1000)  # Convert to milliseconds

    # Calculate average and standard deviation
    average_time = sum(times) / len(times)
    variance = sum((t - average_time) ** 2 for t in times) / len(times)
    std_deviation = math.sqrt(variance)
    std_dev_percent = (std_deviation / average_time) * 100  # Deviation as a percentage of the average

    return file_path, average_time, std_dev_percent, tokens


# List of .txt files to benchmark
txt_files = sorted(glob.glob('*.txt'))
iterations = 2000  # Number of iterations per file
results = []

# Run benchmark for each file and store results
for file_path in txt_files:
    file_path, avg_time, std_dev, tokens = benchmark_tokenization(
        file_path, iterations)
    results.append((file_path, avg_time, std_dev, iterations, tokens))
    iterations //= 10


# Display summaries one after another at the end of the benchmark
for file_path, avg_time, std_dev, iterations, tokens in results:
    print(f'File: {file_path} ({iterations} - {tokens}) - Avg Time: {avg_time:.2f}ms, StdDev: {std_dev:.2f}%')
