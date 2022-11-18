const api = require('./api');
const { 
  v1: uuidv1,
  v4: uuidv4,
} = require('uuid');

const getAllWorkouts = async (request, response) => {
    api.pool.query('SELECT * FROM workouts', (error, results) => {
      if(error == null) {
        response.status(200).send(results.rows);
      } else {
        response.send(error);
      }
    });
  };
  
  const getWorkoutById = (request, response) => {
    const id = request.params.id;
    api.pool.query('SELECT * FROM workouts WHERE id = $1', [id], (error, results) => {
      if(error == null) {
        response.status(200).json(results.rows);
      } else {
        response.send(error);
      }
    });
  };
  
  const addWorkout = async (request, response) => {
    const { name } = request.body;
    const id = uuidv4();
    api.pool.query('INSERT INTO workouts (id, name) VALUES ($1, $2)', [id, name], (error, results) => {
      if(error == null) {
        request.body.id = id
        response.status(201).send(request.body);
      } else {
        response.send(error);
      }
    });
  };
  
  const updateWorkout = (request, response) => {
    const id = request.params.id;
    const { name } = request.body;
    api.pool.query(
      'UPDATE workouts SET name = $1 WHERE id = $2', [name, id], (error, results) => {
        if(error == null) {
          request.body.id = id
          response.status(200).send(request.body);
        } else {
          response.send(error);
        }
      }
    );
  };
  
  const deleteWorkout = (request, response) => {
    const id = request.params.id;
    api.pool.query('DELETE FROM workouts WHERE id = $1', [id], (error, results) => {
      if(error == null) {
        response.status(200).send(`Workout with id ${id} deleted.`);
      } else {
        response.send(error);
      }
    });
  };
  
  module.exports = {
    getAllWorkouts,
    getWorkoutById,
    addWorkout,
    updateWorkout,
    deleteWorkout
  };


  const Workout = {
    id: uuidv4,
    name: String,
  }