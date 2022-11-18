const Pool = require('pg').Pool;

const pool = new Pool({
  connectionString: process.env.DATABASE_URL,
  ssl: {
    rejectUnauthorized: false
    }
});

// const pool = new Pool({
//   host: 'localhost',
//   user: 'felixdallaire',
//   password: '7122',
//   database: 'maiio'
// });

const landing = async (request, response) => {
  response.status(200).send('Welcome to Trainzy API !');
}

// const getAllWorkout = async (request, response) => {
//   pool.query('SELECT * FROM workouts ORDER BY rating ASC', (error, results) => {
//     response.status(200).json(results.rows);
//   });
// };

// const getHorrorById = (request, response) => {
//   const id = parseInt(request.params.id);
//   pool.query('SELECT * FROM horrors WHERE id = $1', [id], (error, results) => {
//     response.status(200).json(results.rows);
//   });
// };

// const addHorror = async (request, response) => {
//   const { name, rating } = request.body;
//   console.log(name + rating)
//   pool.query('INSERT INTO horrors (name, rating) VALUES ($1, $2)', [name, rating], (error, results) => {
//     response.status(201).send(`Horror added successfully.` + name + rating);
//   });
// };

// const updateHorror = (request, response) => {
//   const id = parseInt(request.params.id);
//   const { name, rating } = request.body;
//   pool.query(
//     'UPDATE horrors SET name = $1, rating = $2 WHERE id = $3', [name, rating, id], (error, results) => {
//       response.status(200).send(`Horror with id ${id} modified.`);
//     }
//   );
// };

// const deleteHorror = (request, response) => {
//   const id = parseInt(request.params.id);
//   pool.query('DELETE FROM horrors WHERE id = $1', [id], (error, results) => {
//     response.status(200).send(`Horror with id ${id} deleted.`);
//   });
// };


// TO RETURN HTML
// app.get('/', function(request, response){
//     response.sendFile('absolutePathToYour/htmlPage.html');
// });

// module.exports = {
//   getAllHorrors,
//   getHorrorById,
//   addHorror,
//   updateHorror,
//   deleteHorror
// };

module.exports = {
  pool,
  landing
}
