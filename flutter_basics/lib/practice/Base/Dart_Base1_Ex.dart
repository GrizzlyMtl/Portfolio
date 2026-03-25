void main() {
  List<double> grades = [85.00, 92.00, 96.00, 90.00, 88.00];
  double avgGrade = grades.reduce((a, b) => a + b).round() / grades.length;
  double highestGrade = grades.reduce((a, b) => a > b ? a : b);
  double lowestGrade = grades.reduce((a, b) => a < b ? a : b);
  int counter1 = 0;
  for (double grade in grades) {
    if (grade >= 90) {
      counter1++;
    }
  }

  print('Average grade: $avgGrade');
  print('Highest grade: $highestGrade');
  print('Lowest grade: $lowestGrade');
  print('Number of grades >= 90: $counter1');

  Map<int, double> gradesMap = {};
  for (int i = 0; i < grades.length; i++) {
    gradesMap.addAll({i + 1: grades[i]});
  }
  print(gradesMap);

  List<String> grades2 = [];
  for (double i1 in grades) {
    if (i1 >= 90) {
      grades2.add('Excellent');
    } else if (i1 >= 80) {
      grades2.add('Good');
    } else if (i1 >= 70) {
      grades2.add('Average');
    } else if (i1 >= 60) {
      grades2.add('Below Average');
    } else {
      grades2.add('Fail');
    }
  }
  print(grades2);

  if (avgGrade == 100) {
    print('Perfect Mention');
  } else if (avgGrade >= 90) {
    print('Mention of Excellence');
  } else if (avgGrade >= 80) {
    print('Mention of Merit');
  } else if (avgGrade >= 70) {
    print('Mention of Credit');
  } else if (avgGrade >= 60) {
    print('Mention of Pass');
  } else {
    print('Fail');
  }
}
