// Taken from stack overflow: https://stackoverflow.com/questions/26702757/check-if-the-given-string-follows-the-given-pattern

function isMatch(pattern, str) {
  let map = {}; //store the pairs of pattern and strings

  function checkMatch(pattern, str) {
    // if pattern and string are both empty
    if (pattern.length === 0 && str.length === 0) {
      return true;
    }
    // if the pattern or the string is empty
    if (pattern.length === 0 || str.length === 0) {
      return false;
    }

    // store the next pattern
    const currentPattern = pattern.charAt(0);

    if (currentPattern in map) {
      // the pattern has already been seen, check if there is a match with the string
      if (
        str.length >= map[currentPattern].length &&
        str.startsWith(map[currentPattern])
      ) {
        // there is a match, try all other posibilities
        return checkMatch(
          pattern.substring(1),
          str.substring(map[currentPattern].length)
        );
      } else {
        // no match, return false
        return false;
      }
    }

    // the current pattern is new, try all the posibilities of current string
    for (let i = 1; i <= str.length; i++) {
      const stringToCheck = str.substring(0, i);
      // store in the map
      map[currentPattern] = stringToCheck;
      // try the rest
      const match = checkMatch(pattern.substring(1), str.substring(i));
      if (match) {
        // there is a match
        return true;
      } else {
        // if there is no match, delete the pair from the map
        delete map[currentPattern];
      }
    }
    return false;
  }

  return checkMatch(pattern, str);
}

console.log(
  isMatch(
    'abcabaa',
    'redblueredblueredblueredredblueredredredredredjofpwejfdjfoewjishredblueredred'
  )
);
