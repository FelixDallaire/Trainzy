const api = require('./api');
const { 
  v1: uuidv1,
  v4: uuidv4,
  parse: parse
} = require('uuid');

const getAllWorkoutExercises = async (request, response) => {
    api.pool.query('SELECT * FROM wk_exercises', (error, results) => {
      if(error == null) {
        response.status(200).send(results.rows);
      } else {
        response.send(error);
      }
    });
  };
  
  const getWorkoutExerciseById = (request, response) => {
    const id = request.params.id;
    api.pool.query('SELECT * FROM wk_exercises WHERE id = $1', [id], (error, results) => {
      if(error == null) {
        response.status(200).send(results.rows);
      } else {
        response.send(error);
      }
    });
  };

  const getWorkoutExercisesByWorkoutId = (request, response) => {
    const workout_id = request.params.workout_id;
    api.pool.query('SELECT * FROM wk_exercises WHERE workout_id = $1 ORDER BY wk_exercises.position ASC', [workout_id], (error, results) => {
      if(error == null) {
        response.status(200).send(results.rows);
      } else {
        response.send(error);
      }
    });
  };
  

  const addWorkoutExercise = async (request, response) => {
    const { name, position, rep, set, weight, rest_time, workout_id, exercise_id, is_superset} = request.body;
    const id = uuidv4();

    api.pool.query('INSERT INTO wk_exercises (id, name, position, rep, set, weight, rest_time, workout_id, exercise_id, is_superset ) VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10)', 
      [id, name, position, rep, set, weight, rest_time, workout_id, exercise_id, is_superset], (error, results) => {
      if(error == null) {
        request.body.id = id
        response.status(201).send(request.body);
      } else {
        response.send(error);
      }
    });
  };
  
  const  updateWorkoutExercise = (request, response) => {
    const id = request.params.id;
    const { name, position, rep, set, weight, rest_time, workout_id, exercise_id, is_superset } = request.body;

    api.pool.query(
      'UPDATE wk_exercises SET name = $1, position = $2, rep = $3, set = $4, weight = $5, rest_time = $6, workout_id = $7, exercise_id = $8, is_superset = $9 WHERE id = $10', [name, position, rep, set, weight, rest_time, workout_id, exercise_id, is_superset, id], (error, results) => {
        if(error == null) {
          request.body.id = id
          response.status(200).send(request.body);
        } else {
          response.send(error);
        }
      }
    );
  };
  
  const deleteWorkoutExercise = (request, response) => {
    const id = request.params.id;
    api.pool.query('DELETE FROM wk_exercises WHERE id = $1', [id], (error, results) => {
      if(error == null) {
        response.status(200).send(`Exercises with id ${id} deleted.`);
      } else {
        response.send(error);
      }
    });
  };
  
  module.exports = {
    getAllWorkoutExercises,
    getWorkoutExerciseById,
    getWorkoutExercisesByWorkoutId,
    addWorkoutExercise,
    updateWorkoutExercise,
    deleteWorkoutExercise
  };
