const api = require('./api');
const { 
  v1: uuidv1,
  v4: uuidv4,
} = require('uuid');

const getAllExercises = async (request, response) => {
    api.pool.query('SELECT * FROM exercises ORDER BY name ASC', (error, results) => {
      if(error == null) {
        response.status(200).send(results.rows);
      } else {
        response.send(error);
      }
    });
  };
  
  const getExerciseById = (request, response) => {
    const id = request.params.id;
    api.pool.query('SELECT * FROM exercises WHERE id = $1', [id], (error, results) => {
      if(error == null) {
        response.status(200).send(results.rows);
      } else {
        response.send(error);
      }
    });
  };
  
  const addExercises = async (request, response) => {
    const { name, description } = request.body;
    const id = uuidv4();
    api.pool.query('INSERT INTO exercises (id, name, description) VALUES ($1, $2, $3)', [id, name, description], (error, results) => {
      if(error == null) {
        request.body.id = id
        response.status(201).send(request.body);
      } else {
        response.send(error);
      }
    });
  };
  
  const updateExercises = (request, response) => {
    const id = request.params.id;
    api.pool.query(
      'UPDATE exercises SET name = $1, description = $2 WHERE id = $3', [name, description, id], (error, results) => {
        if(error == null) {
          request.body.id = id
          response.status(200).send(request.body);
        } else {
          response.send(error);
        }
      }
    );
  };
  
  const deleteExercises = (request, response) => {
    const id = request.params.id;
    api.pool.query('DELETE FROM exercises WHERE id = $1', [id], (error, results) => {
      if(error == null) {
        response.status(200).send(`Exercises with id ${id} deleted.`);
      } else {
        response.send(error);
      }
    });
  };
  
  module.exports = {
    getAllExercises,
    getExerciseById,
    addExercises,
    updateExercises,
    deleteExercises
  };


/* Exercises 

var id: UUID
var name: String
var description: String

*/