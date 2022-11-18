const api = require('./api');
const { 
  v1: uuidv1,
  v4: uuidv4,
} = require('uuid');

const getAllWorkoutSessions = async (request, response) => {
    api.pool.query('SELECT * FROM wk_sessions', (error, results) => {
      if(error == null) {
        response.status(200).send(results.rows);
      } else {
        response.send(error);
      }
    });
  };
  
  const getWorkoutSessionById = (request, response) => {
    const id = request.params.id;
    api.pool.query('SELECT * FROM wk_sessions WHERE id = $1', [id], (error, results) => {
      if(error == null) {
        response.status(200).json(results.rows);
      } else {
        response.send(error);
      }
    });
  };

  const getWorkoutSessionByWorkoutId = (request, response) => {
    const workout_id = request.params.workout_id;
    api.pool.query('SELECT * FROM wk_sessions WHERE workout_id = $1', [workout_id], (error, results) => {
      if(error == null) {
        response.status(200).json(results.rows);
      } else {
        response.send(error);
      }
    });
  };
  
  const addWorkoutSession = async (request, response) => {
    const { workout_id, is_started, is_finished } = request.body;
    const id = uuidv4();
    api.pool.query('INSERT INTO wk_sessions (id, workout_id, is_started, is_finished) VALUES ($1, $2, $3, $4)', [id, workout_id, is_started, is_finished], (error, results) => {
      if(error == null) {
        request.body.id = id
        response.status(201).send(request.body);
      } else {
        response.send(error);
      }
    });
  };

  
  const updateWorkoutSession = (request, response) => {
    const id = request.params.id;
    const { workout_id, is_started, is_finished } = request.body;
    api.pool.query(
      'UPDATE wk_sessions SET workout_id = $2, is_started = $3, is_finished = $4 WHERE id = $1', [id, workout_id, is_started, is_finished], (error, results) => {
        if(error == null) {
          request.body.id = id
          response.status(200).send(request.body);
        } else {
          response.send(error);
        }
      }
    );
  };

  const updateWorkoutSessionStatus = (request, response) => {
    const id = request.params.id;
    const { is_started, is_finished } = request.body;
    api.pool.query(
      'UPDATE wk_sessions SET is_started = $2, is_finished = $3 WHERE id = $1', [id, is_started, is_finished], (error, results) => {
        if(error == null) {
          request.body.id = id
          response.status(200).send(request.body);
        } else {
          response.send(error);
        }
      }
    );
  };
  
  const deleteWorkoutSession = (request, response) => {
    const id = request.params.id;
    api.pool.query('DELETE FROM wk_sessions WHERE id = $1', [id], (error, results) => {
      if(error == null) {
        response.status(200).send(`Workout session with id ${id} deleted.`);
      } else {
        response.send(error);
      }
    });
  };
  
  module.exports = {
    getAllWorkoutSessions,
    getWorkoutSessionById,
    getWorkoutSessionByWorkoutId,
    addWorkoutSession,
    updateWorkoutSession,
    updateWorkoutSessionStatus,
    deleteWorkoutSession,
  };