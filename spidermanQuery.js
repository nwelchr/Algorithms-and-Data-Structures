const https = require('https');

const getMovieTitles = async (substr) => {
  let baseUrl = "https://jsonmock.hackerrank.com/api/movies/search/?Title=";
  let url = `${baseUrl}${substr}`;

  let allMovies = [];

  let { totalPages, movies } = await fetchMovies(url);

  allMovies.push(...movies);

  counter = 2;
  let nextUrl;
  while (counter <= totalPages) {
    nextUrl = `${url}&page=${counter}`;
    const movies = await fetchMovies(nextUrl);
    allMovies.push(...movies);
    counter++;
  }

  return allMovies.map(movie => movie.Title);
};

const fetchMovies = (url) => {
  let payload = '';
  return new Promise(resolve => {
    https.get(url, (res) => {
      res.on('data', (chunk) => {
        payload += chunk;
      });
      res.on('end', () => {
        payload = JSON.parse(payload);
        payload.page > 1 ? resolve(payload.data) : resolve({ totalPages: payload.total_pages, movies: payload.data });
      });
    })
  });
};

getMovieTitles("spiderman").then((titles) => console.log(titles));