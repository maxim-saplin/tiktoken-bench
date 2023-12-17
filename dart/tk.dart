import 'dart:io';
import 'dart:math';
import 'package:tiktoken/tiktoken.dart';
import 'package:path/path.dart' as path;

Future<void> main() async {
  // List of .txt files to benchmark
  final txtFiles = Directory('../')
      .listSync()
      .where(
          (entity) => entity is File && path.extension(entity.path) == '.txt')
      .map((entity) => entity.path)
      .toList();

  int iterations = 2000; // Number of iterations per file
  final results = [];

  // Run benchmark for each file and store results
  for (final filePath in txtFiles) {
    final result = await benchmarkTokenization(filePath, iterations);
    results.add(result);
    iterations ~/=
        10; // Integer division to reduce iterations for the next file
  }

  // Display summaries one after another at the end of the benchmark
  for (final result in results) {
    final filePath = result[0];
    final avgTime = result[1];
    final stdDev = result[2];
    final tokens = result[3];
    print(
        'File: $filePath (${iterations} - $tokens) - Avg Time: ${avgTime.toStringAsFixed(2)}ms, StdDev: ${stdDev.toStringAsFixed(2)}%');
  }
}

Future<List<dynamic>> benchmarkTokenization(
    String filePath, int iterations) async {
  final times = <double>[];
  final encoding = getEncoding("cl100k_base");

  // Read file content
  final content = await File(filePath).readAsString();

  // Run tokenization multiple times and measure execution time
  for (int i = 0; i < iterations; i++) {
    final startTime = DateTime.now().millisecondsSinceEpoch.toDouble();
    final tokens = encoding.encode(content);
    final endTime = DateTime.now().millisecondsSinceEpoch.toDouble();
    times.add(endTime - startTime);
  }

  // Calculate average and standard deviation
  final averageTime = times.reduce((a, b) => a + b) / times.length;
  final variance =
      times.map((t) => pow(t - averageTime, 2)).reduce((a, b) => a + b) /
          times.length;
  final stdDeviation = sqrt(variance);
  final stdDevPercent = (stdDeviation / averageTime) *
      100; // Deviation as a percentage of the average

  return [filePath, averageTime, stdDevPercent, times.length];
}
