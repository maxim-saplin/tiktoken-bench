// npm install
// npm start

import fs from 'fs';
import { glob } from 'glob';
import { performance } from 'perf_hooks';
import { get_encoding } from 'tiktoken';
//import { getEncoding } from 'js-tiktoken';
//import { get_encoding } from "@dqbd/tiktoken";

function benchmarkTokenization(file_path, iterations) {
  const times = [];
  //const encoding = getEncoding("cl100k_base");

  const encoding = get_encoding("cl100k_base");

  // Read file content
  const content = fs.readFileSync(file_path, 'utf8');

  let tokens = 0;

  // Run tokenization multiple times and measure execution time
  for (let i = 0; i < iterations; i++) {
    const start_time = performance.now();
    tokens = encoding.encode(content).length;
    const end_time = performance.now();
    // console.log(tokens);
    times.push(end_time - start_time); // Time in milliseconds
  }

  // Calculate average and standard deviation
  const average_time = times.reduce((a, b) => a + b, 0) / times.length;
  const variance = times.reduce((sum, time) => sum + Math.pow(time - average_time, 2), 0) / times.length;
  const std_deviation = Math.sqrt(variance);
  const std_dev_percent = (std_deviation / average_time) * 100; // Deviation as a percentage of the average

  return { file_path, average_time, std_dev_percent, tokens };
}

// List of .txt files to benchmark
const txt_files = glob.sync('*.txt').sort();
let iterations = 2000; // Number of iterations per file

// Run benchmark for each file and store results
txt_files.forEach(file_path => {
  const { average_time, std_dev_percent, tokens } = benchmarkTokenization(file_path, iterations);
  console.log(`File: ${file_path} (${iterations} - ${tokens}) - Avg Time: ${average_time.toFixed(2)}ms, StdDev: ${std_dev_percent.toFixed(2)}%`);
  iterations /= 10;
});