const express = require('express');
const app = express();

const server = app.listen(process.env.PORT || 3000, () => {
  const port = server.address().port;
  console.log(`[Trainzy, Express] are working on port ${port}`);
});

app.use(express.json());

const api = require('./api');
const workouts = require('./workouts')
const exercises = require("./exercises")
const wk_exercises = require("./workout_exercises")
const wk_sessions = require("./workout_sessions")
const wk_exercise_sessions = require("./workout_exercise_sessions")


// OTHER
app.get('/', api.landing);

// WORKOUTS
app.get('/workouts/', workouts.getAllWorkouts);
app.get('/workouts/:id', workouts.getWorkoutById);
app.post('/workouts/', workouts.addWorkout);
app.put('/workouts/:id', workouts.updateWorkout);
app.delete('/workouts/:id', workouts.deleteWorkout);

// EXERCISES
app.get('/exercises/', exercises.getAllExercises);
app.get('/exercises/:id', exercises.getExerciseById);
app.post('/exercises/', exercises.addExercises);
app.put('/exercises/:id', exercises.updateExercises);
app.delete('/exercises/:id', exercises.deleteExercises);

// WORKOOUT EXERCISES
app.get('/wk_exercises/', wk_exercises.getAllWorkoutExercises);
app.get('/wk_exercises/:id', wk_exercises.getWorkoutExerciseById);
app.get('/wk_exercises/workout/:workout_id', wk_exercises.getWorkoutExercisesByWorkoutId);
app.post('/wk_exercises/', wk_exercises.addWorkoutExercise);
app.put('/wk_exercises/:id', wk_exercises.updateWorkoutExercise);
app.delete('/wk_exercises/:id', wk_exercises.deleteWorkoutExercise);

// WK_SESSIONS
app.get('/wk_sessions/', wk_sessions.getAllWorkoutSessions);
app.get('/wk_sessions/:id', wk_sessions.getWorkoutSessionById);
app.get('/wk_sessions/workout/:workout_id', wk_sessions.getWorkoutSessionByWorkoutId);
app.post('/wk_sessions/', wk_sessions.addWorkoutSession);
app.put('/wk_sessions/:id', wk_sessions.updateWorkoutSession);
app.put('/wk_sessions/status/:id', wk_sessions.updateWorkoutSessionStatus);
app.delete('/wk_sessions/:id', wk_sessions.deleteWorkoutSession);

// Workout Exercise Session
app.get('/wk_exercise_sessions/', wk_exercise_sessions.getAllWorkoutExerciseSessions);
app.get('/wk_exercise_sessions/:id', wk_exercise_sessions.getWorkoutExerciseSessionById);
app.get('/wk_exercise_sessions/wk_session/:wk_session_id/wk_exercise/:wk_exercise_id', wk_exercise_sessions.getWorkoutExerciseSessionByWorkoutExerciseId);
app.get('/wk_exercise_sessions/wk_session/:wk_session_id', wk_exercise_sessions.getWorkoutExerciseSessionByWorkoutSessionId);
app.post('/wk_exercise_sessions/', wk_exercise_sessions.addWorkoutExerciseSession);
app.delete('/wk_exercise_sessions/:id', wk_exercise_sessions.deleteWorkoutExerciseSession);


// To Run: npm run serve
