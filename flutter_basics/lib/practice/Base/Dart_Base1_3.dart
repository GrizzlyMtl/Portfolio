void main() {
  Map<String, String> film = {
    'The Godfather': '18+',
    'Titanic': '13+',
    'Inception': '13+',
    'The Lion King': 'All Ages',
    'Avengers: Endgame': '13+',
    'Joker': '16+',
    'Frozen': 'All Ages',
    'The Dark Knight': '13+',
    'Toy Story': 'All Ages',
    'Parasite': '16+',
  };
  for (var movie in film.entries) {
    if (movie.value == 'All Ages') {
      print({movie.key: 'Rated G'});
    } else if (movie.value == '13+')
      print({movie.key: 'Rated PG-13'});
    else if (movie.value == '16+')
      print({movie.key: 'Rated R'});
    else if (movie.value == '18+')
      print({movie.key: 'Rated MA'});
  }

  List<int> months = [1, 4, 5, 7, 8, 10, 11];
  for (int month in months) {
    switch (month) {
      case 1:
        int days = 31;
        print('January has $days days');
        break;
      case 2:
        int days = 28;
        print('February has $days days');
        break;
      case 3:
        int days = 31;
        print('March has $days days');
        break;
      case 4:
        int days = 30;
        print('April has $days days');
        break;
      case 5:
        int days = 31;
        print('May has $days days');
        break;
      case 6:
        int days = 30;
        print('June has $days days');
        break;
      case 7:
        int days = 31;
        print('July has $days days');
        break;
      case 8:
        int days = 31;
        print('August has $days days');
        break;
      case 9:
        int days = 30;
        print('September has $days days');
        break;
      case 10:
        int days = 31;
        print('October has $days days');
        break;
      case 11:
        int days = 30;
        print('November has $days days');
        break;
      case 12:
        int days = 31;
        print('December has $days days');
        break;
      default:
        print('Invalid month');
    }
  }
}
