import { combineReducers } from 'redux';
import { EVENT_TAB_CLICK } from '../constants/eventConstants';

const tab = (state = '', action) => {
  switch (action.type) {
    case EVENT_TAB_CLICK:
      return action.show;
    default:
      return state;
  }
};

const planned_events = (state = [], action) => {
  return state;
};

const past_events = (state = [], action) => {
  return state;
};

const eventReducer = combineReducers({ tab, planned_events, past_events });

export default eventReducer;