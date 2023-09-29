import 'package:flutter_heatmap_calendar/src/util/datasets_util.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('getMaxValue returns the maximum value from the dataset', () {
    final Map<DateTime, int> datasets = {
      DateTime(2023, 9, 1): 10,
      DateTime(2023, 9, 2): 20,
      DateTime(2023, 9, 3): 5,
      DateTime(2023, 9, 4): 15,
    };

    final result = DatasetsUtil.getMaxValue(datasets);

    expect(result, 20); // The maximum value in the dataset is 20
  });

  test('getMaxValue handles an empty dataset and returns 0', () {
    final Map<DateTime, int> emptyDataset = {};

    final result = DatasetsUtil.getMaxValue(emptyDataset);

    expect(result, 0); // The dataset is empty, so the result should be 0
  });

  test('getMaxValue handles a null dataset and returns 0', () {
    const Map<DateTime, int>? nullDataset = null;

    final result = DatasetsUtil.getMaxValue(nullDataset);

    expect(result, 0); // The dataset is null, so the result should be 0
  });
}
