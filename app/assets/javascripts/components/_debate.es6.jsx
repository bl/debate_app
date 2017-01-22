class Debate extends React.Component {
  render () {
    return (
      <div>
        <div>Topic: { this.props.topic }</div>
        <MessageList messages={ this.state.messages } />
      </div>
    );
  }
}

Debate.propTypes = {
  topic: React.PropTypes.string,
  messages: React.PropTypes.instanceOf(MessageList)
};
