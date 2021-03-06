
// Simple example of a React "smart" component

import { connect } from 'react-redux';
import Map from '../components/Map';
import * as actions from '../actions/eventActionCreators';

// Which part of the Redux global state does our component want to receive as props?
const mapStateToProps = (state) => ({
  litters: state.litters,
  tab: state.tab,
  user_location: state.user_location,
  planned_events: state.planned_events,
  past_events: state.past_events,
  google_map: state.google_map
});

// Don't forget to actually use connect!
// Note that we don't export HelloWorld, but the redux "connected" version of it.
// See https://github.com/reactjs/react-redux/blob/master/docs/api.md#examples
export default connect(mapStateToProps, actions)(Map);
