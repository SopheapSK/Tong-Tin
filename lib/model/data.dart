import 'dart:math';

//List<String> images = shuffleList;
//List<String> shuffleList =  shuffle(items);

List<String> images = [
  "assets/image_09.jpg",
  "assets/image_08.jpg",
  "assets/image_07.jpg",
  "assets/image_06.jpg",
  "assets/image_05.jpg",
  "assets/image_04.jpg",
  "assets/image_03.jpg",
  "assets/image_02.jpg",
  "assets/image_01.png",
];

List shuffle(List items) {
  var random = new Random();

  // Go through all elements.
  for (var i = items.length - 1; i > 0; i--) {

    // Pick a pseudorandom number according to the list length
    var n = random.nextInt(i + 1);

    var temp = items[i];
    items[i] = items[n];
    items[n] = temp;
  }

  return items;
}


List<String> title = [
  "Hounted Ground",
  "Fallen In Love",
  "The Dreaming Moon",
  "Jack the Persian and the Black Castel what if long text, how will it handle it???",
];
