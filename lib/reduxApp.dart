// One simple action: Increment
enum Actions { Increment, Name }

// The reducer, which takes the previous count and increments it in response
// to an Increment action.
int counterReducer(int state, dynamic action) {
  if (action == Actions.Increment) {
    return state + 5;
  }
  else if(action == Actions.Name){
    return state +10;
  }
  return state;
}

